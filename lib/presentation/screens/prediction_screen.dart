import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/constants.dart';
import '../../utils/prediction_engine.dart';
import '../../utils/llm_parser_service.dart';
import '../../data/models/prediction_result.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/user_provider.dart';

class PredictionScreen extends ConsumerStatefulWidget {
  const PredictionScreen({super.key});

  @override
  ConsumerState<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends ConsumerState<PredictionScreen> {
  bool _isLoading = false;
  PredictionResult? _localResult;
  NutritionAdviceResult? _llmAdvice;
  String? _error;
  List<FoodItemData> _allFoodItems = [];

  @override
  void initState() {
    super.initState();
    _runPrediction();
  }

  Future<void> _runPrediction() async {
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

      // 모든 영수증의 식료품 항목 가져오기 (누적)
      _allFoodItems = [];
      for (final receipt in receipts) {
        final items = await receiptRepo.getFoodItemsByReceipt(receipt.id);
        _allFoodItems.addAll(items);
      }

      // 1. 로컬 예측 엔진 실행 (기본 분석)
      final engine = PredictionEngine();
      final localResult = await engine.predictMetabolicRisk(
        user: user,
        recentFoodItems: _allFoodItems.cast(),
        analyzeDays: 30,
      );

      setState(() {
        _localResult = localResult;
      });

      // 2. LLM 영양 조언 요청 (데이터가 있을 경우)
      if (_allFoodItems.isNotEmpty) {
        final llmService = LlmParserService();

        // 구매 이력 데이터 변환
        final purchaseHistory = _allFoodItems.map((item) => {
          'name': item.name,
          'category': item.category,
          'price': item.price,
          'calories': item.calories,
          'sodiumMg': item.sodiumMg,
          'sugarG': item.sugarG,
          'fatG': item.fatG,
          'proteinG': item.proteinG,
          'carbsG': item.carbsG,
        }).toList();

        // 사용자 프로필
        final userProfile = {
          'age': user.age,
          'gender': user.gender,
          'height': user.height,
          'weight': user.weight,
          'bmi': user.weight / ((user.height / 100) * (user.height / 100)),
        };

        // 현재 분석 데이터
        final currentAnalysis = {
          'metabolicScore': localResult.metabolicScore,
          'riskLevel': localResult.riskLevel,
          'totalSodiumDailyMg': localResult.totalSodiumDailyMg,
          'totalCaloriesDaily': localResult.totalCaloriesDaily,
          'totalSugarDailyG': localResult.totalSugarDailyG,
        };

        final llmAdvice = await llmService.getNutritionAdvice(
          userProfile: userProfile,
          purchaseHistory: purchaseHistory,
          currentAnalysis: currentAnalysis,
        );

        setState(() {
          _llmAdvice = llmAdvice;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대사증후군 위험도 분석'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runPrediction,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('AI가 건강 데이터를 분석 중...'),
                  SizedBox(height: 8),
                  Text(
                    '맞춤형 영양 조언을 준비하고 있습니다',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('분석 실패: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _runPrediction,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : _localResult == null
                  ? _buildNoDataView()
                  : _buildResultView(),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            '분석할 데이터가 없습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '영수증을 촬영하여 구매 이력을 추가하세요',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final result = _localResult!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AI 종합 평가 (LLM 결과)
          if (_llmAdvice != null) _buildAiAssessmentCard(_llmAdvice!),
          if (_llmAdvice != null) const SizedBox(height: 16),

          // 위험도 카드
          _buildRiskLevelCard(result),
          const SizedBox(height: 16),

          // 대사 점수 차트
          _buildMetabolicScoreChart(result),
          const SizedBox(height: 16),

          // 세부 분석
          _buildDetailedAnalysis(result),
          const SizedBox(height: 16),

          // AI 맞춤 추천 (LLM 결과)
          if (_llmAdvice != null) _buildAiRecommendations(_llmAdvice!),
          if (_llmAdvice != null) const SizedBox(height: 16),

          // 미래 예측 (LLM 결과 우선)
          if (_llmAdvice != null)
            _buildAiFuturePredictions(_llmAdvice!)
          else
            _buildFuturePredictions(result),
          const SizedBox(height: 16),

          // 실천 계획 (LLM 결과)
          if (_llmAdvice != null) _buildActionPlan(_llmAdvice!),
        ],
      ),
    );
  }

  Widget _buildAiAssessmentCard(NutritionAdviceResult advice) {
    final assessment = advice.overallAssessment;
    final levelColor = _getLevelColor(assessment.level);

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.psychology, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AI 종합 평가',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${assessment.score}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                    const Text('건강 점수', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    assessment.level,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                assessment.summary,
                style: const TextStyle(fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskLevelCard(PredictionResult result) {
    final riskColor = _getRiskColor(result.riskLevel);
    final riskIcon = _getRiskIcon(result.riskLevel);

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              riskColor.withOpacity(0.1),
              riskColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(riskIcon, size: 64, color: riskColor),
            const SizedBox(height: 16),
            Text(
              result.riskLevel,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: riskColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '대사 점수: ${result.metabolicScore.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              '총 ${_allFoodItems.length}개 품목 분석',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetabolicScoreChart(PredictionResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '위험 요인 분석',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final entries = result.riskFactors.entries.toList();
                          if (value.toInt() < entries.length) {
                            return Text(
                              entries[value.toInt()].key,
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}',
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: result.riskFactors.entries.toList().asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value,
                          color: _getBarColor(entry.key),
                          width: 40,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBarColor(int index) {
    final colors = [Colors.blue, Colors.orange, Colors.purple, Colors.red];
    return colors[index % colors.length];
  }

  Widget _buildDetailedAnalysis(PredictionResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '세부 분석',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildAnalysisRow(
              'BMI',
              result.bmi.toStringAsFixed(1),
              _getBmiStatus(result.bmi),
              _getBmiColor(result.bmi),
            ),
            const Divider(),
            _buildAnalysisRow(
              '평균 나트륨',
              '${result.totalSodiumDailyMg}mg',
              '${(result.totalSodiumDailyMg / AppConstants.dailySodiumLimitMg * 100).toStringAsFixed(0)}%',
              _getPercentColor(result.totalSodiumDailyMg / AppConstants.dailySodiumLimitMg * 100),
            ),
            const Divider(),
            _buildAnalysisRow(
              '평균 칼로리',
              '${result.totalCaloriesDaily}kcal',
              '${(result.totalCaloriesDaily / AppConstants.dailyCaloriesLimitKcal * 100).toStringAsFixed(0)}%',
              _getPercentColor(result.totalCaloriesDaily / AppConstants.dailyCaloriesLimitKcal * 100),
            ),
            const Divider(),
            _buildAnalysisRow(
              '평균 당류',
              '${result.totalSugarDailyG.toStringAsFixed(1)}g',
              '${(result.totalSugarDailyG / AppConstants.dailySugarLimitG * 100).toStringAsFixed(0)}%',
              _getPercentColor(result.totalSugarDailyG / AppConstants.dailySugarLimitG * 100),
            ),
          ],
        ),
      ),
    );
  }

  String _getBmiStatus(double bmi) {
    if (bmi < AppConstants.bmiUnderweight) return '저체중';
    if (bmi < AppConstants.bmiNormal) return '정상';
    if (bmi < AppConstants.bmiOverweight) return '과체중';
    return '비만';
  }

  Widget _buildAnalysisRow(
      String label, String value, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiRecommendations(NutritionAdviceResult advice) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI 맞춤 추천',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...advice.personalizedTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiFuturePredictions(NutritionAdviceResult advice) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.timeline, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI 미래 예측',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '현재 식습관 유지 시 예상 건강 상태',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...advice.futurePredictions.entries.map(
              (entry) {
                final prediction = entry.value;
                final riskColor = _getRiskColor(prediction.riskLevel);
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: riskColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: riskColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              prediction.riskLevel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: riskColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        prediction.explanation,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                      if (prediction.mainRisks.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: prediction.mainRisks.map((risk) => Chip(
                            label: Text(risk, style: const TextStyle(fontSize: 11)),
                            backgroundColor: riskColor.withOpacity(0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuturePredictions(PredictionResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '미래 예측',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '현재 식습관 유지 시 예상 위험도',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...result.futurePredictions.entries.map(
              (entry) {
                final riskLevel = _scoreToRiskLevel(entry.value);
                final riskColor = _getRiskColor(riskLevel);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.key} 후',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          riskLevel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: riskColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPlan(NutritionAdviceResult advice) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.checklist, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  '실천 계획',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 즉시 실천
            if (advice.actionPlan.immediate.isNotEmpty) ...[
              _buildActionSection('즉시 실천', advice.actionPlan.immediate, Colors.red),
              const SizedBox(height: 12),
            ],

            // 단기 계획 (1-3개월)
            if (advice.actionPlan.shortTerm.isNotEmpty) ...[
              _buildActionSection('1-3개월 내', advice.actionPlan.shortTerm, Colors.orange),
              const SizedBox(height: 12),
            ],

            // 장기 계획
            if (advice.actionPlan.longTerm.isNotEmpty) ...[
              _buildActionSection('장기 목표', advice.actionPlan.longTerm, Colors.blue),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.arrow_right, color: color, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(item, style: const TextStyle(fontSize: 13, height: 1.4)),
              ),
            ],
          ),
        )),
      ],
    );
  }

  String _scoreToRiskLevel(double score) {
    if (score < 25) return '정상';
    if (score < 50) return '주의';
    if (score < 75) return '위험';
    return '고위험';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case '정상':
      case '양호':
        return Colors.green;
      case '주의':
        return Colors.orange;
      case '위험':
      case '경고':
        return Colors.deepOrange;
      case '고위험':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case '양호':
        return Colors.green;
      case '주의':
        return Colors.orange;
      case '경고':
        return Colors.deepOrange;
      case '위험':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel) {
      case '정상':
        return Icons.check_circle;
      case '주의':
        return Icons.warning;
      case '위험':
        return Icons.error;
      case '고위험':
        return Icons.dangerous;
      default:
        return Icons.help;
    }
  }

  Color _getBmiColor(double bmi) {
    if (bmi < AppConstants.bmiUnderweight) {
      return Colors.blue;
    } else if (bmi < AppConstants.bmiNormal) {
      return Colors.green;
    } else if (bmi < AppConstants.bmiOverweight) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getPercentColor(double percent) {
    if (percent < 50) {
      return Colors.green;
    } else if (percent < 80) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
