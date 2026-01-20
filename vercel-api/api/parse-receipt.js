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

    // 한국 식품명 사전 (OCR 오류 교정용)
    const koreanFoodDictionary = `
## 한국 식품명 사전 (OCR 오류 교정 참고)

### 곡류/빵류
옥수수, 찹쌀, 현미, 보리, 귀리, 식빵, 모닝빵, 크로와상, 베이글, 호밀빵

### 육류/가공육
삼겹살, 목살, 갈비, 안심, 등심, 닭가슴살, 닭다리, 베이컨, 햄, 소시지, 베이컨햄, 불고기, 제육

### 채소류
배추, 무, 당근, 양파, 감자, 고구마, 시금치, 상추, 깻잎, 파, 대파, 양배추, 브로콜리, 오이, 호박, 가지, 토마토, 파프리카, 피망, 콩나물, 숙주

### 과일류
사과, 배, 포도, 귤, 오렌지, 바나나, 딸기, 수박, 참외, 멜론, 키위, 망고, 복숭아, 자두, 블루베리

### 유제품
우유, 저지방우유, 요거트, 요플레, 치즈, 버터, 생크림, 두유

### 음료
콜라, 사이다, 환타, 커피, 아메리카노, 라떼, 녹차, 홍차, 보리차, 옥수수차, 주스, 이온음료

### 가공식품
라면, 컵라면, 냉동만두, 냉동피자, 햇반, 즉석밥, 어묵, 두부, 김치, 젓갈, 장조림

### 과자/간식
초코파이, 빼빼로, 새우깡, 포카칩, 프링글스, 오레오, 전통과자, 약과, 유과, 한과, 찰떡파이

### 조미료/양념
소금, 설탕, 간장, 된장, 고추장, 식초, 참기름, 들기름, 올리브유, 마요네즈, 케첩, 머스타드
`;

    const systemPrompt = `당신은 한국 마트/편의점 영수증 OCR 텍스트를 분석하는 전문가입니다.

주어진 OCR 텍스트에서 구매한 상품 목록을 추출하세요.

## 중요: OCR 오류 교정 규칙
OCR 인식 과정에서 한글이 비슷한 글자로 잘못 인식되는 경우가 많습니다. 다음 패턴을 교정하세요:

1. 자음 오류:
   - ㄷ↔ㅌ: "독수수"→"옥수수", "전동과자"→"전통과자"
   - ㄱ↔ㅋ: "코피"→"커피"
   - ㅂ↔ㅍ: "바프리카"→"파프리카"
   - ㅁ↔ㅂ: "베이컨함"→"베이컨햄"

2. 모음 오류:
   - ㅏ↔ㅓ: "서과"→"사과"
   - ㅗ↔ㅜ: "우유"가 "오유"로 인식
   - ㅡ↔ㅜ: "두부"가 "드부"로 인식

3. 받침 오류:
   - ㄴ↔ㅁ: "라면"이 "라멘"으로
   - ㄹ↔ㄴ: "소금"이 "소글"로

4. 일반적인 OCR 오류:
   - 숫자와 문자 혼동: 0↔O, 1↔l, 8↔B
   - 띄어쓰기 오류 교정

## 식품명 교정 시 아래 사전을 참고하세요:
${koreanFoodDictionary}

## 추출 규칙:
1. 상품명, 수량, 가격(원)을 추출
2. 가격에서 콤마, 공백 제거 후 숫자만 추출
3. 수량이 명시되지 않으면 1로 가정
4. 합계, 부가세, 결제정보 등은 제외
5. **상품명은 OCR 오류를 교정하여 올바른 한국어 식품명으로 변환**

출력 형식 (JSON만 출력):
{
  "items": [
    {"name": "교정된 상품명", "quantity": 1, "price": 12000},
    {"name": "교정된 상품명2", "quantity": 2, "price": 5000}
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
