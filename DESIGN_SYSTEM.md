# 누수체크 디자인 시스템 v3.0

> **이 문서는 모든 페이지 개발 시 반드시 참조해야 하는 디자인 가이드입니다.**
> Claude Code가 새로운 페이지를 만들거나 기존 페이지를 수정할 때 이 문서의 규칙을 따르세요.
> 관련 상세 문서: `DESIGN_TOKENS.md`, `INTERACTION_PATTERNS.md`, `REFERENCE_ANALYSIS.md`

---

## 1. 디자인 철학

### 레퍼런스 앱
| 앱 | 적용 포인트 |
|---|---|
| **당근마켓** | 카드 UI, 리스트 아이템, 하단 탭, 따뜻한 톤, border 기반 카드 |
| **토스** | 단계형 위자드, 히어로 섹션, 큰 타이포, 깔끔한 정보 구조, 바텀시트 |
| **미소** | 서비스 예약 플로우, 리뷰/신뢰 표시, 전문가 프로필 카드, 폼 패턴 |

### 핵심 원칙
1. **모바일 퍼스트**: 모든 레이아웃은 모바일(375px)을 기준으로 설계 후 데스크톱 확장
2. **카드 기반 UI**: 모든 정보 블록은 rounded-2xl 카드 안에 배치
3. **1화면 1목적**: 각 화면은 하나의 주요 액션에 집중
4. **친근한 톤**: "신고" 대신 "체크", 이모지 활용, 부드러운 문구
5. **일관된 모션**: 모든 전환은 200-300ms ease-out으로 통일
6. **접근성 우선**: WCAG AA 기준 명도대비 4.5:1 이상, 터치 영역 최소 44px

---

## 2. 색상 시스템

### Primary (Teal) - 신뢰, 전문성
```
primary-50:  #f0fdfa   → 배경 하이라이트, 호버 배경
primary-100: #ccfbf1   → 뱃지 배경, 아이콘 배경, 포커스 링
primary-200: #99f6e4   → 호버 배경 (진한)
primary-500: #14b8a6   → 보조 강조
primary-600: #0d9488   → 메인 버튼, 활성 탭, 링크 텍스트
primary-700: #0f766e   → 버튼 호버 (600 대비 8% 어둡게)
primary-800: #115e59   → 버튼 프레스 (600 대비 16% 어둡게), 다크 배경
primary-900: #134e4a   → 사이드바 배경 (관리자)
```

### Secondary (Purple) - AI/혁신 관련
```
purple-50:  #faf5ff    → AI 기능 배경
purple-100: #f3e8ff    → AI 뱃지 배경
purple-600: #9333ea    → AI 강조, 그라디언트 끝점
```

### Accent (Orange) - 당근마켓 스타일 포인트
```
carrot-400: #fb923c    → 가격, 카운트 강조
carrot-500: #f97316    → CTA 보조 버튼
```

### 상태 색상 (Status Colors)
| 상태 | 배경 | 텍스트 | 용도 |
|---|---|---|---|
| 승인/완료 | `bg-green-100` | `text-green-700` | 완료, 승인됨, 성공 |
| 대기/진행 | `bg-yellow-100` | `text-yellow-700` | 대기중, 검토중 |
| 배정/처리 | `bg-blue-100` | `text-blue-700` | 배정됨, 처리중 |
| 거절/오류 | `bg-red-100` | `text-red-700` | 거절, 에러, 위험 |
| 접수/기본 | `bg-gray-100` | `text-gray-700` | 기본, 초안 |
| AI분석 | `bg-purple-100` | `text-purple-700` | AI 관련 상태 |

### 그라디언트 (히어로/CTA 전용)
```html
<!-- 기본 히어로 그라디언트 -->
bg-gradient-to-r from-primary-600 to-primary-700

<!-- AI/프리미엄 그라디언트 -->
bg-gradient-to-r from-primary-600 to-purple-600

<!-- 랜딩페이지 배경 그라디언트 -->
bg-gradient-to-br from-primary-50 via-white to-purple-50
```

### 그림자 시스템 (Elevation)
```
shadow-0:  none                                    → 기본 카드 (border만 사용)
shadow-1:  0 2px 8px rgba(0, 0, 0, 0.08)          → 호버된 카드, 작은 팝오버
shadow-2:  0 4px 12px rgba(0, 0, 0, 0.12)         → 드롭다운, 활성 카드
shadow-3:  0 8px 24px rgba(0, 0, 0, 0.15)         → 모달, 바텀시트
shadow-4:  0 16px 40px rgba(0, 0, 0, 0.2)         → 토스트 (최상위)
```

### ❌ 색상 사용 금지 사항
- `bg-blue-600`, `bg-indigo-600` 등 primary가 아닌 파란 계열 사용 금지
- 그라디언트는 히어로 섹션/CTA 버튼에만 사용, 카드 내부에는 사용 금지
- 카드 배경은 항상 `bg-white` (다크모드 미지원)

---

## 3. 타이포그래피

### 폰트
```
font-family: 'Pretendard Variable', 'Pretendard', system-ui, sans-serif
```

### 크기 체계
| 용도 | 클래스 | 굵기 | line-height |
|---|---|---|---|
| 히어로 제목 | `text-[28px]` ~ `text-5xl` | `font-extrabold` (800) | 1.2 |
| 페이지 제목 | `text-[22px]` ~ `text-2xl` | `font-bold` (700) | 1.3 |
| 섹션 제목 | `text-lg` ~ `text-xl` | `font-bold` (700) | 1.4 |
| 카드 제목 | `text-base` (16px) | `font-bold` (700) | 1.4 |
| 본문 텍스트 | `text-sm` (14px) | `font-medium` (500) | 1.5 |
| 부가 정보 | `text-xs` (12px) | `font-normal` (400) | 1.4 |
| 뱃지/태그 | `text-xs` (12px) | `font-bold` (700) | 1.4 |
| 큰 숫자 (통계) | `text-2xl` ~ `text-4xl` | `font-extrabold` (800) | 1.2 |
| 라벨 | `text-sm` (14px) | `font-semibold` (600) | 1.4 |
| 캡션 | `text-xs` (12px) | `font-normal` (400) | 1.4 |

### 색상 체계
```
제목/강조:  text-gray-900
본문:       text-gray-700 또는 text-gray-600
부가정보:   text-gray-500
비활성:     text-gray-400
플레이스홀더: text-gray-400
링크:       text-primary-600 hover:text-primary-700
에러:       text-red-600
성공:       text-green-600
```

---

## 4. 간격 & 레이아웃

### 기본 간격 (8px 그리드)
```
섹션 간 간격:    mb-8 (32px) 또는 mb-6 (24px)
카드 내부 패딩:  p-5 (20px) 또는 p-4 (16px)
카드 간 간격:    space-y-3 (12px) 또는 gap-3 (12px)
요소 내 간격:    gap-2 (8px) 또는 gap-3 (12px)
아이콘-텍스트:   gap-2 (8px)
인라인 요소 간:  gap-2 (8px)
```

### 페이지 컨테이너
```html
<!-- 모바일 기본 컨테이너 -->
<div class="min-h-screen bg-gray-50 pb-20 md:pb-8">
  <div class="max-w-4xl mx-auto px-4 py-6 md:pt-0">
    <!-- 콘텐츠 -->
  </div>
</div>
```
- `pb-20`: 하단 네비게이션 공간 확보 (모바일)
- `md:pb-8`: 데스크톱에서는 일반 패딩
- `max-w-4xl`: 최대 너비 896px
- `px-4`: 좌우 패딩 16px

### 그리드
```html
<!-- 3열 그리드 (빠른 액션, 통계) -->
<div class="grid grid-cols-3 gap-3">

<!-- 2열 그리드 (카드 목록) -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-4">

<!-- 리스트 (세로 나열) -->
<div class="space-y-3">
```

---

## 5. 컴포넌트 라이브러리

### 5.1 버튼

#### 버튼 상태 매트릭스
| 상태 | Primary | Secondary | Ghost |
|---|---|---|---|
| **Default** | `bg-primary-600 text-white` | `bg-white text-gray-700 border-2 border-gray-200` | `text-primary-600` |
| **Hover** | `bg-primary-700 shadow-md` | `bg-gray-50 border-gray-300 shadow-sm` | `bg-primary-50 text-primary-700` |
| **Active/Press** | `bg-primary-800 scale-[0.98]` | `bg-gray-100 scale-[0.98]` | `bg-primary-100` |
| **Disabled** | `bg-gray-200 text-gray-400 cursor-not-allowed` | `bg-gray-50 text-gray-300 cursor-not-allowed` | `text-gray-300 cursor-not-allowed` |
| **Loading** | `bg-primary-600 + spinner (흰색)` | `bg-white + spinner (gray)` | `+ spinner (primary)` |

#### Primary 버튼 (메인 CTA)
```html
<button class="w-full px-6 py-4 bg-primary-600 text-white rounded-2xl
               hover:bg-primary-700 hover:shadow-md
               active:bg-primary-800 active:scale-[0.98]
               disabled:bg-gray-200 disabled:text-gray-400 disabled:cursor-not-allowed
               transition-all duration-200 ease-out
               font-bold text-base">
  누수 체크 접수하기
</button>
```

#### Secondary 버튼
```html
<button class="w-full px-6 py-4 bg-white text-gray-700 rounded-2xl
               border-2 border-gray-200
               hover:bg-gray-50 hover:border-gray-300 hover:shadow-sm
               active:bg-gray-100 active:scale-[0.98]
               disabled:bg-gray-50 disabled:text-gray-300 disabled:cursor-not-allowed
               transition-all duration-200 ease-out
               font-semibold text-base">
  이전으로
</button>
```

#### Ghost 버튼 (텍스트형)
```html
<button class="px-4 py-2 text-primary-600 rounded-xl
               hover:text-primary-700 hover:bg-primary-50
               active:bg-primary-100
               transition-all duration-200 ease-out
               font-semibold text-sm">
  전체 보기 →
</button>
```

#### Danger 버튼 (위험 액션)
```html
<button class="w-full px-6 py-4 bg-red-600 text-white rounded-2xl
               hover:bg-red-700 hover:shadow-md
               active:bg-red-800 active:scale-[0.98]
               transition-all duration-200 ease-out
               font-bold text-base">
  삭제하기
</button>
```

#### 아이콘 버튼
```html
<button class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center
               hover:bg-gray-200 active:bg-gray-300
               transition-colors duration-200">
  <svg class="w-5 h-5 text-gray-600">...</svg>
</button>
```

#### 로딩 버튼 (Stimulus 패턴)
```html
<button data-controller="button-loading"
        data-action="click->button-loading#start"
        data-button-loading-text-value="처리중..."
        class="w-full px-6 py-4 bg-primary-600 text-white rounded-2xl font-bold
               transition-all duration-200 ease-out
               disabled:opacity-60 disabled:cursor-not-allowed">
  <span data-button-loading-target="text">접수하기</span>
  <svg data-button-loading-target="spinner" class="hidden animate-spin w-5 h-5 ml-2 inline-block"
       viewBox="0 0 24 24" fill="none">
    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" opacity="0.3"/>
    <path d="M12 2a10 10 0 0 1 10 10" stroke="currentColor" stroke-width="3" stroke-linecap="round"/>
  </svg>
</button>
```

#### ❌ 버튼 규칙
- 모바일에서 주요 CTA는 항상 `w-full`
- `rounded-2xl` 통일 (rounded-lg, rounded-md 사용 금지)
- 그라디언트 버튼은 랜딩페이지/최종 CTA에서만 사용
- 높이: 최소 48px (터치 영역 확보)

### 5.2 카드

#### 카드 상태 매트릭스
| 타입 | 기본 | 호버 | 활성/선택 |
|---|---|---|---|
| **기본** | `border-2 border-gray-100` | - | - |
| **인터랙티브** | `border-2 border-gray-100` | `shadow-lg border-primary-200 -translate-y-0.5` | `border-primary-500 bg-primary-50` |
| **강조** | `bg-gradient from-primary-600 to-primary-700` | `shadow-xl` | - |
| **알림/가이드** | `bg-primary-50 border-2 border-primary-100` | - | - |

#### 기본 카드
```html
<div class="bg-white rounded-2xl p-5 border-2 border-gray-100">
  <!-- 카드 내용 -->
</div>
```

#### 인터랙티브 카드 (링크/클릭 가능)
```html
<%= link_to path, class: "block bg-white rounded-2xl p-5
                          border-2 border-gray-100
                          hover:shadow-lg hover:border-primary-200 hover:-translate-y-0.5
                          active:shadow-sm active:translate-y-0
                          transition-all duration-200 ease-out" do %>
  <!-- 카드 내용 -->
<% end %>
```

#### 강조 카드 (인사 카드, 프로모션)
```html
<div class="bg-gradient-to-r from-primary-600 to-primary-700 rounded-3xl p-6 text-white shadow-lg">
  <!-- 카드 내용 -->
</div>
```

#### 알림/가이드 카드
```html
<div class="bg-primary-50 rounded-2xl p-5 border-2 border-primary-100">
  <h3 class="text-sm font-bold text-primary-900 mb-3 flex items-center gap-2">
    <span>💡</span><span>이용 가이드</span>
  </h3>
  <p class="text-xs text-primary-800">안내 내용</p>
</div>
```

#### 경고/주의 카드
```html
<div class="bg-orange-50 rounded-2xl p-4 border border-orange-200">
  <p class="text-sm text-orange-800 font-medium">⏳ 전문가 매칭 중...</p>
</div>
```

#### 에러 카드
```html
<div class="bg-red-50 rounded-2xl p-4 border border-red-200">
  <div class="flex items-center gap-2">
    <svg class="w-5 h-5 text-red-500 flex-shrink-0">...</svg>
    <p class="text-sm text-red-800 font-medium">오류 메시지</p>
  </div>
</div>
```

#### ❌ 카드 규칙
- 카드 배경: 항상 `bg-white`
- 카드 테두리: `border-2 border-gray-100` (당근마켓 스타일)
- 카드 라운드: `rounded-2xl` (기본) 또는 `rounded-3xl` (강조)
- shadow는 호버 시에만: `hover:shadow-lg`
- 기본 상태에서는 shadow 없이 border만 사용

### 5.3 상태 뱃지
```html
<!-- 공통 뱃지 패턴 -->
<span class="inline-flex items-center px-2.5 py-1 bg-{color}-100 text-{color}-700
             rounded-full text-xs font-bold transition-colors duration-200">
  상태 텍스트
</span>

<!-- 예시 -->
<span class="px-2.5 py-1 bg-primary-100 text-primary-700 rounded-full text-xs font-bold">진행중</span>
<span class="px-2.5 py-1 bg-green-100 text-green-700 rounded-full text-xs font-bold">✓ 완료</span>
<span class="px-2.5 py-1 bg-yellow-100 text-yellow-700 rounded-full text-xs font-bold">견적 대기</span>
<span class="px-2.5 py-1 bg-red-100 text-red-700 rounded-full text-xs font-bold">거절됨</span>

<!-- 큰 뱃지 (카드 상단) -->
<span class="inline-flex items-center px-3 py-1.5 bg-{color}-100 text-{color}-700
             rounded-full text-sm font-bold">
  <svg class="w-3.5 h-3.5 mr-1.5">...</svg>
  상태 텍스트
</span>
```

### 5.4 아이콘 서클 (빠른 액션)
```html
<!-- 크기: w-14 h-14 (기본), w-12 h-12 (작은), w-10 h-10 (아주 작은) -->
<div class="w-14 h-14 bg-primary-100 rounded-full flex items-center justify-center
            transition-colors duration-200">
  <svg class="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="..."/>
  </svg>
</div>
```

색상 변형:
```
primary: bg-primary-100 + text-primary-600
green:   bg-green-100 + text-green-600
purple:  bg-purple-100 + text-purple-600
orange:  bg-orange-100 + text-orange-600
blue:    bg-blue-100 + text-blue-600
gray:    bg-gray-100 + text-gray-600
```

### 5.5 리스트 아이템 (당근마켓 스타일)
```html
<%= link_to path, class: "block bg-white rounded-2xl p-5
                          border-2 border-gray-100
                          hover:shadow-lg hover:border-primary-200 hover:-translate-y-0.5
                          active:shadow-sm active:translate-y-0
                          transition-all duration-200 ease-out" do %>
  <!-- 상단: 뱃지 + 시간 -->
  <div class="flex items-center gap-2 mb-3">
    <span class="px-2.5 py-1 bg-primary-100 text-primary-700 rounded-full text-xs font-bold">
      진행중
    </span>
    <span class="text-xs text-gray-500">2시간 전</span>
  </div>

  <!-- 제목 -->
  <h3 class="font-bold text-gray-900 mb-2 text-base">배관 누수</h3>

  <!-- 주소 (아이콘 + 텍스트) -->
  <div class="flex items-start gap-2 mb-3">
    <svg class="w-4 h-4 text-gray-400 flex-shrink-0 mt-0.5">...</svg>
    <p class="text-sm text-gray-600 line-clamp-1">서울시 강남구 역삼동 123-45</p>
  </div>

  <!-- 하단 정보 (전문가 카드 등) -->
  <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-xl">
    <div class="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center">
      <svg class="w-5 h-5 text-primary-600">...</svg>
    </div>
    <div class="flex-1 min-w-0">
      <p class="text-xs text-gray-500">담당 전문가</p>
      <p class="text-sm font-semibold text-gray-900 truncate">김전문가</p>
    </div>
    <svg class="w-5 h-5 text-gray-400 flex-shrink-0">...</svg>
  </div>
<% end %>
```

### 5.6 폼 입력 필드

#### 입력 필드 상태 매트릭스
| 상태 | 테두리 | 배경 | 라벨 색상 | 부가 요소 |
|---|---|---|---|---|
| **기본** | `border-2 border-gray-200` | `bg-gray-50` | `text-gray-700` | - |
| **포커스** | `border-primary-500 ring-2 ring-primary-100` | `bg-white` | `text-primary-600` | 캐럿 primary |
| **값 입력됨** | `border-2 border-gray-200` | `bg-white` | `text-gray-700` | - |
| **에러** | `border-2 border-red-400` | `bg-red-50` | `text-red-600` | ⚠️ 아이콘 + 메시지 |
| **성공** | `border-2 border-green-400` | `bg-green-50` | `text-green-600` | ✓ 아이콘 |
| **비활성** | `border-2 border-gray-100` | `bg-gray-100` | `text-gray-400` | cursor-not-allowed |

#### 텍스트 입력
```html
<div class="mb-4">
  <label class="block text-sm font-semibold text-gray-700 mb-2">라벨</label>
  <input type="text"
         class="w-full px-4 py-3.5 bg-gray-50 border-2 border-gray-200 rounded-2xl text-base
                focus:border-primary-500 focus:ring-2 focus:ring-primary-100 focus:bg-white
                disabled:bg-gray-100 disabled:text-gray-400 disabled:cursor-not-allowed
                transition-all duration-200 ease-out placeholder-gray-400"
         placeholder="입력해주세요">
  <!-- 에러 메시지 (기본 hidden, 에러 시 표시) -->
  <p class="hidden mt-1.5 text-xs text-red-600 flex items-center gap-1">
    <svg class="w-3.5 h-3.5">...</svg>
    에러 메시지
  </p>
  <!-- 도움말 (선택) -->
  <p class="mt-1.5 text-xs text-gray-500">도움말 텍스트</p>
</div>
```

#### 에러 상태 입력 필드
```html
<div class="mb-4">
  <label class="block text-sm font-semibold text-red-600 mb-2">라벨</label>
  <input type="text"
         class="w-full px-4 py-3.5 bg-red-50 border-2 border-red-400 rounded-2xl text-base
                focus:border-red-500 focus:ring-2 focus:ring-red-100
                transition-all duration-200 ease-out"
         value="잘못된 입력">
  <p class="mt-1.5 text-xs text-red-600 flex items-center gap-1">
    <svg class="w-3.5 h-3.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
    </svg>
    유효한 전화번호를 입력해주세요
  </p>
</div>
```

#### 텍스트영역
```html
<textarea class="w-full px-4 py-3.5 bg-gray-50 border-2 border-gray-200 rounded-2xl text-base
                 focus:border-primary-500 focus:ring-2 focus:ring-primary-100 focus:bg-white
                 transition-all duration-200 ease-out placeholder-gray-400 resize-none"
          rows="4" placeholder="상세 내용을 입력해주세요"></textarea>
<p class="mt-1.5 text-xs text-gray-400 text-right">0 / 500</p>
```

#### 선택 카드 (위자드 스타일)
```html
<label class="block bg-white rounded-2xl p-5 border-2 border-gray-200 cursor-pointer
              hover:border-primary-300 hover:shadow-sm
              peer-checked:border-primary-500 peer-checked:bg-primary-50
              transition-all duration-200 ease-out">
  <input type="radio" name="option" value="1" class="peer hidden">
  <div class="flex items-center gap-3">
    <div class="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center
                peer-checked:bg-primary-600">
      <svg class="w-5 h-5 text-primary-600 peer-checked:text-white">...</svg>
    </div>
    <div>
      <p class="font-bold text-gray-900">옵션 제목</p>
      <p class="text-sm text-gray-500 mt-0.5">설명 텍스트</p>
    </div>
  </div>
</label>
```

#### 파일 업로드 영역
```html
<div class="border-2 border-dashed border-gray-300 rounded-2xl p-8 text-center
            hover:border-primary-400 hover:bg-primary-50/30
            transition-all duration-200 ease-out cursor-pointer"
     data-controller="file-upload"
     data-action="click->file-upload#open dragover->file-upload#dragover drop->file-upload#drop">
  <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
    <svg class="w-8 h-8 text-gray-400">...</svg>
  </div>
  <p class="text-sm font-medium text-gray-600 mb-1">사진 또는 영상을 업로드하세요</p>
  <p class="text-xs text-gray-400">JPG, PNG, MP4 (최대 50MB)</p>
  <input type="file" class="hidden" data-file-upload-target="input">
</div>
```

### 5.7 빈 상태 (Empty State)
```html
<div class="bg-white rounded-2xl p-10 text-center border-2 border-dashed border-gray-200">
  <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
    <svg class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <!-- 아이콘 -->
    </svg>
  </div>
  <p class="text-gray-900 font-bold mb-2">아직 데이터가 없어요</p>
  <p class="text-sm text-gray-500 mb-6">설명 텍스트를 여기에 작성합니다</p>
  <%= link_to path, class: "inline-flex items-center gap-2 px-6 py-3 bg-primary-600 text-white
                            rounded-2xl hover:bg-primary-700 transition-all duration-200 font-bold shadow-md" do %>
    <svg class="w-5 h-5">...</svg>
    <span>액션 버튼</span>
  <% end %>
</div>
```

### 5.8 통계 카드
```html
<div class="bg-white rounded-2xl p-4 text-center border-2 border-gray-100
            hover:shadow-md hover:border-primary-200 transition-all duration-200">
  <p class="text-2xl font-extrabold text-primary-600">12</p>
  <p class="text-xs text-gray-600 mt-1 font-medium">진행중</p>
</div>
```

### 5.9 토스트 알림

#### 토스트 유형
| 유형 | 아이콘 색상 | 예시 |
|---|---|---|
| 성공 | `text-green-400` (체크) | 저장되었습니다 |
| 에러 | `text-red-400` (X) | 오류가 발생했습니다 |
| 경고 | `text-yellow-400` (!) | 네트워크 연결을 확인해주세요 |
| 정보 | `text-blue-400` (i) | 새로운 견적이 도착했습니다 |

```html
<div class="fixed bottom-20 md:bottom-6 left-1/2 -translate-x-1/2 z-50
            w-[calc(100%-2rem)] max-w-sm
            animate-slideUp"
     data-controller="toast"
     data-toast-dismiss-after-value="4000">
  <div class="bg-gray-900 text-white px-4 py-3 rounded-2xl
              flex items-center justify-between shadow-xl">
    <div class="flex items-center gap-2.5">
      <svg class="w-5 h-5 text-green-400 flex-shrink-0">...</svg>
      <span class="text-sm font-medium">저장되었습니다</span>
    </div>
    <button class="text-gray-400 hover:text-white transition-colors ml-3 flex-shrink-0"
            data-action="click->toast#dismiss">
      <svg class="w-4 h-4">...</svg>
    </button>
  </div>
</div>
```

### 5.10 모달 & 바텀시트

#### 바텀시트 (모바일 우선, 토스 스타일)
```html
<!-- 오버레이 -->
<div class="fixed inset-0 bg-black/40 z-50 transition-opacity duration-300"
     data-action="click->bottom-sheet#close"></div>

<!-- 바텀시트 -->
<div class="fixed bottom-0 left-0 right-0 z-50 bg-white rounded-t-3xl
            transform transition-transform duration-300 ease-out
            max-h-[85vh] overflow-hidden">
  <!-- 핸들 -->
  <div class="flex justify-center pt-3 pb-2">
    <div class="w-10 h-1 bg-gray-300 rounded-full"></div>
  </div>
  <!-- 헤더 -->
  <div class="px-5 pb-4 border-b border-gray-100">
    <h3 class="text-lg font-bold text-gray-900">제목</h3>
  </div>
  <!-- 콘텐츠 -->
  <div class="px-5 py-4 overflow-y-auto max-h-[calc(85vh-120px)]">
    <!-- 내용 -->
  </div>
  <!-- 하단 액션 -->
  <div class="px-5 py-4 border-t border-gray-100 pb-safe">
    <button class="w-full py-4 bg-primary-600 text-white rounded-2xl font-bold">
      확인
    </button>
  </div>
</div>
```

#### 확인 모달 (중앙 정렬)
```html
<div class="fixed inset-0 bg-black/40 z-50 flex items-center justify-center p-4">
  <div class="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl
              animate-scaleIn">
    <div class="text-center mb-6">
      <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <svg class="w-8 h-8 text-red-600">...</svg>
      </div>
      <h3 class="text-lg font-bold text-gray-900 mb-2">정말 삭제하시겠어요?</h3>
      <p class="text-sm text-gray-500">이 작업은 되돌릴 수 없습니다</p>
    </div>
    <div class="flex gap-3">
      <button class="flex-1 py-3.5 bg-gray-100 text-gray-700 rounded-2xl font-semibold
                     hover:bg-gray-200 transition-colors duration-200">
        취소
      </button>
      <button class="flex-1 py-3.5 bg-red-600 text-white rounded-2xl font-semibold
                     hover:bg-red-700 transition-colors duration-200">
        삭제
      </button>
    </div>
  </div>
</div>
```

### 5.11 스켈레톤 로딩
```html
<!-- 카드 스켈레톤 -->
<div class="bg-white rounded-2xl p-5 border-2 border-gray-100 animate-pulse">
  <div class="flex items-center gap-2 mb-3">
    <div class="h-5 w-16 bg-gray-200 rounded-full"></div>
    <div class="h-4 w-12 bg-gray-200 rounded"></div>
  </div>
  <div class="h-5 w-3/4 bg-gray-200 rounded mb-2"></div>
  <div class="h-4 w-full bg-gray-200 rounded mb-3"></div>
  <div class="h-12 w-full bg-gray-100 rounded-xl"></div>
</div>

<!-- 리스트 스켈레톤 -->
<div class="space-y-3">
  <% 3.times do %>
    <%= render "shared/skeleton_card" %>
  <% end %>
</div>

<!-- Shimmer 효과 (application.css) -->
<!-- .skeleton { background: linear-gradient(90deg, #f3f4f6, #e5e7eb, #f3f4f6); background-size: 200% 100%; animation: shimmer 1.5s infinite; } -->
```

### 5.12 페이지 헤더 (뒤로가기)
```html
<div class="mb-6">
  <%= link_to back_path, class: "inline-flex items-center text-sm text-gray-500
                                 hover:text-gray-900 transition-colors duration-200 mb-3 group" do %>
    <svg class="w-5 h-5 mr-0.5 group-hover:-translate-x-0.5 transition-transform duration-200"
         fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
    </svg>
    <span>돌아가기</span>
  <% end %>
  <h1 class="text-[22px] font-bold text-gray-900"><%= title %></h1>
  <% if local_assigns[:subtitle] %>
    <p class="text-sm text-gray-500 mt-1"><%= subtitle %></p>
  <% end %>
</div>
```

### 5.13 프로그레스 바 (위자드)
```html
<!-- 단계형 프로그레스 -->
<div class="mb-6">
  <div class="flex items-center justify-between mb-2">
    <span class="text-xs font-semibold text-primary-600">Step <%= current %> / <%= total %></span>
    <span class="text-xs text-gray-500"><%= (current.to_f / total * 100).round %>%</span>
  </div>
  <div class="h-2 bg-gray-200 rounded-full overflow-hidden">
    <div class="h-full bg-gradient-to-r from-primary-600 to-purple-600 rounded-full
                transition-all duration-500 ease-out"
         style="width: <%= (current.to_f / total * 100).round %>%"></div>
  </div>
</div>

<!-- 도트형 프로그레스 (상태 타임라인) -->
<div class="flex items-center justify-between mb-6">
  <% steps.each_with_index do |step, i| %>
    <div class="flex flex-col items-center">
      <div class="w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold
                  <%= i < current ? 'bg-primary-600 text-white' :
                      i == current ? 'bg-primary-100 text-primary-600 ring-2 ring-primary-600' :
                      'bg-gray-200 text-gray-500' %>">
        <%= i < current ? '✓' : i + 1 %>
      </div>
      <span class="text-[10px] mt-1.5 font-medium
                   <%= i <= current ? 'text-primary-600' : 'text-gray-400' %>">
        <%= step %>
      </span>
    </div>
    <% unless i == steps.length - 1 %>
      <div class="flex-1 h-0.5 mx-2
                  <%= i < current ? 'bg-primary-600' : 'bg-gray-200' %>"></div>
    <% end %>
  <% end %>
</div>
```

### 5.14 탭 필터 (Pill 스타일)
```html
<div class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide mb-4">
  <% filters.each do |filter| %>
    <button class="flex-shrink-0 px-4 py-2 rounded-full text-sm font-semibold
                   transition-all duration-200 ease-out
                   <%= filter.active? ?
                     'bg-primary-600 text-white shadow-md' :
                     'bg-white text-gray-600 border border-gray-200 hover:border-primary-300 hover:text-primary-600' %>">
      <%= filter.label %>
      <% if filter.count > 0 %>
        <span class="ml-1.5 text-xs"><%= filter.count %></span>
      <% end %>
    </button>
  <% end %>
</div>
```

---

## 6. 네비게이션

### 6.1 하단 탭 네비게이션 (모바일, 고객 앱)
```html
<nav class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-50 md:hidden
            pb-safe">
  <div class="flex items-center justify-around h-16">
    <%= link_to path, class: "flex flex-col items-center justify-center flex-1 h-full
                              #{active ? 'text-primary-600' : 'text-gray-400'}
                              hover:text-primary-600 transition-colors duration-200" do %>
      <svg class="w-6 h-6 mb-1">...</svg>
      <span class="text-[10px] font-semibold">탭명</span>
    <% end %>
  </div>
</nav>
```

탭 구성 (고객):
1. 🏠 홈 — `customers_dashboard_path`
2. 📋 내 요청 — `customers_requests_path`
3. ➕ 새 체크 — `new_customers_request_path` (가운데 강조)
4. 📄 보험 — `customers_insurance_claims_path`
5. 👤 마이 — `customers_profile_path`

### 6.2 데스크톱 상단 네비게이션 (고객)
```html
<header class="hidden md:block bg-white border-b border-gray-200 sticky top-0 z-40">
  <div class="max-w-4xl mx-auto px-4 h-14 flex items-center justify-between">
    <a href="/" class="text-lg font-bold text-primary-600">누수체크</a>
    <nav class="flex items-center gap-6">
      <a class="text-sm font-medium text-gray-600 hover:text-primary-600
                transition-colors duration-200 relative
                after:absolute after:bottom-[-18px] after:left-0 after:right-0
                after:h-0.5 after:bg-primary-600 after:scale-x-0
                hover:after:scale-x-100 after:transition-transform after:duration-200">홈</a>
      <!-- active 상태: after:scale-x-100 text-primary-600 font-semibold -->
    </nav>
    <div class="flex items-center gap-3">
      <button class="relative p-2 text-gray-600 hover:bg-gray-50 rounded-lg transition-colors">
        <svg class="w-5 h-5"><!-- bell --></svg>
        <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full animate-pulse"></span>
      </button>
      <a class="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center
                hover:bg-primary-200 transition-colors">
        <svg class="w-4 h-4 text-primary-600"><!-- user --></svg>
      </a>
    </div>
  </div>
</header>
```

### 6.3 전문가(마스터) 네비게이션
- 데스크톱: 좌측 사이드바 (다크 배경 `bg-gray-900`)
- 모바일: 하단 탭 네비게이션 (고객과 동일 패턴)
- 사이드바 아이템: `hover:bg-gray-800 rounded-lg transition-colors duration-200`

### 6.4 관리자 네비게이션
- 데스크톱: 좌측 사이드바 (다크 teal `bg-primary-900`)
- 모바일: 햄버거 메뉴 → 드로어
- 사이드바 아이템: `hover:bg-primary-800 rounded-lg transition-colors duration-200`

---

## 7. 인터랙션 & 애니메이션

### 7.1 트랜지션 기본 규칙
```
모든 인터랙티브 요소:  transition-all duration-200 ease-out
색상만 변경:           transition-colors duration-200 ease-out
이동/크기:            transition-transform duration-200 ease-out
진입 애니메이션:       duration-300 ease-out
퇴장 애니메이션:       duration-200 ease-in
```

### 7.2 CSS 애니메이션 (application.css에 정의)
```css
/* 카드 호버 효과 */
.card-hover {
  transition: all 0.2s ease-out;
}
.card-hover:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

/* 페이드 인 */
.fade-in {
  animation: fadeIn 0.3s ease-out;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

/* 슬라이드 업 (토스트용) */
@keyframes slideUp {
  from { opacity: 0; transform: translate(-50%, 20px); }
  to { opacity: 1; transform: translate(-50%, 0); }
}
.animate-slideUp {
  animation: slideUp 0.3s ease-out;
}

/* 스케일 인 (모달용) */
@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
.animate-scaleIn {
  animation: scaleIn 0.2s ease-out;
}

/* 스켈레톤 로딩 shimmer */
.skeleton {
  background: linear-gradient(90deg, #f3f4f6, #e5e7eb, #f3f4f6);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

/* 터보 로딩 바 */
.turbo-progress-bar {
  height: 3px;
  background: linear-gradient(to right, #0d9488, #9333ea);
}

/* 알림 뱃지 펄스 */
.animate-pulse-dot {
  animation: pulseDot 2s infinite;
}
@keyframes pulseDot {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
```

### 7.3 Stimulus 컨트롤러 패턴
```html
<!-- 로딩 버튼 -->
<button data-controller="button-loading"
        data-action="click->button-loading#start"
        data-button-loading-text-value="처리중...">
  접수하기
</button>

<!-- 드롭다운 -->
<div data-controller="dropdown">
  <button data-action="click->dropdown#toggle">메뉴</button>
  <div data-dropdown-target="menu"
       class="hidden opacity-0 scale-95 transition-all duration-200 origin-top-right">
    <!-- 메뉴 아이템 -->
  </div>
</div>

<!-- 파일 업로드 미리보기 -->
<div data-controller="upload-preview">
  <input type="file" data-action="change->upload-preview#preview">
  <div data-upload-preview-target="preview" class="grid grid-cols-3 gap-2 mt-3"></div>
</div>

<!-- 토스트 자동 닫기 -->
<div data-controller="toast"
     data-toast-dismiss-after-value="4000"
     data-action="animationend->toast#show">
  <!-- 토스트 내용 -->
</div>

<!-- 카운터 (텍스트 영역 글자수) -->
<div data-controller="counter">
  <textarea data-counter-target="input" data-action="input->counter#update" maxlength="500"></textarea>
  <span data-counter-target="count">0</span> / 500
</div>
```

---

## 8. 유저 플로우 & 시나리오별 UI

### 8.1 고객: 누수 체크 접수 플로우
```
랜딩페이지 → [CTA 클릭] → 로그인/회원가입 → 대시보드
  → [새 체크] → 위자드 Step 1 (누수 유형)
  → Step 2 (긴급도) → Step 3 (위치) → Step 4 (주소)
  → Step 5 (상세 설명) → Step 6 (사진/영상 업로드) → Step 7 (확인/접수)
  → 접수 완료 화면 (confetti 효과) → 요청 상세
```

**각 단계 UI 규칙:**
- 프로그레스 바: 상단 고정 (`bg-gradient-to-r from-primary-600 to-purple-600`)
- 질문: 큰 텍스트 (`text-[22px] font-bold text-gray-900`)
- 선택지: 세로 나열 선택 카드 (라디오 패턴)
- 네비게이션: 하단 고정 (이전/다음 버튼 쌍)
- 다음 버튼: 선택 전 disabled, 선택 후 primary 활성화

### 8.2 고객: 견적 수락 플로우
```
알림 수신 → [알림 클릭] → 요청 상세 → [견적 확인] → 견적 상세
  → [수락/거절] → 수락 시 결제 → 결제 완료 → 요청 상세 (상태 변경)
```

### 8.3 에러 시나리오 UI
| 에러 유형 | UI 패턴 |
|---|---|
| 네트워크 오류 | 전체 화면 에러 + 재시도 버튼 |
| 폼 유효성 검증 | 인라인 에러 메시지 (필드 아래 빨간 텍스트) |
| 404 | 일러스트 + "페이지를 찾을 수 없어요" + 홈으로 가기 |
| 500 | 일러스트 + "잠시 문제가 생겼어요" + 재시도 + 고객센터 |
| 권한 없음 | 자물쇠 아이콘 + "접근 권한이 없어요" + 되돌아가기 |

### 8.4 전체 화면 에러 패턴
```html
<div class="min-h-screen bg-gray-50 flex items-center justify-center p-4">
  <div class="text-center max-w-sm">
    <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
      <svg class="w-12 h-12 text-gray-400">...</svg>
    </div>
    <h1 class="text-xl font-bold text-gray-900 mb-2">페이지를 찾을 수 없어요</h1>
    <p class="text-sm text-gray-500 mb-8">요청하신 페이지가 존재하지 않거나 이동되었을 수 있어요</p>
    <div class="space-y-3">
      <%= link_to root_path, class: "block w-full py-4 bg-primary-600 text-white rounded-2xl
                                     font-bold hover:bg-primary-700 transition-all duration-200" do %>
        홈으로 돌아가기
      <% end %>
      <button onclick="history.back()" class="block w-full py-4 bg-white text-gray-700 rounded-2xl
                                               font-semibold border-2 border-gray-200
                                               hover:bg-gray-50 transition-all duration-200">
        이전 페이지로
      </button>
    </div>
  </div>
</div>
```

---

## 9. 접근성 (Accessibility)

### 9.1 필수 규칙
- **명도 대비**: 본문 텍스트 4.5:1 이상, 큰 텍스트 3:1 이상 (WCAG AA)
- **터치 영역**: 최소 44px × 44px (모바일)
- **포커스 표시**: 모든 인터랙티브 요소에 visible focus ring
- **키보드 네비게이션**: Tab으로 모든 요소 접근 가능
- **스크린 리더**: 의미있는 alt 텍스트, aria-label 제공

### 9.2 포커스 스타일
```css
/* 기본 포커스 링 */
:focus-visible {
  outline: 2px solid #0d9488;
  outline-offset: 2px;
  border-radius: inherit;
}

/* 입력 필드 포커스 */
input:focus-visible, textarea:focus-visible, select:focus-visible {
  outline: none;
  border-color: #0d9488;
  box-shadow: 0 0 0 3px rgba(13, 148, 136, 0.1);
}
```

### 9.3 aria 패턴
```html
<!-- 로딩 상태 -->
<button aria-busy="true" aria-label="처리중입니다. 잠시만 기다려주세요">
  <span aria-hidden="true"><!-- spinner --></span>
  처리중...
</button>

<!-- 알림 카운트 -->
<button aria-label="알림 3개">
  <svg><!-- bell --></svg>
  <span class="sr-only">3개의 읽지 않은 알림</span>
  <span aria-hidden="true" class="w-2 h-2 bg-red-500 rounded-full"></span>
</button>

<!-- 모달 -->
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h3 id="modal-title">제목</h3>
</div>

<!-- 상태 변경 알림 -->
<div role="status" aria-live="polite">
  <!-- 실시간 변경 내용 -->
</div>
```

---

## 10. 반응형 브레이크포인트

```
기본 (모바일):  0px~    → 단일 컬럼, 하단 탭 네비
sm (640px~):    640px~  → 약간의 여유 공간
md (768px~):    768px~  → 2열 레이아웃, 상단 네비로 전환
lg (1024px~):   1024px~ → 사이드바 레이아웃 (관리자/전문가)
```

### 주요 반응형 패턴
```html
<!-- 네비게이션 전환 -->
<nav class="md:hidden">하단 탭</nav>
<header class="hidden md:block">상단 네비</header>

<!-- 그리드 확장 -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">

<!-- 사이드바 + 콘텐츠 -->
<div class="lg:flex">
  <aside class="hidden lg:block lg:w-64">사이드바</aside>
  <main class="flex-1">콘텐츠</main>
</div>

<!-- 모바일에서 바텀시트, 데스크톱에서 모달 -->
<div class="md:hidden"><!-- 바텀시트 --></div>
<div class="hidden md:block"><!-- 중앙 모달 --></div>
```

---

## 11. 아이콘 사용 가이드

### 아이콘 스타일
- **라인 아이콘** 기본 사용 (stroke, fill="none")
- **stroke-width**: 2 (기본), 2.5 (강조)
- **크기**: `w-4 h-4` (작은), `w-5 h-5` (기본), `w-6 h-6` (큰), `w-8 h-8` (아이콘 서클 내부)
- **색상**: 부모 요소의 text-color 상속 (`currentColor`)

### 자주 사용하는 아이콘 (Heroicons SVG)
```html
<!-- 플러스 (새 체크) -->
<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/>

<!-- 화살표 (뒤로가기) -->
<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>

<!-- 화살표 (앞으로) -->
<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>

<!-- 위치 핀 -->
<path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>

<!-- 체크마크 -->
<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>

<!-- 경고 (에러) -->
<path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
```

---

## 12. 개발 시 체크리스트

새 페이지를 만들 때 반드시 확인:

### 구조
- [ ] `min-h-screen bg-gray-50 pb-20 md:pb-8` 페이지 래퍼 적용
- [ ] `max-w-4xl mx-auto px-4 py-6` 컨테이너 적용
- [ ] 모바일 하단 네비 렌더링 (`render "shared/customer_nav"`)
- [ ] 데스크톱 상단 네비 렌더링

### 스타일링
- [ ] 카드: `rounded-2xl border-2 border-gray-100` 사용
- [ ] 버튼: `rounded-2xl` 사용 (rounded-lg 금지)
- [ ] 색상: primary 색상 체계만 사용 (blue/indigo 금지)
- [ ] 폰트: Pretendard 기반 size 체계 준수
- [ ] 간격: 8px 그리드 (gap-2, gap-3, mb-6 등)
- [ ] 그림자: 기본 상태에서 shadow 없음, 호버에서만 shadow

### 인터랙션
- [ ] 모든 인터랙티브 요소에 `transition-all duration-200 ease-out` 적용
- [ ] 버튼: hover, active, disabled, loading 4가지 상태 모두 구현
- [ ] 입력 필드: default, focus, error, success, disabled 상태 구현
- [ ] 카드 호버: `hover:shadow-lg hover:border-primary-200 hover:-translate-y-0.5`

### 상태 처리
- [ ] 빈 상태(empty state): dashed border 카드 + CTA
- [ ] 로딩 상태(skeleton): animate-pulse 또는 shimmer
- [ ] 에러 상태: 에러 카드 또는 인라인 에러 메시지
- [ ] 네트워크 에러: 전체 화면 에러 + 재시도

### 접근성
- [ ] 포커스 표시: `:focus-visible` 스타일 적용
- [ ] 터치 영역: 최소 44px
- [ ] alt 텍스트: 모든 이미지에 적용
- [ ] aria-label: 아이콘 전용 버튼에 적용
- [ ] 명도 대비: WCAG AA (4.5:1) 확인

### 문화
- [ ] 모든 텍스트 한국어
- [ ] "신고" → "체크" 용어 준수
- [ ] 이모지 적절히 활용
- [ ] 이미지 사용 시 한국인/아시아인 모델

---

## 13. 공유 컴포넌트 (Shared Partials)

이미 구현된 컴포넌트들. 새 페이지에서 적극 활용할 것:

| 파일 | 용도 | 사용법 |
|---|---|---|
| `shared/card` | 기본 카드 래퍼 | `render "shared/card", title: "제목"` |
| `shared/customer_nav` | 고객 하단 네비 | `render "shared/customer_nav"` |
| `shared/empty_state` | 빈 상태 UI | `render "shared/empty_state", icon: "document", message: "...", action_path: ...` |
| `shared/flash_messages` | 토스트 알림 | `render "shared/flash_messages"` |
| `shared/form_errors` | 폼 에러 표시 | `render "shared/form_errors", resource: @resource` |
| `shared/list_item` | 리스트 항목 | `render "shared/list_item", title: "...", path: ...` |
| `shared/notifications_dropdown` | 알림 드롭다운 | `render "shared/notifications_dropdown"` |
| `shared/onboarding` | 온보딩 플로우 | `render "shared/onboarding"` |
| `shared/page_header` | 페이지 헤더 | `render "shared/page_header", title: "...", back_path: ...` |
| `shared/skeleton_card` | 스켈레톤 카드 | `render "shared/skeleton_card"` |
| `shared/skeleton_list` | 스켈레톤 리스트 | `render "shared/skeleton_list", count: 3` |
| `shared/status_badge` | 상태 뱃지 | `render "shared/status_badge", status: request.status` |
| `shared/status_timeline` | 상태 타임라인 | `render "shared/status_timeline", request_record: @request` |

---

## 14. 페이지별 디자인 명세

### 14.1 고객 앱 (customers/)

#### 랜딩페이지 (`pages/landing`)
- **레이아웃**: 토스 스타일 풀스크린 히어로
- **배경**: `bg-gradient-to-br from-primary-50 via-white to-purple-50`
- **히어로**: 큰 텍스트 (`text-[28px] md:text-5xl font-extrabold`), 그라디언트 텍스트 강조
- **CTA**: 2개 버튼 (Primary 그라디언트 + Secondary 화이트)
- **프로세스**: 3열 카드 (아이콘 + 설명)
- **특징**: 2x2 아이콘+텍스트 그리드
- **최종 CTA**: 풀 너비 그라디언트 배너

#### 대시보드 (`dashboard/index`)
- **레이아웃**: 당근마켓 스타일 카드 나열
- **인사 카드**: 그라디언트 배경 (`from-primary-600 to-primary-700`), 흰색 텍스트
- **빠른 액션**: 3열 그리드, 각 카드에 아이콘 서클 + 텍스트
- **통계**: 3열 그리드, 큰 숫자 + 작은 라벨
- **진행 중인 체크**: 리스트 아이템 패턴
- **빈 상태**: dashed border 카드 + CTA 버튼
- **스켈레톤**: 로딩 시 카드 형태 shimmer

#### 새 체크 접수 (`requests/new`)
- **레이아웃**: 토스 스타일 단계별 위자드 (7단계)
- **프로그레스**: 상단 바 (`bg-gradient-to-r from-primary-600 to-purple-600`)
- **질문**: 큰 텍스트 (`text-[22px] font-bold`)
- **선택지**: 세로 나열 카드 라디오 버튼
- **네비게이션**: 하단 고정 버튼 (이전/다음)
- **완료 화면**: 체크마크 애니메이션 + confetti + 요약 카드

#### 요청 상세 (`requests/show`)
- **상태 바**: 5단계 도트 프로그레스 (`접수 → 배정 → 견적 → 시공 → 완료`)
- **정보 섹션**: 카드 형태로 구분
- **액션 버튼**: 하단 고정 또는 카드 내부

#### 견적 상세 (`estimates/show`)
- **합계**: 큰 숫자 강조 (`text-2xl font-extrabold text-primary-600`)
- **액션**: 수락/거절 버튼 쌍

### 14.2 전문가 앱 (masters/)

#### 대시보드 (메인)
- **통계 카드**: 4열 (매출, 평점, 진행중, 완료)
- **차트**: 월별 매출 바 차트 (Chart.js)
- **최근 요청**: 테이블 (데스크톱) / 카드 (모바일)

### 14.3 관리자 앱 (admin/)

#### 대시보드
- **통계 카드**: 4열 + 차트 2열 + 최근 활동 테이블
- **색상**: 다크 teal 헤더 (`bg-primary-800`)

---

## 15. 우선순위 (P0 → P1 → P2)

### P0 - 핵심 플로우 (먼저 완성)
- 고객 랜딩 ✅
- 고객 대시보드 ✅
- 체크 접수 위자드 ✅
- 로그인/회원가입
- 요청 상세
- 견적 상세

### P1 - 주요 기능
- 요청 목록, 보험 신청, 결제
- 전문가 대시보드 ✅, 견적 작성, 요청 관리
- 메시지/채팅

### P2 - 부가 기능
- 프로필, 설정, 리뷰, 알림
- 관리자 전체
- 정적 페이지, 전문가 보험/정산

---

**버전**: 3.0
**최종 업데이트**: 2026-03-10
**관련 파일**: `CLAUDE.md`, `DESIGN_TOKENS.md`, `INTERACTION_PATTERNS.md`, `REFERENCE_ANALYSIS.md`
