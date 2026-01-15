import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/constants.dart';
import '../../utils/prediction_engine.dart';
import '../../data/models/prediction_result.dart';
import '../providers/database_provider.dart';
import '../providers/user_provider.dart';

class PredictionScreen extends ConsumerStatefulWidget {
  const PredictionScreen({super.key});

  @override
  ConsumerState<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends ConsumerState<PredictionScreen> {
  bool _isLoading = false;
  PredictionResult? _result;
  String? _error;

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

      // 최근 영수증들의 식료품 항목 가져오기
      final allFoodItems = <dynamic>[];
      for (final receipt in receipts.take(10)) {
        final items = await receiptRepo.getFoodItemsByReceipt(receipt.id);
        allFoodItems.addAll(items);
      }

      final engine = PredictionEngine();
      final result = await engine.predictMetabolicRisk(
        user: user,
        recentFoodItems: allFoodItems.cast(),
        analyzeDays: 30,
      );

      setState(() {
        _result = result;
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
                  Text('건강 데이터 분석 중...'),
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
              : _result == null
                  ? const Center(child: Text('데이터가 없습니다'))
                  : _buildResultView(),
    );
  }

  Widget _buildResultView() {
    final result = _result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 위험도 카드
          _buildRiskLevelCard(result),
          const SizedBox(height: 16),

          // 대사 점수 차트
          _buildMetabolicScoreChart(result),
          const SizedBox(height: 16),

          // 세부 분석
          _buildDetailedAnalysis(result),
          const SizedBox(height: 16),

          // 추천 사항
          _buildRecommendations(result),
          const SizedBox(height: 16),

          // 미래 예측
          _buildFuturePredictions(result),
        ],
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
              '최근 30일간 데이터 분석',
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

  Widget _buildRecommendations(PredictionResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '맞춤 추천',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...result.recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(fontSize: 14, height: 1.4),
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

  String _scoreToRiskLevel(double score) {
    if (score < 25) return '정상';
    if (score < 50) return '주의';
    if (score < 75) return '위험';
    return '고위험';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case '정상':
        return Colors.green;
      case '주의':
        return Colors.orange;
      case '위험':
        return Colors.deepOrange;
      case '고위험':
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
