# 디자인 토큰 레퍼런스 가이드
누수체크 프로젝트 구현을 위한 구체적인 토큰 값들

## 색상 토큰 (Color Tokens)

### Primary Colors (주요 색상)
```
blue-600:  #0050E8 - 주요 버튼, 활성 상태, 하이라이트
blue-700:  #0040B8 - 호버 상태 (blue-600 -8% 어둡게)
blue-800:  #002E88 - 프레스 상태 (blue-600 -16% 어둡게)
blue-100:  #E8F0FF - 배경, 포커스 링 배경
blue-50:   #F5F8FF - 밝은 배경, 호버 배경
```

### Status Colors (상태 색상)
```
green-600:  #00B050 - 성공, 완료, 승인
red-600:    #FF6B35 - 에러, 거절, 경고 (당근 스타일)
red-500:    #D32F2F - 위험, 삭제 (다크 레드)
yellow-500: #FFC107 - 경고, 대기 중
orange-600: #FF8C00 - 예약, 진행 중

gray-900:   #333333 - 주요 텍스트
gray-700:   #666666 - 보조 텍스트
gray-600:   #999999 - 라벨, 캡션
gray-300:   #CCCCCC - 비활성, 약한 요소
gray-200:   #E0E0E0 - 테두리, 구분선
gray-100:   #F0F0F0 - 배경, 호버 상태
gray-50:    #F5F5F5 - 밝은 배경
```

### Semantic Colors
```
success:   #00B050 (green-600)
warning:   #FFC107 (yellow-500)
danger:    #FF6B35 (red-600)
error:     #D32F2F (red-500)
info:      #0050E8 (blue-600)
```

---

## 타이포그래피 토큰 (Typography Tokens)

### 글꼴 패밀리
```
Base Font:    -apple-system, BlinkMacSystemFont,
              'Segoe UI', Roboto, 'Helvetica Neue',
              Arial, sans-serif

Korean Font:  'Noto Sans KR' (필요시)
Mono Font:    'SF Mono', Monaco, 'Cascadia Code', monospace
```

### 글꼴 크기 & 굵기 (Font Sizes & Weights)

#### Display (큰 제목)
```
display-lg:    32px, Bold (700), line-height: 1.2
display-md:    28px, Bold (700), line-height: 1.3
```

#### Heading (페이지 제목)
```
heading-xl:    24px, Bold (700), line-height: 1.3
heading-lg:    20px, Bold (700), line-height: 1.4
heading-md:    18px, Semi-bold (600), line-height: 1.4
heading-sm:    16px, Semi-bold (600), line-height: 1.4
```

#### Body (본문)
```
body-lg:       16px, Regular (400), line-height: 1.6
body-md:       14px, Regular (400), line-height: 1.5
body-sm:       12px, Regular (400), line-height: 1.4
```

#### Caption (캡션)
```
caption-md:    12px, Regular (400), color: gray-600, line-height: 1.4
caption-sm:    11px, Regular (400), color: gray-600, line-height: 1.3
```

#### Label (라벨)
```
label-lg:      14px, Semi-bold (600), line-height: 1.4
label-md:      12px, Semi-bold (600), line-height: 1.4
label-sm:      11px, Semi-bold (600), line-height: 1.3
```

### 글꼴 굵기 (Font Weights)
```
light:      300 (거의 사용 안 함)
normal:     400 (본문, 설명)
medium:     500 (강조 (선택))
semibold:   600 (라벨, 작은 제목)
bold:       700 (제목, 중요 텍스트)
```

---

## 간격 토큰 (Spacing Tokens)

### 기본 단위 (8px 그리드)
```
0:     0px
0.5:   2px   (초소형)
1:     4px   (xxs)
1.5:   6px   (xs 변형)
2:     8px   (xs)
2.5:   10px  (sm 변형)
3:     12px  (sm)
3.5:   14px  (md 변형)
4:     16px  (md)
5:     20px  (lg)
6:     24px  (lg+)
8:     32px  (xl)
10:    40px  (xxl)
12:    48px  (xxxl)
```

### Padding (안쪽 여백)
```
button-padding:        px-4 py-3      (16px 좌우, 12px 상하)
card-padding:          p-4            (16px 전체)
large-padding:         p-6            (24px 전체)
section-padding:       p-8            (32px 전체)
container-padding:     px-4 md:px-6   (16px 모바일, 24px 데스크톱)
```

### Margin (바깥쪽 여백)
```
section-gap:           32px (섹션 간)
element-gap:           24px (요소 간)
card-gap:              12px (카드 간)
inline-gap:            8px  (인라인 요소 간)
```

### Line Height
```
tight:     1.2   (제목)
normal:    1.4   (본문)
relaxed:   1.5   (본문 선택)
loose:     1.6   (아주 큰 텍스트)
```

---

## 크기 토큰 (Size Tokens)

### 버튼 높이
```
sm:        32px
md:        40px
lg:        48px (기본)
xl:        56px (대형)
```

### 아이콘 크기
```
xs:        16px
sm:        20px
md:        24px (기본)
lg:        32px
xl:        48px
2xl:       64px
```

### 입력 필드 높이
```
sm:        32px
md:        40px
lg:        48px (기본)
```

### 카드 이미지 높이
```
sm:        120px
md:        200px
lg:        280px
xl:        360px
```

---

## 그림자 토큰 (Shadow Tokens)

### Elevation System (깊이 표현)
```
shadow-0:      none
shadow-1:      0 2px 8px rgba(0, 0, 0, 0.08)
shadow-2:      0 4px 12px rgba(0, 0, 0, 0.12)
shadow-3:      0 8px 24px rgba(0, 0, 0, 0.15)
shadow-4:      0 16px 40px rgba(0, 0, 0, 0.2)
shadow-5:      0 24px 56px rgba(0, 0, 0, 0.25)
```

### 사용처
```
shadow-1:      카드, 버튼, 작은 요소
shadow-2:      호버 상태, 드롭다운, 팝오버
shadow-3:      모달, 드로어, 바텀시트
shadow-4:      통지, 토스트 (최상단)
```

### 커스텀 섀도우
```
shadow-sm:     0 1px 4px rgba(0, 0, 0, 0.06)
shadow-md:     0 2px 8px rgba(0, 0, 0, 0.1)
shadow-lg:     0 4px 16px rgba(0, 0, 0, 0.12)
shadow-xl:     0 8px 32px rgba(0, 0, 0, 0.15)
```

---

## Border Radius 토큰 (Roundness)

```
none:       0px          (정사각형)
xs:         2px          (미묘한 곡선)
sm:         4px          (배지, 작은 요소)
md:         8px          (버튼, 입력 필드, 드롭다운)
lg:         12px         (카드, 모달)
xl:         16px         (큰 카드, 바텀시트 상단)
2xl:        20px         (특대 요소)
3xl:        24px         (히어로 섹션)
full:       9999px       (원형 - 아바타)
```

### 사용처
```
rounded-md:    버튼, 입력 필드, 작은 요소
rounded-lg:    카드, 이미지, 중간 요소
rounded-xl:    모달 상단, 드로어
rounded-full:  아바타, 배지 (원형)
```

---

## 애니메이션 토큰 (Animation Tokens)

### Duration (지속 시간)
```
duration-75:   75ms   (매우 빠른)
duration-100:  100ms  (빠른)
duration-150:  150ms  (약간 빠른)
duration-200:  200ms  (기본)
duration-300:  300ms  (기본 + 약간 느린)
duration-500:  500ms  (느린)
duration-700:  700ms  (매우 느린)
```

### Easing (타이밍 곡선)
```
ease-in:       cubic-bezier(0.4, 0, 1, 1)
ease-out:      cubic-bezier(0, 0, 0.2, 1)        (기본)
ease-in-out:   cubic-bezier(0.4, 0, 0.2, 1)
ease-linear:   linear                             (로딩 스피너용)

Custom curves:
fast-out:      cubic-bezier(0.4, 0, 0.4, 1)
smooth:        cubic-bezier(0.25, 0.46, 0.45, 0.94)
```

### 표준 애니메이션 세트
```
transition-all duration-200 ease-out      /* 기본 호버 */
transition-all duration-300 ease-out      /* 진입 효과 */
transition-colors duration-200 ease-out   /* 색상 변경 */
transition-transform duration-200 ease-out /* 이동/크기 변경 */
```

### Keyframe Animations
```
fadeIn:        opacity 0 → 1, duration-300
slideUp:       translateY(20px) → 0, duration-300
slideDown:     translateY(-20px) → 0, duration-300
scaleIn:       scale(0.95) → 1, duration-200
bounce:        spring-like movement
shimmer:       light sweep left-to-right, 2s loop
spin:          360° rotation, 1-2s loop
pulse:         opacity cycle, 2s loop
```

---

## 투명도 토큰 (Opacity Tokens)

```
opacity-0:     0%    (완전 투명)
opacity-10:    10%   (거의 보이지 않음)
opacity-20:    20%
opacity-30:    30%   (약한 오버레이)
opacity-40:    40%   (중간 오버레이)
opacity-50:    50%
opacity-60:    60%   (비활성화)
opacity-70:    70%
opacity-80:    80%
opacity-90:    90%
opacity-100:   100%  (완전 불투명)
```

### 사용처
```
비활성화된 버튼:     60% opacity
호버 오버레이:       8-10% opacity
배경 흐림 오버레이:   40-60% opacity (모달)
비활성화된 텍스트:   50-60% opacity
약한 구분선:        10% opacity (rgba 사용)
```

---

## Breakpoints (반응형 중단점)

```
xs:    320px    (모바일 작음)
sm:    480px    (모바일)
md:    768px    (태블릿)
lg:    1024px   (데스크톱)
xl:    1440px   (큰 데스크톱)
2xl:   1920px   (초대형)
```

### Tailwind 미디어 쿼리
```
sm:text-16    /* 480px 이상 */
md:text-18    /* 768px 이상 */
lg:text-20    /* 1024px 이상 */
```

---

## 상태별 색상 (State Colors)

### Button States
```
default:       bg-blue-600, text-white
hover:         bg-blue-700, shadow-lg
active:        bg-blue-800, shadow-md
focus:         ring-2 ring-blue-600 ring-offset-2
disabled:      bg-gray-300, text-gray-500, cursor-not-allowed
loading:       bg-blue-600 (opacity-70)
```

### Input States
```
default:       border-gray-300, bg-white
hover:         border-gray-400
focus:         border-blue-600, ring-2 ring-blue-100, shadow-lg
disabled:      bg-gray-100, text-gray-500, border-gray-300
error:         border-red-600, bg-red-50
success:       border-green-600, bg-green-50
```

### Link States
```
default:       text-blue-600
hover:         text-blue-700, underline
active:        text-blue-800
visited:       (해당 없음 - SPA)
focus:         ring-2 ring-blue-600
```

---

## 컴포넌트별 토큰 맵핑 (Component Token Mapping)

### Card Component
```
background:      white
border:          1px solid gray-200
border-radius:   rounded-lg (12px)
shadow:          shadow-1
padding:         p-4
gap:             12px (내부 요소)
```

### Button Component
```
padding:         px-4 py-3
height:          h-12 (48px)
border-radius:   rounded-md (8px)
font-size:       text-base (16px)
font-weight:     font-semibold (600)
transition:      transition-all duration-200 ease-out
```

### Input Field Component
```
height:          h-12 (48px)
padding:         px-4 py-3
border:          border-1
border-radius:   rounded-md (8px)
font-size:       text-base (16px)
focus:ring:      ring-2 ring-blue-100
focus:shadow:    shadow-lg
```

### Modal Component
```
border-radius:   rounded-xl (16px)
shadow:          shadow-3
padding:         p-6
max-width:       max-w-2xl
background:      white
overlay:         bg-black/40
```

### Toast Component
```
padding:         px-4 py-3
height:          h-14 (56px)
border-radius:   rounded-lg (12px)
shadow:          shadow-xl
animation:       slideUp duration-300 ease-out
duration:        3-4s (자동 닫힘)
```

---

## CSS 변수 구현 예제 (CSS Variables)

### Tailwind config.js 에서 커스텀 토큰 정의

```javascript
module.exports = {
  theme: {
    colors: {
      blue: {
        50:  '#F5F8FF',
        100: '#E8F0FF',
        600: '#0050E8',
        700: '#0040B8',
        800: '#002E88',
      },
      green: {
        600: '#00B050',
      },
      red: {
        500: '#D32F2F',
        600: '#FF6B35',
      },
      gray: {
        50:  '#F5F5F5',
        100: '#F0F0F0',
        200: '#E0E0E0',
        300: '#CCCCCC',
        600: '#999999',
        700: '#666666',
        900: '#333333',
      },
    },
    spacing: {
      0:   '0px',
      1:   '4px',
      2:   '8px',
      3:   '12px',
      4:   '16px',
      5:   '20px',
      6:   '24px',
      8:   '32px',
      10:  '40px',
      12:  '48px',
    },
    borderRadius: {
      none: '0px',
      xs:   '2px',
      sm:   '4px',
      md:   '8px',
      lg:   '12px',
      xl:   '16px',
      full: '9999px',
    },
    boxShadow: {
      1: '0 2px 8px rgba(0, 0, 0, 0.08)',
      2: '0 4px 12px rgba(0, 0, 0, 0.12)',
      3: '0 8px 24px rgba(0, 0, 0, 0.15)',
      4: '0 16px 40px rgba(0, 0, 0, 0.2)',
    },
    animation: {
      slideUp: 'slideUp 0.3s ease-out',
      shimmer: 'shimmer 2s infinite',
    },
    keyframes: {
      slideUp: {
        from: { opacity: '0', transform: 'translateY(20px)' },
        to: { opacity: '1', transform: 'translateY(0)' },
      },
      shimmer: {
        '0%': { backgroundPosition: '-1000px 0' },
        '100%': { backgroundPosition: '1000px 0' },
      },
    },
  },
};
```

### CSS 변수 직접 정의

```css
:root {
  /* Colors */
  --color-primary-600: #0050E8;
  --color-primary-700: #0040B8;
  --color-primary-800: #002E88;

  --color-success: #00B050;
  --color-error: #FF6B35;
  --color-warning: #FFC107;

  --color-gray-900: #333333;
  --color-gray-700: #666666;
  --color-gray-600: #999999;
  --color-gray-300: #CCCCCC;
  --color-gray-200: #E0E0E0;
  --color-gray-100: #F0F0F0;
  --color-gray-50:  #F5F5F5;

  /* Spacing */
  --space-1:  4px;
  --space-2:  8px;
  --space-3:  12px;
  --space-4:  16px;
  --space-6:  24px;
  --space-8:  32px;

  /* Typography */
  --text-base:      -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-size-body: 14px;
  --font-size-h1:   24px;
  --line-height:    1.5;

  /* Shadows */
  --shadow-1: 0 2px 8px rgba(0, 0, 0, 0.08);
  --shadow-2: 0 4px 12px rgba(0, 0, 0, 0.12);

  /* Radius */
  --radius-md: 8px;
  --radius-lg: 12px;

  /* Transitions */
  --duration-200: 200ms;
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
}
```

---

## 토큰 사용 시 팁 (Token Usage Tips)

### DO ✓
- 토큰을 항상 사용 (하드코딩 색상값 금지)
- 일관된 간격 단위 사용 (4px 배수)
- 상태별로 적절한 색상 선택
- 애니메이션 duration 200-300ms 범위 준수

### DON'T ✗
- 임의의 색상값 사용 (예: #F2A5C7)
- 랜덤한 간격 (예: 13px, 27px)
- 너무 빠른 애니메이션 (100ms 이하)
- 일관성 없는 border-radius

---

## 마이그레이션 체크리스트

- [ ] 모든 색상을 토큰으로 변경
- [ ] 모든 간격을 8px 그리드에 맞춤
- [ ] 모든 애니메이션 duration 200-300ms로 통일
- [ ] border-radius 표준값 적용
- [ ] 그림자 elevation system 적용
- [ ] 타이포그래피 계층 통일
- [ ] 상태별 색상 일관되게 적용
- [ ] 모바일 반응형 breakpoint 적용

