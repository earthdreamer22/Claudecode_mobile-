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
    const { userProfile, purchaseHistory, currentAnalysis } = req.body;

    if (!purchaseHistory || purchaseHistory.length === 0) {
      return res.status(400).json({ error: 'purchaseHistory is required' });
    }

    const systemPrompt = `당신은 영양학 전문가이자 대사증후군 예방 전문의입니다.

사용자의 구매 이력과 건강 정보를 분석하여 맞춤형 영양 조언을 제공합니다.

분석 기준:
1. 대사증후군 5대 위험요소: 복부비만, 고혈압, 고혈당, 고중성지방, 낮은 HDL콜레스테롤
2. 나트륨 섭취량 (권장: 2000mg/일 이하)
3. 당류 섭취량 (권장: 50g/일 이하)
4. 칼로리 균형
5. 영양소 균형 (단백질, 탄수화물, 지방 비율)

응답 형식 (JSON만 출력):
{
  "overallAssessment": {
    "score": 0-100 (건강 점수),
    "level": "양호/주의/경고/위험",
    "summary": "전체 식습관 평가 (2-3문장)"
  },
  "categoryAnalysis": {
    "가공식품": { "percentage": 30, "assessment": "평가", "advice": "조언" },
    "육류": { "percentage": 20, "assessment": "평가", "advice": "조언" },
    ...
  },
  "nutritionBalance": {
    "sodium": { "status": "과다/적정/부족", "advice": "조언" },
    "sugar": { "status": "과다/적정/부족", "advice": "조언" },
    "calories": { "status": "과다/적정/부족", "advice": "조언" }
  },
  "personalizedTips": [
    "구체적인 조언 1",
    "구체적인 조언 2",
    "구체적인 조언 3"
  ],
  "futurePredictions": {
    "1년후": {
      "riskLevel": "정상/주의/위험/고위험",
      "metabolicScore": 0-100,
      "mainRisks": ["위험1", "위험2"],
      "explanation": "현재 식습관을 유지할 경우 예상되는 상황 설명"
    },
    "3년후": {
      "riskLevel": "정상/주의/위험/고위험",
      "metabolicScore": 0-100,
      "mainRisks": ["위험1", "위험2"],
      "explanation": "설명"
    },
    "5년후": {
      "riskLevel": "정상/주의/위험/고위험",
      "metabolicScore": 0-100,
      "mainRisks": ["위험1", "위험2"],
      "explanation": "설명"
    }
  },
  "actionPlan": {
    "immediate": ["즉시 실천할 사항"],
    "shortTerm": ["1-3개월 내 실천할 사항"],
    "longTerm": ["장기적으로 실천할 사항"]
  }
}`;

    const userPrompt = `사용자 프로필:
${userProfile ? JSON.stringify(userProfile, null, 2) : '정보 없음'}

누적 구매 이력 (최근 ${purchaseHistory.length}개 항목):
${JSON.stringify(purchaseHistory, null, 2)}

현재 분석 데이터:
${currentAnalysis ? JSON.stringify(currentAnalysis, null, 2) : '없음'}

위 정보를 바탕으로 맞춤형 영양 조언과 1년/3년/5년 후 건강 예측을 JSON으로 제공해주세요.
특히 대사증후군 위험도에 초점을 맞춰 분석해주세요.`;

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      temperature: 0.3,
      max_tokens: 3000,
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
