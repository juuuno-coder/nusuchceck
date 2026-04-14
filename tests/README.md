# nusucheck E2E 테스트

Playwright 기반 E2E 테스트 (ai-recipe 템플릿 이식)

## 빠른 시작

### 1. 환경변수 설정
```bash
cp .env.e2e.example .env.e2e
# .env.e2e 파일에 실제 계정 정보 입력
```

### 2. 실행

```bash
# 공개 페이지만 (계정 불필요)
E2E_BASE_URL=https://nusucheck.vibers.co.kr npm run test:e2e:smoke

# 로그인 포함 전체 smoke (계정 필요)
npx dotenv -e .env.e2e -- npx playwright test tests/specs/smoke.spec.ts

# 공개 페이지 크롤
npx dotenv -e .env.e2e -- npm run test:e2e:public

# UI 모드
npm run test:e2e:ui

# HTML 리포트 보기
npm run test:e2e:report
```

## 시나리오 상태 체계

| 상태 | 의미 |
|------|------|
| ✅ | 실제 DB/UI 변화까지 동작 확인 |
| ⚠️ | 페이지 렌더만 확인, 동작 미검증 |
| ❌ | 테스트 실패 |
| ⏭️ | env/데이터 부족 또는 의도적 skip |

## 파일 구조

```
tests/
├── e2e.config.ts          ← 누수체크 라우트/계정/시나리오 설정
├── specs/
│   ├── smoke.spec.ts      ← 핵심 기능 smoke + QA 리포트 생성
│   ├── crawl-public.spec.ts   ← 공개 페이지 전체 크롤
│   └── crawl-clickable.spec.ts ← 클릭 가능 요소 자동 탐색
└── lib/                   ← 공용 로직 (ai-recipe 그대로)
    ├── crawler.ts
    ├── clicker.ts
    ├── reporter.ts
    └── auth.ts
```

## QA 리포트

smoke 실행 후 `tests/reports/qa-YYYY-MM-DD.md` 자동 생성.

예시:
```
## 전체 커버리지: 25% (실동작 검증 8 / 전체 시나리오 32)
```

## 주의사항

- **결제/에스크로/견적 확정/삭제** 시나리오는 의도적으로 제외 (파괴적 액션)
- 소셜 로그인 (Kakao/Naver/Google) OAuth 자동화 제외
- `spec/` (RSpec) 은 별도 — 이 디렉토리와 무관
