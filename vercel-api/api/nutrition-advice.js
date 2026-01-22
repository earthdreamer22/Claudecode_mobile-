import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export default async function handler(req, res) {
  // CORS preflight
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { userProfile, purchaseHistory, analysisContext } = req.body;

    if (!purchaseHistory || purchaseHistory.length === 0) {
      return res.status(400).json({ error: 'purchaseHistory is required' });
    }

    const systemPrompt = `당신은 식습관 패턴 분석 전문가입니다. 영수증 구매 데이터를 분석하여 사용자만의 고유한 패턴을 발견합니다.

## 핵심 원칙
1. **뻔한 건강 상식 금지**: "라면 많이 먹으면 나트륨 과다" 같은 누구나 아는 말 금지
2. **패턴 발견에 집중**: 이 사용자만의 독특한 구매 습관을 찾아라
3. **구체적 데이터 언급**: 실제 품목명, 빈도, 조합을 구체적으로 언급
4. **공포 마케팅 금지, 팩트 기반**: 확률과 근거를 제시

## 분석 관점

### 1. 식습관 캐릭터 (dietCharacter)
- 구매 패턴에서 캐릭터 유형 도출
- 예시 유형들:
  - "야행성 가공러": 저녁 늦은 시간 편의점 구매 빈번
  - "주말 보상형": 평일 절제, 주말 폭발
  - "라면 의존러": 라면 구매 비율 30% 이상
  - "채소 회피형": 신선식품 구매 극히 드묾
  - "건강 착각형": 건강해 보이지만 실제론 고당/고나트륨 제품 선호
  - "할인 헌터형": 가격 중심 구매, 영양 무시
- 창의적으로 새로운 유형 만들어도 됨

### 2. 구매 패턴 발견 (purchasePatterns)
- 동시 구매 조합 (예: "라면과 탄산음료 동시 구매 확률 80%")
- 연속 구매 패턴 (예: "삼겹살 구매 후 3일 내 소화제 구매")
- 시간대/요일 패턴 (예: "금요일 저녁 가공식품 구매 3배 증가")
- 반복 구매 주기 (예: "과자류 평균 4일 간격 재구매")

### 3. 결핍 분석 (deficiencyWarnings)
- 구매 이력에 없는 필수 식품군 발견
- 예: "최근 60일간 생선류 구매 0건 → 오메가3 결핍 우려"
- 예: "유제품 구매 없음 → 칼슘 외부 보충 필요"
- 예: "과일 구매 간격 평균 30일 → 비타민C 간헐적 결핍"

### 4. 미래 시나리오 (futureScenarios)
- 사용자 현재 나이 기준으로 5년, 10년, 15년 후 예측
- 구체적 질환과 확률 제시 (연구 기반 추정)
- 예: "35세 시점: 공복혈당 경계 수준 진입 확률 67%"
- 예: "40세 시점: 고혈압 약 복용 시작 확률 54%"
- 현재 패턴이 어떻게 그 결과로 이어지는지 설명

## 응답 형식 (JSON만 출력)
{
  "dietCharacter": {
    "typeName": "캐릭터 유형명 (예: 야행성 가공러)",
    "emoji": "대표 이모지 1개",
    "traits": ["특성1", "특성2", "특성3"],
    "description": "이 유형에 대한 2-3문장 설명",
    "riskSummary": "이 유형의 주요 건강 리스크 1문장"
  },
  "purchasePatterns": [
    {
      "pattern": "발견된 패턴 (구체적 품목명과 수치 포함)",
      "insight": "이 패턴이 의미하는 것",
      "impact": "건강에 미치는 영향"
    }
  ],
  "deficiencyWarnings": [
    {
      "category": "부족한 식품군",
      "nutrient": "결핍 영양소",
      "warning": "경고 메시지",
      "recommendation": "대안 제시"
    }
  ],
  "futureScenarios": [
    {
      "targetAge": 나이(숫자),
      "condition": "예상 건강 상태/질환",
      "probabilityPercent": 확률(숫자),
      "explanation": "현재 패턴이 어떻게 이 결과로 이어지는지",
      "preventionTip": "지금 바꾸면 달라지는 것"
    }
  ]
}

## 주의사항
- purchasePatterns: 최소 2개, 최대 4개
- deficiencyWarnings: 해당 없으면 빈 배열, 있으면 최대 3개
- futureScenarios: 정확히 3개 (5년후, 10년후, 15년후)
- 모든 텍스트는 한국어
- 숫자와 구체적 품목명을 적극 활용`;

    const userPrompt = `## 사용자 정보
${userProfile ? `- 나이: ${userProfile.age || '미입력'}세
- 성별: ${userProfile.gender || '미입력'}
- 키: ${userProfile.height || '미입력'}cm
- 체중: ${userProfile.weight || '미입력'}kg` : '프로필 정보 없음'}

## 구매 이력 (총 ${purchaseHistory.length}개 품목)
${purchaseHistory.map(item => `- ${item.name}${item.category ? ` [${item.category}]` : ''}${item.purchaseDate ? ` (${item.purchaseDate})` : ''}`).join('\n')}

## 추가 분석 컨텍스트
${analysisContext ? JSON.stringify(analysisContext, null, 2) : '없음'}

위 데이터를 분석하여, 이 사용자만의 고유한 식습관 패턴을 발견하고 JSON으로 응답해주세요.
뻔한 건강 상식이 아닌, 데이터에서 발견한 구체적인 인사이트를 제공해주세요.`;

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      temperature: 0.7, // 창의성 높임
      max_tokens: 2500,
      response_format: { type: 'json_object' },
    });

    const content = completion.choices[0]?.message?.content;

    if (!content) {
      return res.status(500).json({ error: 'Empty response from OpenAI' });
    }

    const parsed = JSON.parse(content);

    return res.status(200).json({
      success: true,
      data: parsed,
      usage: {
        prompt_tokens: completion.usage?.prompt_tokens,
        completion_tokens: completion.usage?.completion_tokens,
      },
    });
  } catch (error) {
    console.error('Nutrition advice error:', error);
    return res.status(500).json({
      error: error.message || 'Internal server error',
    });
  }
}
