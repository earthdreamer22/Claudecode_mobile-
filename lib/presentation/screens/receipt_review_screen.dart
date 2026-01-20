import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../utils/food_parser.dart';
import '../../utils/llm_parser_service.dart';
import '../providers/database_provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class ReceiptReviewScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final String ocrText;

  const ReceiptReviewScreen({
    super.key,
    required this.imagePath,
    required this.ocrText,
  });

  @override
  ConsumerState<ReceiptReviewScreen> createState() =>
      _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends ConsumerState<ReceiptReviewScreen> {
  bool _isExpanded = false;
  bool _isProcessing = false;
  List<ParsedFoodItemWithNutrition> _parsedItems = [];
  bool _isParsed = false;

  @override
  void initState() {
    super.initState();
    _parseReceipt();
  }

  Future<void> _parseReceipt() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // 1차: LLM API로 파싱 시도
      final llmParser = LlmParserService();
      final llmResult = await llmParser.parseReceipt(ocrText: widget.ocrText);

      if (llmResult != null && llmResult.items.isNotEmpty) {
        // LLM 파싱 성공 - LLM 결과를 ParsedFoodItem으로 변환
        print('LLM 파싱 성공: ${llmResult.items.length}개 항목');

        final parser = FoodParser();
        final parsedItems = llmResult.items.map((item) => ParsedFoodItem(
          name: item.name,
          price: item.price,
          category: _guessCategory(item.name),
          rawLine: '${item.name} ${item.price}',
          lineNumber: 0,
        )).toList();

        final itemsWithNutrition = await parser.matchWithNutritionDatabase(parsedItems);

        setState(() {
          _parsedItems = itemsWithNutrition;
          _isParsed = true;
          _isProcessing = false;
        });
        return;
      }

      // 2차: LLM 실패 시 기존 로컬 파싱 fallback
      print('LLM 파싱 실패 - 로컬 파싱으로 fallback');
      final parser = FoodParser();
      final parsedItems = await parser.parseReceiptText(widget.ocrText);
      final itemsWithNutrition =
          await parser.matchWithNutritionDatabase(parsedItems);

      setState(() {
        _parsedItems = itemsWithNutrition;
        _isParsed = true;
        _isProcessing = false;
      });
    } catch (e) {
      print('파싱 오류: $e');
      setState(() {
        _isProcessing = false;
      });
      _showError('파싱 실패: $e');
    }
  }

  String _guessCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('우유') || lowerName.contains('치즈') || lowerName.contains('요거트') || lowerName.contains('버터')) {
      return '유제품';
    } else if (lowerName.contains('돼지') || lowerName.contains('소고기') || lowerName.contains('닭') || lowerName.contains('삼겹')) {
      return '육류';
    } else if (lowerName.contains('사과') || lowerName.contains('바나나') || lowerName.contains('포도') || lowerName.contains('딸기')) {
      return '과일';
    } else if (lowerName.contains('양파') || lowerName.contains('당근') || lowerName.contains('배추') || lowerName.contains('시금치')) {
      return '채소';
    } else if (lowerName.contains('음료') || lowerName.contains('주스') || lowerName.contains('커피') || lowerName.contains('콜라') || lowerName.contains('물')) {
      return '음료';
    } else if (lowerName.contains('쌀') || lowerName.contains('밀가루') || lowerName.contains('빵') || lowerName.contains('면')) {
      return '곡류';
    } else if (lowerName.contains('라면') || lowerName.contains('통조림') || lowerName.contains('소시지') || lowerName.contains('햄')) {
      return '가공식품';
    }
    return '기타';
  }

  Future<void> _saveReceipt() async {
    if (_parsedItems.isEmpty) {
      _showError('저장할 식료품이 없습니다.');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final userAsync = ref.read(userProvider);
      final user = userAsync.value;

      if (user == null) {
        _showError('사용자 정보를 찾을 수 없습니다.');
        return;
      }

      final receiptRepo = ref.read(receiptRepositoryProvider);

      // 영수증 저장
      final receiptId = await receiptRepo.createReceipt(
        userId: user.id,
        imagePath: widget.imagePath,
        ocrText: widget.ocrText,
        totalAmount: _parsedItems.fold<int>(
            0, (sum, item) => sum + item.parsedItem.price),
        itemCount: _parsedItems.length,
      );

      // 식료품 항목 저장
      for (final item in _parsedItems) {
        await receiptRepo.createFoodItem(
          receiptId: receiptId,
          name: item.displayName,
          category: item.category,
          price: item.price,
          nutritionData: item.nutrition,
        );
      }

      if (!mounted) return;

      // AI 분석 모달 표시 및 LLM 호출
      await _showAiAnalysisDialog(user.id, receiptRepo);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      _showError('저장 실패: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  /// AI 분석 다이얼로그 표시 및 LLM 호출
  Future<void> _showAiAnalysisDialog(int userId, dynamic receiptRepo) async {
    // 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _AiAnalysisLoadingDialog(),
    );

    try {
      final userAsync = ref.read(userProvider);
      final user = userAsync.value;
      if (user == null) {
        if (mounted) Navigator.of(context).pop();
        return;
      }

      // 사용자의 전체 영수증 목록 조회
      final receipts = await receiptRepo.getReceiptsByUser(userId);

      // 구매 이력 데이터 생성
      final purchaseHistory = <Map<String, dynamic>>[];
      for (final receipt in receipts) {
        final foodItems = await receiptRepo.getFoodItemsByReceipt(receipt.id);
        for (final item in foodItems) {
          purchaseHistory.add({
            'name': item.name,
            'category': item.category,
            'price': item.price?.toInt() ?? 0,
            'calories': item.calories,
            'sodium': item.sodiumMg,
            'sugar': item.sugarG,
            'fat': item.fatG,
            'protein': item.proteinG,
            'carbs': item.carbsG,
            'date': receipt.receiptDate.toIso8601String(),
          });
        }
      }

      if (purchaseHistory.isNotEmpty) {
        // 사용자 프로필 생성
        final userProfile = {
          'age': user.age,
          'gender': user.gender,
          'height': user.height,
          'weight': user.weight,
        };

        // LLM 영양 조언 호출
        final llmService = LlmParserService();
        final advice = await llmService.getNutritionAdvice(
          userProfile: userProfile,
          purchaseHistory: purchaseHistory,
        );

        if (advice != null) {
          // DB에 저장
          await receiptRepo.saveNutritionAnalysis(
            userId: userId,
            advice: advice,
          );
          print('영양 분석 결과 저장 완료');
        }
      }
    } catch (e) {
      print('영양 분석 저장 실패: $e');
    } finally {
      // 다이얼로그 닫기
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _retake() {
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _addManualItem() {
    showDialog(
      context: context,
      builder: (context) => _AddFoodItemDialog(
        onAdd: (name, price, category) {
          setState(() {
            _parsedItems.add(ParsedFoodItemWithNutrition(
              parsedItem: ParsedFoodItem(
                name: name,
                price: price,
                category: category,
                rawLine: '수동 추가',
                lineNumber: 0,
              ),
              nutrition: null,
              matchConfidence: 0.0,
            ));
          });
        },
      ),
    );
  }

  void _editItem(int index) {
    final item = _parsedItems[index];
    showDialog(
      context: context,
      builder: (context) => _AddFoodItemDialog(
        initialName: item.displayName,
        initialPrice: item.price,
        initialCategory: item.category,
        isEdit: true,
        onAdd: (name, price, category) {
          setState(() {
            _parsedItems[index] = ParsedFoodItemWithNutrition(
              parsedItem: ParsedFoodItem(
                name: name,
                price: price,
                category: category,
                rawLine: item.parsedItem.rawLine,
                lineNumber: item.parsedItem.lineNumber,
              ),
              nutrition: item.nutrition,
              matchConfidence: item.matchConfidence,
            );
          });
        },
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _parsedItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('항목이 삭제되었습니다')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.ocrText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('영수증 확인'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('영수증 검증'),
                  content: const Text(
                    'OCR로 추출된 식료품을 확인하세요.\n\n'
                    '• 자동 파싱된 항목을 수정할 수 있습니다\n'
                    '• 누락된 항목을 수동으로 추가할 수 있습니다\n'
                    '• 영양정보가 자동으로 매칭됩니다',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('식료품 파싱 중...'),
                ],
              ),
            )
          : Column(
              children: [
                // 영수증 이미지 미리보기
                Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: Center(
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // 구분선
                const Divider(height: 1),

                // 파싱된 식료품 목록
                Expanded(
                  child: _isParsed
                      ? _buildParsedItemsList()
                      : _buildOcrTextView(lines),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isParsed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton.icon(
                    onPressed: _addManualItem,
                    icon: const Icon(Icons.add),
                    label: const Text('항목 추가'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
              Row(
                children: [
                  // 다시 촬영
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _retake,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('다시 촬영'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 저장
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isParsed && !_isProcessing
                          ? _saveReceipt
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text('확인 및 저장'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParsedItemsList() {
    if (_parsedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined,
                size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              '식료품을 찾을 수 없습니다',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _addManualItem,
              icon: const Icon(Icons.add),
              label: const Text('수동으로 추가하기'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 요약 정보
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          color: Colors.blue.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_basket, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '${_parsedItems.length}개 항목',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '총 ${_formatPrice(_parsedItems.fold<int>(0, (sum, item) => sum + item.price))}원',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // 항목 리스트
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: _parsedItems.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = _parsedItems[index];
              return _buildFoodItemTile(item, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItemTile(ParsedFoodItemWithNutrition item, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getCategoryColor(item.category),
        child: Text(
          item.category[0],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        item.displayName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_formatPrice(item.price)}원 • ${item.category}'),
          if (item.hasNutrition)
            Text(
              '${item.nutrition!.calories}kcal, 나트륨 ${item.nutrition!.sodiumMg}mg',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            )
          else
            Text(
              '영양정보 없음',
              style: TextStyle(fontSize: 12, color: Colors.orange[700]),
            ),
        ],
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 8),
                Text('수정'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 8),
                Text('삭제', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'edit') {
            _editItem(index);
          } else if (value == 'delete') {
            _deleteItem(index);
          }
        },
      ),
    );
  }

  Widget _buildOcrTextView(List<String> lines) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OCR 추출 텍스트',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                label: Text(_isExpanded ? '접기' : '펼치기'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 통계
          Wrap(
            spacing: 12,
            children: [
              Chip(
                label: Text('${lines.length}줄'),
                avatar: const Icon(Icons.format_list_numbered, size: 16),
              ),
              Chip(
                label: Text('${widget.ocrText.length}자'),
                avatar: const Icon(Icons.text_fields, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // OCR 텍스트 표시
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _isExpanded
                  ? lines
                      .map((line) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              line,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ))
                      .toList()
                  : [
                      ...lines.take(10).map((line) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              line,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )),
                      if (lines.length > 10)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '... ${lines.length - 10}줄 더 보기',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '육류':
        return Colors.red[400]!;
      case '채소':
        return Colors.green[400]!;
      case '과일':
        return Colors.orange[400]!;
      case '곡류':
        return Colors.brown[400]!;
      case '유제품':
        return Colors.blue[400]!;
      case '음료':
        return Colors.cyan[400]!;
      case '가공식품':
        return Colors.purple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}

// 식료품 추가/수정 다이얼로그
class _AddFoodItemDialog extends StatefulWidget {
  final Function(String name, int price, String category) onAdd;
  final String? initialName;
  final int? initialPrice;
  final String? initialCategory;
  final bool isEdit;

  const _AddFoodItemDialog({
    required this.onAdd,
    this.initialName,
    this.initialPrice,
    this.initialCategory,
    this.isEdit = false,
  });

  @override
  State<_AddFoodItemDialog> createState() => _AddFoodItemDialogState();
}

class _AddFoodItemDialogState extends State<_AddFoodItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late String _selectedCategory;

  final List<String> _categories = [
    '육류',
    '채소',
    '과일',
    '곡류',
    '유제품',
    '음료',
    '가공식품',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _priceController =
        TextEditingController(text: widget.initialPrice?.toString() ?? '');
    _selectedCategory = widget.initialCategory ?? '기타';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? '항목 수정' : '항목 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '제품명',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: '가격 (원)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: '카테고리',
              border: OutlineInputBorder(),
            ),
            items: _categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final price = int.tryParse(_priceController.text.trim());

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('제품명을 입력해주세요')),
              );
              return;
            }

            if (price == null || price <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('올바른 가격을 입력해주세요')),
              );
              return;
            }

            widget.onAdd(name, price, _selectedCategory);
            Navigator.pop(context);
          },
          child: Text(widget.isEdit ? '수정' : '추가'),
        ),
      ],
    );
  }
}

/// AI 분석 로딩 다이얼로그
class _AiAnalysisLoadingDialog extends StatefulWidget {
  const _AiAnalysisLoadingDialog();

  @override
  State<_AiAnalysisLoadingDialog> createState() => _AiAnalysisLoadingDialogState();
}

class _AiAnalysisLoadingDialogState extends State<_AiAnalysisLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  int _dotCount = 0;

  final List<String> _messages = [
    'AI가 영수증을 분석하고 있습니다',
    '구매 패턴을 파악하고 있습니다',
    '영양 정보를 계산하고 있습니다',
    '맞춤형 건강 조언을 생성하고 있습니다',
  ];
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 점 애니메이션
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
        return true;
      }
      return false;
    });

    // 메시지 변경
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI 아이콘 애니메이션
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 메인 메시지
            Text(
              '${_messages[_messageIndex]}${'.' * _dotCount}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 프로그레스 바
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue.shade400,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 서브 메시지
            Text(
              '잠시만 기다려주세요',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
