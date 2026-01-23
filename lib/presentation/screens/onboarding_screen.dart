import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'M';
  String? _selectedMbti;

  // MBTI 유형 목록
  static const List<String> _mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP',
  ];

  final Map<String, bool> _familyHistory = {
    '당뇨병': false,
    '고혈압': false,
    '심장병': false,
    '이상지질혈증': false,
  };
  bool _hasExistingConditions = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await ref.read(userProvider.notifier).createProfile(
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
          familyHistory: _familyHistory,
          existingConditions: {'has_conditions': _hasExistingConditions},
          mbti: _selectedMbti,
        );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      // 홈 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 저장에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 설정'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 안내 메시지
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline,
                        size: 48, color: AppTheme.primaryColor),
                    const SizedBox(height: 12),
                    Text(
                      '건강 위험도 예측을 위해\n기본 정보를 입력해주세요',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 나이
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: '나이',
                  hintText: '예: 30',
                  suffixText: '세',
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나이를 입력해주세요';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 18 || age > 100) {
                    return '18-100 사이의 나이를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 성별
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: '성별',
                  prefixIcon: Icon(Icons.person),
                ),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('남성')),
                  DropdownMenuItem(value: 'F', child: Text('여성')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // MBTI (선택사항)
              DropdownButtonFormField<String>(
                value: _selectedMbti,
                decoration: const InputDecoration(
                  labelText: 'MBTI (선택사항)',
                  hintText: '모르면 선택 안해도 됩니다',
                  prefixIcon: Icon(Icons.psychology),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('선택 안함'),
                  ),
                  ..._mbtiTypes.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMbti = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 키
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: '키',
                  hintText: '예: 170',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '키를 입력해주세요';
                  }
                  final height = double.tryParse(value);
                  if (height == null || height < 100 || height > 250) {
                    return '100-250 사이의 키를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 몸무게
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: '몸무게',
                  hintText: '예: 70',
                  suffixText: 'kg',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '몸무게를 입력해주세요';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 200) {
                    return '30-200 사이의 몸무게를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // 가족력
              Text(
                '가족력 (해당사항 체크)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ..._familyHistory.keys.map((disease) {
                return CheckboxListTile(
                  title: Text(disease),
                  value: _familyHistory[disease],
                  onChanged: (value) {
                    setState(() {
                      _familyHistory[disease] = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              const SizedBox(height: 24),

              // 기저질환
              SwitchListTile(
                title: const Text('현재 기저질환이 있습니까?'),
                value: _hasExistingConditions,
                onChanged: (value) {
                  setState(() {
                    _hasExistingConditions = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),

              // 의료 고지문
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppConstants.medicalDisclaimer,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 저장 버튼
              ElevatedButton(
                onPressed: _isLoading ? null : _submitProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        '프로필 저장하고 시작하기',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
