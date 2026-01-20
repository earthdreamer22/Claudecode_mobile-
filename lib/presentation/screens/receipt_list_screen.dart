import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../providers/database_provider.dart';
import '../providers/user_provider.dart';
import '../../data/database/app_database.dart';

class ReceiptListScreen extends ConsumerStatefulWidget {
  const ReceiptListScreen({super.key});

  @override
  ConsumerState<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends ConsumerState<ReceiptListScreen> {
  List<ReceiptData> _receipts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReceipts();
  }

  Future<void> _loadReceipts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userAsync = ref.read(userProvider);
      final user = userAsync.value;

      if (user == null) {
        throw Exception('사용자 정보를 찾을 수 없습니다');
      }

      final receiptRepo = ref.read(receiptRepositoryProvider);
      final receipts = await receiptRepo.getReceiptsByUser(user.id);

      setState(() {
        _receipts = receipts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteReceipt(int receiptId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('영수증 삭제'),
        content: const Text('이 영수증을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final receiptRepo = ref.read(receiptRepositoryProvider);
      await receiptRepo.deleteReceipt(receiptId);
      _loadReceipts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('영수증이 삭제되었습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영수증 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReceipts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('오류: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadReceipts,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : _receipts.isEmpty
                  ? _buildEmptyState()
                  : _buildReceiptList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '저장된 영수증이 없습니다',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '영수증을 촬영하여 추가하세요',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptList() {
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    final priceFormat = NumberFormat('#,###');

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: _receipts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final receipt = _receipts[index];
        return _buildReceiptCard(receipt, dateFormat, priceFormat);
      },
    );
  }

  Widget _buildReceiptCard(
    ReceiptData receipt,
    DateFormat dateFormat,
    NumberFormat priceFormat,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showReceiptDetail(receipt),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // 영수증 이미지 썸네일
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 80,
                  child: receipt.imagePath.isNotEmpty &&
                          File(receipt.imagePath).existsSync()
                      ? Image.file(
                          File(receipt.imagePath),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.receipt, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // 영수증 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(receipt.receiptDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${receipt.parsedItemCount ?? 0}개 항목',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${priceFormat.format(receipt.totalAmount ?? 0)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              // 삭제 버튼
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _deleteReceipt(receipt.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showReceiptDetail(ReceiptData receipt) async {
    final receiptRepo = ref.read(receiptRepositoryProvider);
    final foodItems = await receiptRepo.getFoodItemsByReceipt(receipt.id);
    final priceFormat = NumberFormat('#,###');

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 헤더
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '영수증 상세',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${priceFormat.format(receipt.totalAmount ?? 0)}원',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // 식료품 목록
            Expanded(
              child: foodItems.isEmpty
                  ? const Center(child: Text('식료품 항목이 없습니다'))
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: foodItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = foodItems[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(item.category),
                            child: Text(
                              item.category[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.category),
                              if (item.calories != null)
                                Text(
                                  '${item.calories}kcal, 나트륨 ${item.sodiumMg ?? 0}mg',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          trailing: Text(
                            '${priceFormat.format(item.price ?? 0)}원',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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
}
