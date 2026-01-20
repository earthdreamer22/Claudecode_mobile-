# Receipt Parser API

OCR 영수증 텍스트를 OpenAI로 파싱하는 Vercel Serverless API

## 배포 방법

### 1. Vercel CLI 사용
```bash
npm i -g vercel
cd vercel-api
vercel
```

### 2. GitHub 연동
1. Vercel 대시보드에서 Import Git Repository
2. `vercel-api` 폴더를 Root Directory로 설정
3. Environment Variables에 `OPENAI_API_KEY` 추가

## 환경변수

| 이름 | 설명 |
|------|------|
| `OPENAI_API_KEY` | OpenAI API 키 |

## API 엔드포인트

### POST /api/parse-receipt

**Request:**
```json
{
  "ocrText": "영수증 전체 텍스트",
  "blocks": [{"text": "블록1"}, {"text": "블록2"}]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {"name": "상품명", "quantity": 1, "price": 12000}
    ],
    "store": "매장명",
    "date": "2024-01-15",
    "total": 12000
  },
  "usage": {
    "prompt_tokens": 100,
    "completion_tokens": 50
  }
}
```
