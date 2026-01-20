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
    const { ocrText, blocks } = req.body;

    if (!ocrText) {
      return res.status(400).json({ error: 'ocrText is required' });
    }

    const systemPrompt = `당신은 한국 마트/편의점 영수증 OCR 텍스트를 분석하는 전문가입니다.

주어진 OCR 텍스트에서 구매한 상품 목록을 추출하세요.

규칙:
1. 상품명, 수량, 가격(원)을 추출
2. 가격에서 콤마, 공백 제거 후 숫자만 추출
3. 수량이 명시되지 않으면 1로 가정
4. 합계, 부가세, 결제정보 등은 제외
5. 상품명은 원본 그대로 유지 (오타 수정 X)

출력 형식 (JSON만 출력):
{
  "items": [
    {"name": "상품명", "quantity": 1, "price": 12000},
    {"name": "상품명2", "quantity": 2, "price": 5000}
  ],
  "store": "매장명 (있으면)",
  "date": "날짜 (있으면, YYYY-MM-DD 형식)",
  "total": 합계금액 (있으면)
}`;

    const userPrompt = `OCR 텍스트:
${ocrText}

${blocks ? `\n블록별 데이터:\n${JSON.stringify(blocks, null, 2)}` : ''}

위 영수증에서 구매 상품 목록을 JSON으로 추출하세요.`;

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      temperature: 0.1,
      max_tokens: 2000,
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
    console.error('Parse receipt error:', error);
    return res.status(500).json({
      error: error.message || 'Internal server error',
    });
  }
}
