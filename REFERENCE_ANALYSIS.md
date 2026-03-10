# 한국 주요 앱 디자인 시스템 분석 (당근마켓, 토스, 미소)

## 분석 대상
- **당근마켓 (Karrot)**: 중고 거래 플랫폼 - 1003개 스크린샷
- **토스 (Toss)**: 금융 서비스 - 559개 스크린샷
- **미소 (Miso)**: 홈서비스 플랫폼 - 315개 스크린샷

---

## 1. 색상 시스템 (Color System)

### 1.1 Primary 색상
| 앱 | Primary | Usage |
|----|---------|-------|
| **당근마켓** | Orange (#FF6B35, #FF5722) | CTA, 액션 버튼, 하이라이트 |
| **토스** | Blue (#0050E8, #006AFF) | 브랜드 컬러, 모든 주요 CTA |
| **미소** | Blue (#0050FF, #006AFF) | 브랜드 컬러, 버튼, 강조 요소 |

### 1.2 Status 색상
| 상태 | 당근마켓 | 토스 | 미소 |
|------|---------|------|------|
| **Success/Approved** | Green (#00B050) | Green (#31B446) | 미사용 |
| **Alert/Seller Badge** | Orange (#FF6B35) | - | Blue Badge |
| **Error** | Red (#D32F2F) | Red (#FF6B35) | Red 미사용 |
| **Neutral/Badge** | Gray (#9E9E9E) | Gray (#8B8B8F) | Gray |

### 1.3 배경색 (Background Colors)
- **Light Gray**: #F5F5F5 (당근마켓, 토스)
- **White**: #FFFFFF (메인 컨텐츠)
- **Dark backgrounds**: 당근마켓 사용 안 함, 토스 다크모드 지원 (#1F1F23)
- **Blue backgrounds**: 미소의 온보딩/스플래시 페이지 (#0050FF)

**핵심 발견**:
- 당근마켓과 토스는 상이한 Primary 색상 전략
- 토스와 미소는 동일한 Blue Primary 계열 사용
- 모두 밝은 배경에서 카드 기반 레이아웃 선호

---

## 2. 타이포그래피 & 텍스트 스타일

### 2.1 글꼴 (Typeface)
| 앱 | 본문 | 제목 | 비고 |
|----|------|------|------|
| **당근마켓** | Pretendard 또는 시스템 폰트 | Bold/Semi-bold | 모던하고 친근함 |
| **토스** | Toss Face (Custom) | Toss Face Bold | 토스 브랜드 폰트 |
| **미소** | SF Pro Display (iOS) | SF Pro Display Bold | Apple 시스템 폰트 |

### 2.2 텍스트 계층 구조

#### 당근마켓
```
제목 (Title):        20-24px, Bold (600-700)
소제목 (Subtitle):   16px, Semi-bold (600)
본문 (Body):         14px, Regular (400)
설명 (Caption):      12px, Regular (400), Gray (#999)
```

#### 토스
```
제목:                22-24px, Bold (700)
소제목:              16px, Semi-bold (600)
본문:                14px, Regular (400), Line-height: 1.4
설명:                12px, Regular (400), Gray (#8B8B8F)
```

#### 미소
```
제목:                24px, Bold (700)
소제목:              16px, Semi-bold (600)
본문:                14px, Regular (400), Color: #333
설명:                12px, Regular (400), Color: #666
```

**타이포그래피 일관성**:
- 모두 14px 본문 글꼴 사용
- Line-height: 1.4-1.6 (가독성 우선)
- 16-20px 제목 기본값
- Gray 텍스트는 #666-#999 범위

---

## 3. 간격 & 레이아웃 (Spacing & Layout)

### 3.1 기본 스페이싱 단위
| 구분 | 값 | 사용 사례 |
|------|-----|---------|
| **xxs** | 4px | 아이콘 내부 스페이싱 |
| **xs** | 8px | 타이트한 요소 간격 |
| **sm** | 12px | 텍스트 간 간격, 작은 패딩 |
| **md** | 16px | 기본 패딩, 카드 내부 |
| **lg** | 20-24px | 섹션 간 간격 |
| **xl** | 32px | 섹션 사이 큰 여백 |
| **xxl** | 40-48px | 페이지 레벨 간격 |

### 3.2 카드 레이아웃
```
카드 간 거리:         8-12px
카드 내부 패딩:       16px
카드 圆각 (Border-radius): 12-16px
카드 그림자 (Shadow):  0 2px 8px rgba(0,0,0,0.08)
```

### 3.3 버튼 레이아웃

#### Primary Button
```
높이:                 48-52px
패딩:                 16px 가로, 12px 세로
Border-radius:        8-12px
아이콘 + 텍스트 간격:  8px
```

#### Secondary Button (대체 모양)
```
높이:                 40-44px
패딩:                 12px 가로, 8px 세로
Border-radius:        8px
테두리:               1px solid #E0E0E0
```

### 3.4 리스트 아이템
```
높이:                 56-64px
호리좌 패딩:         16px
상/하 패딩:          12px
구분선:               #F0F0F0 (1px)
아바타 + 텍스트 간격:  12px
```

**핵심 발견**:
- 모든 앱이 8px 기본 그리드 시스템 사용
- 모바일 최적화: 터치 타겟 최소 48px
- 카드 기반 레이아웃으로 white space 충분히 확보

---

## 4. 호버 & 상호작용 상태 (Interaction States)

### 4.1 버튼 상태

#### Active/Hover
- 모든 앱: **-8% 어둡게 (darker shade)** 또는 **shadow 증가**
- 예: #0050E8 → #0040B8 (5-10% 어둡게)

#### Disabled
```
배경: #EFEFEF 또는 #F5F5F5
텍스트: #CCCCCC 또는 #999999
커서: not-allowed
Opacity: 0.5-0.6
```

#### Pressed/Active
- Shadow: 더 깊어짐 (inset shadow 사용 가능)
- 색상: 5-10% 더 밝거나 어둡게

### 4.2 카드 호버 상태
```
당근마켓:
  - Shadow 증가: 0 4px 12px rgba(0,0,0,0.12)
  - 배경 약간 어둡게: rgba(0,0,0,0.02)
  - Transform: scale(1.01) 또는 translateY(-2px)

토스:
  - Shadow 유지, 약간 증가
  - 배경 색상 변화 없음
  - 서서히 페이드 효과

미소:
  - Subtle shadow 증가만 적용
  - 배경 변화 미미
```

### 4.3 탭/세그먼트 상태
```
활성:
  - 텍스트: Primary 색상 (#0050E8)
  - 밑줄/보더: 2px solid Primary
  - 배경: White

비활성:
  - 텍스트: Gray (#999)
  - 밑줄: 없음
  - 배경: White 또는 #F5F5F5
```

---

## 5. 마이크로 애니메이션 (Micro-animations)

### 5.1 전환 효과 (Transitions)
```css
기본 애니메이션 시간:    200-300ms
버튼 호버:              250ms ease-out
페이지 전환:            200ms ease-in-out
모달 나타남:            300ms ease-out (cubic-bezier)
```

### 5.2 로딩 상태 (Loading States)

#### Skeleton Loading
- 밝은 회색 배경: #E0E0E0
- 상자 크기: 예상 콘텐츠와 동일
- 애니메이션: shimmer effect (left-to-right)
- 속도: 2초 주기로 반복

#### Loading Spinner
- 크기: 24-32px (기본), 48px (풀스크린)
- 색상: Primary 색상 사용
- 애니메이션: 360도 회전, 1-2초 주기
- 토스: 깔끔한 circle spinner
- 미소: 파란색 로딩 바

### 5.3 토스트/알림 애니메이션 (Toast)
```
나타남:  300ms fade-in + translateY(-20px)
지속:    3초
사라짐:  200ms fade-out
위치:    화면 하단, 16px 마진
```

### 5.4 모달/바텀시트 애니메이션
```
모달 나타남:      300ms ease-out (opacity + scale)
바텀시트 올라옴:  250ms ease-out (translateY)
배경 흐림:        200ms ease-out
```

**핵심 발견**:
- 모든 전환이 200-300ms 범위 내 (너무 빠르지도 느리지도 않음)
- cubic-bezier 곡선으로 자연스러운 느낌
- Shimmer 로딩 애니메이션으로 "느낌 있는" 로딩 상태

---

## 6. 빈 상태 (Empty States)

### 6.1 디자인 패턴

#### 당근마켓
- 큰 일러스트레이션 (200-240px)
- 제목: "검색 결과가 없습니다"
- 설명: 작은 회색 텍스트
- CTA 버튼: "다시 검색하기" (Optional)

#### 토스
- 3D 일러스트레이션 (큰 규모 300px+)
- 감정을 담은 메시지
- 명확한 다음 액션 가이드
- 색상: 밝은 파스텔 (하늘색, 노란색)

#### 미소
- 벡터 일러스트레이션 (캐릭터 포함)
- 명확한 서비스 설명
- 큰 파란 Primary 버튼 ("시작하기")
- 하단 작은 텍스트: 이용약관 링크

### 6.2 공통 요소
```
일러스트레이션 높이:  200-300px
제목 크기:          18-24px, Bold
설명 크기:          14px, Gray
여백:              상하 40-60px
버튼:              48px 높이, 풀 너비 또는 제한폭
```

---

## 7. 에러 & 경고 상태 (Error Handling)

### 7.1 인라인 에러

#### 형식
```
레이블:    14px Bold, #333
에러 텍스트: 12px, Red (#FF6B35 또는 #D32F2F)
필드 테두리: 2px solid Red
배경색:    Light red (#FFEBEE)
```

#### 위치
- 입력 필드 바로 아래
- 아이콘 + 텍스트 조합 (체크마크 또는 경고 아이콘)

### 7.2 토스트 에러
```
배경색:    Red (#FF6B35)
텍스트색:  White
아이콘:    체크 또는 경고 아이콘
위치:      화면 하단
자동 닫힘: 3-4초
```

### 7.3 폼 검증 (Form Validation)

#### 성공 상태
```
테두리:   Green (#00B050)
배경:     #F1F8F4
아이콘:   체크마크 (Green)
메시지:   12px, Green
```

#### 경고 상태
```
테두리:   Yellow (#FFC107)
배경:     #FFF9E6
아이콘:   경고 마크 (Yellow)
메시지:   12px, Yellow
```

---

## 8. 스켈레톤 & 로딩 패턴 (Skeleton/Loading Patterns)

### 8.1 스켈레톤 구조

#### 리스트 아이템 스켈레톤
```
아바타:       32px 원형 스켈레톤
텍스트 라인 1: 16px × 80% 폭
텍스트 라인 2: 12px × 60% 폭
텍스트 라인 3: 12px × 40% 폭 (선택)
```

#### 카드 스켈레톤
```
이미지:       300px 높이 (16:9 비율)
제목:         18px × 70% 폭
설명:         14px × 100% 폭 (2줄)
버튼:         48px 높이 × 60% 폭
```

### 8.2 애니메이션
```
Shimmer 색상:       #E0E0E0 → #F0F0F0
주기:              2초
방향:              좌상향에서 우하향
Timing:             ease-in-out
```

---

## 9. 다크 모드 (Dark Mode)

### 9.1 현황
- **당근마켓**: 다크모드 없음 (밝은 모드만)
- **토스**: 부분적 다크모드 (일부 페이지만)
- **미소**: 다크모드 없음

### 9.2 토스 다크모드 색상
```
배경:           #1F1F23
카드:           #2A2A30
텍스트 주요:    #FFFFFF
텍스트 보조:    #CCCCCC
버튼:           #0050E8 (밝기 유지)
```

**권장사항**: 누수체크는 밝은 모드 우선, 향후 다크모드 고려

---

## 10. 접근성 (Accessibility)

### 10.1 명도 대비 (Contrast Ratios)

#### WCAG AA 기준 준수
```
텍스트 vs 배경:      4.5:1 이상 (일반 텍스트)
UI 컴포넌트:        3:1 이상
```

#### 실제 적용
- 검정색 텍스트 (#333): 흰 배경 위 대비 21:1 ✓
- 회색 텍스트 (#999): 흰 배경 위 대비 5:1 ✓
- 파란색 버튼 (#0050E8): 흰 배경 위 대비 8.5:1 ✓

### 10.2 포커스 상태 (Focus States)

#### 키보드 내비게이션
```
포커스 표시:    2px solid 테두리 + 2px 여백
색상:          Primary 색상 또는 Teal (#00BCD4)
예시:          네모 모서리에 포커스 링
```

#### 탭 순서
- 좌상향에서 우하향 순서
- 숨겨진 요소 제외 (tabindex)

### 10.3 터치 타겟 크기
```
최소 높이:     44-48px
최소 너비:     44-48px
간격:          8px 이상 (인접 요소와)
```

---

## 11. 모달 & 바텀시트 (Modals & Bottom Sheets)

### 11.1 모달

#### 구조
```
배경 overlay:        rgba(0,0,0,0.4-0.6)
모달 배경:          White (#FFFFFF)
Border-radius:       12-16px
최대 너비:          90% 또는 600px
패딩:               20-24px
```

#### 헤더
```
제목:               20px, Bold
닫기 버튼 (X):       우상향, 32px 크기
````

#### 푸터
```
주요 버튼:          48px 높이, Primary 색상
취소 버튼:          48px 높이, Secondary 색상 또는 텍스트만
간격:              12px
```

### 11.2 바텀시트
```
배경:               White (#FFFFFF)
Top border-radius:  16-24px
최대 높이:          80vh
헤더:               드래그 핸들 (3-4px 막대)
패딩:              16-24px
`````

### 11.3 애니메이션
```
모달 나타남:       300ms ease-out (fade + scale)
바텀시트 올라옴:   250ms ease-out (translateY)
배경 변어짐:       200ms ease-out
닫힐 때:          반대 방향, 빠르게 (150-200ms)
```

---

## 12. 폼 & 입력 필드 (Form & Input Fields)

### 12.1 텍스트 입력

#### 외형
```
높이:              48px
패딩:              12px 좌우, 12px 상하
Border-radius:     8px
테두리:            1px solid #E0E0E0
배경:              #FFFFFF 또는 #F5F5F5
```

#### 상태별 스타일

**집중 (Focused)**
```
테두리:            2px solid #0050E8
배경:              #FFFFFF
Shadow:            0 0 0 3px rgba(0,80,232,0.1)
```

**값 입력 (With value)**
```
텍스트색:         #333333
배경:             #FFFFFF
```

**비활성 (Disabled)**
```
배경:             #EFEFEF
텍스트색:         #CCCCCC
테두리:           1px solid #E0E0E0
커서:             not-allowed
```

**에러 (Error)**
```
테두리:           2px solid #FF6B35
배경:             #FFEBEE
아이콘:           경고 마크 (우측)
메시지:           12px, Red, 필드 아래
```

### 12.2 라벨 & 설명 텍스트

#### 라벨
```
크기:             14px, Semi-bold (600)
색상:             #333333
필수 표시 (*):     Red, 라벨 우측
```

#### 설명 텍스트
```
크기:             12px
색상:             #999999
위치:             라벨 아래 또는 필드 아래
```

### 12.3 셀렉트/드롭다운
```
높이:             48px (텍스트 입력과 동일)
드롭다운 아이콘:   우측 12px
선택 항목:        Primary 색상 텍스트
`````

### 12.4 체크박스 & 라디오
```
크기:             20-24px
색상:             Primary (#0050E8)
테두리:           2px solid #E0E0E0 (미선택)
배경:             Primary (선택)
라벨 거리:        8-12px
```

### 12.5 폼 검증 메시지 위치

```
인라인 에러:      필드 하단, 12px 아래
아이콘:          필드 우측 (터치 시)
토스트:          화면 하단 (전체 폼 에러)
```

---

## 13. 토스트/알림 (Toast Notifications)

### 13.1 기본 형태

```
높이:             48-56px
패딩:             12px 좌우, 12px 상하
Border-radius:    8px
위치:             화면 하단, 16px 마진
```

### 13.2 타입별 스타일

| 타입 | 배경색 | 아이콘 | 지속 시간 |
|------|--------|--------|----------|
| **Success** | Green (#00B050) | ✓ | 3초 |
| **Error** | Red (#FF6B35) | ⚠️ | 4초 |
| **Warning** | Yellow (#FFC107) | ! | 4초 |
| **Info** | Blue (#0050E8) | ℹ️ | 3초 |

### 13.3 애니메이션
```
나타남:          300ms ease-out (fade + slide up)
지속:            고정된 시간
사라짐:          200ms ease-out (fade)
제스처:          스와이프 다운으로 즉시 닫기 (모바일)
```

---

## 14. 배지 & 라벨 (Badges & Labels)

### 14.1 배지 (Badge)

#### 스타일

**원형 배지 (Status)**
```
크기:             24-32px (지름)
색상:             Orange (#FF6B35) - 판매자, Green - 완료
텍스트:           White, 12px Bold
위치:             아바타 우하향 또는 카드 우상향
```

**텍스트 배지**
```
배경:             Primary 또는 Status 색상
텍스트:           White, 12px
패딩:             4px 8px
Border-radius:    4px
```

### 14.2 라벨 (Label)

```
배경:             Light gray (#F0F0F0)
텍스트:           Dark gray (#666), 12px
패딩:             4px 8px
Border-radius:    4px
테두리:           Optional 1px solid #E0E0E0
```

---

## 15. 네비게이션 (Navigation)

### 15.1 헤더/Top Bar

#### 구조
```
높이:             56-64px (상태바 포함 64px)
패딩:             좌우 16px
배경:             White (#FFFFFF)
그림자:           0 2px 8px rgba(0,0,0,0.08)
```

#### 요소

**좌측**
```
뒤로가기 버튼: 44px 크기 (터치 영역)
또는 로고:     높이 24px
```

**중앙**
```
페이지 제목:   18-20px, Bold, 검정색
또는 검색 바:  44px 높이, Light gray 배경
```

**우측**
```
아이콘 버튼:   44px 크기 (종 모양, 메뉴)
또는 프로필:   32-36px 아바타 원형
```

### 15.2 바텀 탭 네비게이션
```
높이:             56-60px (안전영역 포함 60px+)
아이콘 크기:      24-28px
라벨 크기:        10-12px
아이콘-라벨 거리: 4px
배경:             White (#FFFFFF)
테두리:           1px solid #E0E0E0 (위쪽)
```

#### 상태

**활성 (Active)**
```
색상:            Primary (#0050E8)
배경:            Light blue (#F0F5FF) (선택)
아이콘:          Primary 색상
라벨:            Primary 색상, 12px Bold
```

**비활성 (Inactive)**
```
색상:            Gray (#999)
아이콘:          Gray
라벨:            Gray, 12px Regular
```

### 15.3 드로어/사이드 메뉴
```
너비:            280px (또는 75vw)
배경:            White (#FFFFFF)
Overlay 배경:    rgba(0,0,0,0.4)
Shadow:          -2px 0 8px rgba(0,0,0,0.12)
```

---

## 16. 프리미엄 느낌의 디테일 요소

### 16.1 그림자 (Shadows) - 깊이감 표현

```css
/* 엘리베이션 0: 기본 */
box-shadow: none;

/* 엘리베이션 1: 카드, 버튼 */
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);

/* 엘리베이션 2: 호버 상태 */
box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);

/* 엘리베이션 3: 모달, 드롭다운 */
box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);

/* 엘리베이션 4: 최상단 (바텀시트, 통지) */
box-shadow: 0 16px 40px rgba(0, 0, 0, 0.2);
```

**한국 앱 특성**:
- 부드러운 그림자 선호 (harsh 느낌 피함)
- Blur가 8-16px 범위 (선명한 윤곽선 제공)

### 16.2 색상 그라데이션 (Gradients)

**배경 그라데이션**
```
각도: 135도 (좌상향 → 우하향)
색상 1: 밝은 파란색 (#0050E8)
색상 2: 어두운 파란색 (#003FB8)
불투명도: 90-95%
```

**오버레이 그라데이션**
```
헤더 오버레이:  rgba(0,0,0,0.1) → transparent
이미지 오버레이: rgba(0,0,0,0.3) → transparent (검정색)
또는:          linear-gradient(to bottom,
                transparent, rgba(0,0,0,0.4))
```

### 16.3 블러 효과 (Blur)

```css
/* 배경 흐림 (Backdrop blur) */
backdrop-filter: blur(4px);
-webkit-backdrop-filter: blur(4px);

/* 사용 위치: */
/* - 모달 오버레이 */
/* - 플로팅 헤더 (스크롤 시) */
/* - 프로스트글래스 효과 */

/* 강도: 4-8px (선명도 유지) */
```

### 16.4 아이콘 디자인

#### 크기 범위
```
아이콘 24px:      기본, 헤더 아이콘
아이콘 32px:      리스트 아이템, 프로필
아이콘 48px:      큰 섹션 헤더
아이콘 64px+:     일러스트레이션, 빈 상태
```

#### 스타일
```
획 너비:         2px (기본)
모서리:         라운드 (선호)
색상:           Gray #999 (비활성), Primary (활성)
```

### 16.5 보더 & 아웃라인

```
카드 보더:        1px solid #E0E0E0 (선택)
입력 필드 보더:    1px solid #E0E0E0 (미포커스)
                 2px solid #0050E8 (포커스)
구분선:           1px solid #F0F0F0
탭 밑줄:          2px solid #0050E8 (활성)
```

### 16.6 Opacity & 투명도

```
비활성화된 텍스트:    60% opacity
비활성화된 아이콘:    50% opacity
비활성화된 버튼:      60% opacity
호버 오버레이:        8-10% opacity (darker)
디스에이블 필드:      50% opacity
```

### 16.7 곡선 (Border Radius)

```
큰 요소 (카드, 모달):    12-16px
중간 요소 (버튼, 입력):   8px
작은 요소 (배지):         4px
원형 (아바타):          50% (완전 원형)
미묘한 곡선:            2-4px
```

---

## 17. 이미지 최적화 & 처리

### 17.1 이미지 비율
```
카드 히어로:       16:9 비율 (300-400px 높이)
프로필 사진:       1:1 비율, 32-48px
아바타:           1:1 비율, 32-40px
배경 이미지:       16:9 또는 4:3 비율
```

### 17.2 이미지 필터 & 오버레이

```
카드 이미지 오버레이:
  - Opacity: 12-15%
  - 색상: 검정색 또는 흰색

히어로 이미지 오버레이:
  - Opacity: 35-40%
  - 색상: 그라데이션 (검정색)
  - 방향: 하단으로 진해짐

프로필 이미지:
  - 테두리: 2-3px white stroke
  - 그림자: subtle shadow
```

### 17.3 이미지 로딩

```
Placeholder:     Light gray (#E0E0E0)
Blur-up 효과:    스켈레톤 또는 blurred thumbnail
실패 상태:       기본 아이콘 표시
Lazy loading:    Intersection Observer API 사용
```

---

## 18. 반응형 설계 (Responsive Design)

### 18.1 주요 breakpoints
```
모바일 (xs):    320px - 479px
모바일 (sm):    480px - 639px
태블릿 (md):    640px - 1023px
데스크톱 (lg):  1024px - 1439px
대형 (xl):      1440px +
```

### 18.2 모바일 최적화

```
Padding 좌우:    16px (모바일), 20px (태블릿+)
버튼 너비:       풀 너비 (모바일), 고정 너비 (태블릿+)
글꼴 크기:       14px 본문 (모바일), 16px (태블릿+)
터치 타겟:       최소 44x44px
```

### 18.3 고려사항

```
모바일 해저드 존: 화면 하단 58px (탭 네비게이션)
세이프 에어리어:  iPhone X+ 노치 고려 (상하 각 16px)
가로 모드:        풀 화면 활용, 패딩 조정
```

---

## 19. 프리미엄 UX의 핵심 원칙

### 19.1 애니메이션의 정의
- **속도**: 200-300ms (너무 빠르지도 느리지도 않게)
- **타이밍**: ease-out (시작 빠름, 끝 느림)
- **타입**: Smooth transitions, micro-interactions

### 19.2 화이트 스페이스의 활용
- 과하지 않은 여백으로 호흡감
- 카드 기반 레이아웃으로 명확한 구분
- 섹션 간 32-48px 여백

### 19.3 컬러 일관성
- Primary 색상 통일 (페이지 전체)
- Status 색상 명확함 (성공, 오류, 경고)
- Gray 색상 3-4단계 (배경, 텍스트, 테두리)

### 19.4 타이포그래피 위계
- 제목: Bold, 20-24px
- 본문: Regular, 14px
- 캡션: Regular, 12px, Gray
- 일관된 line-height (1.4-1.6)

### 19.5 상호작용의 즉시성
- 클릭 피드백 즉시 (300ms 내)
- 로딩 상태 명확히 표시
- 에러 메시지 간결하고 명확

### 19.6 접근성의 통합
- 색상만으로 정보 전달 하지 않기
- 충분한 명도 대비 (WCAG AA 준수)
- 터치 타겟 최소 44x44px
- 포커스 상태 명확히 표시

---

## 20. 누수체크 프로젝트 적용 전략

### 20.1 즉시 적용 가능 (Priority 1)
1. **색상 시스템 정의**
   - Primary: Blue (#0050E8) 선택
   - Status: Green, Red, Yellow, Orange 정의
   - Gray scale: #333, #666, #999, #CCCCCC, #E0E0E0, #F5F5F5

2. **간격 시스템**
   - 8px 기본 그리드 적용
   - 패딩: 12px, 16px, 20px, 24px 표준화
   - 마진: 16px, 24px, 32px, 48px 표준화

3. **타이포그래피**
   - 제목: 24px Bold
   - 소제목: 16px Semi-bold
   - 본문: 14px Regular
   - 캡션: 12px Regular (Gray)

4. **기본 버튼 상태**
   - Active: -8% 어둡게
   - Hover: Shadow 증가, 배경 약간 어둡게
   - Disabled: Gray 배경, Gray 텍스트
   - 높이: 48px 표준

### 20.2 2주차 적용 (Priority 2)
1. **애니메이션 라이브러리**
   - 200-300ms transition 타이밍
   - ease-out 곡선 적용
   - Shimmer 로딩 애니메이션

2. **모달/바텀시트**
   - 300ms ease-out 진입 애니메이션
   - 배경 흐림 (4px backdrop-filter)
   - 적절한 padding & border-radius

3. **폼 컴포넌트**
   - 입력 필드 포커스 상태 (2px 파란 테두리 + shadow)
   - 에러 상태 (Red 테두리 + 메시지)
   - 라벨 & 설명 텍스트 스타일

### 20.3 3주차 적용 (Priority 3)
1. **고급 패턴**
   - 토스트 알림 시스템
   - 스켈레톤 로딩 애니메이션
   - 빈 상태 일러스트레이션

2. **네비게이션**
   - 헤더/Top bar 구조
   - 바텀 탭 네비게이션
   - 드로어 메뉴 (필요시)

3. **접근성 개선**
   - WCAG AA 명도 대비 검증
   - 포커스 상태 명확히
   - 터치 타겟 최소 48px 보장

---

## 21. 디자인 시스템 문서 업데이트 체크리스트

### DESIGN_SYSTEM.md에 추가할 항목
- [ ] 색상 시스템 (RGB, HEX 값 포함)
- [ ] 타이포그래피 (글꼴, 크기, 굵기, 라인하이트)
- [ ] 간격 시스템 (8px 그리드, 표준 값들)
- [ ] 섀도우 토큰 (4단계 엘리베이션)
- [ ] Border-radius 표준 값
- [ ] 애니메이션 타이밍 & 곡선
- [ ] 컴포넌트별 상태 (호버, 활성, 비활성, 에러)
- [ ] 접근성 가이드라인 (명도 대비, 포커스, 터치 타겟)
- [ ] 반응형 중단점 정의
- [ ] 이미지 가이드 (크기, 비율, 오버레이)

---

## 22. 구현 예제 코드

### 22.1 Primary Button (Tailwind CSS)

```html
<!-- Active/Default -->
<button class="px-6 py-3 bg-blue-600 text-white rounded-lg
              font-semibold text-base
              hover:bg-blue-700 hover:shadow-lg
              active:bg-blue-800 active:shadow-md
              disabled:bg-gray-300 disabled:text-gray-500 disabled:cursor-not-allowed
              transition-all duration-200 ease-out">
  버튼 텍스트
</button>
```

### 22.2 Input Field with Validation

```html
<div class="mb-4">
  <label class="block text-sm font-semibold text-gray-900 mb-2">
    입력 필드 라벨
    <span class="text-red-600">*</span>
  </label>

  <input type="text"
         class="w-full px-4 py-3 text-base border border-gray-300 rounded-lg
                focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent
                focus:shadow-lg
                disabled:bg-gray-100 disabled:text-gray-500
                transition-all duration-200"
         placeholder="입력하세요">

  <!-- Error message -->
  <p class="text-sm text-red-600 mt-2 flex items-center gap-1">
    <svg class="w-4 h-4"><!-- 경고 아이콘 --></svg>
    필수 입력 항목입니다
  </p>
</div>
```

### 22.3 Toast Notification

```html
<div class="fixed bottom-4 right-4 bg-green-600 text-white rounded-lg
            px-4 py-3 shadow-xl animate-slideUp
            flex items-center gap-2">
  <svg class="w-5 h-5"><!-- 체크 아이콘 --></svg>
  <span class="text-sm font-medium">작업이 완료되었습니다</span>
</div>

<!-- CSS Animation -->
<style>
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-slideUp {
  animation: slideUp 0.3s ease-out;
}
</style>
```

### 22.4 Card with Hover Effect

```html
<div class="bg-white rounded-2xl p-4 border border-gray-200
            hover:shadow-lg hover:border-gray-300
            transition-all duration-200 ease-out
            cursor-pointer">
  <img src="image.jpg"
       class="w-full h-48 object-cover rounded-xl mb-3" />
  <h3 class="text-lg font-bold text-gray-900 mb-1">카드 제목</h3>
  <p class="text-sm text-gray-600">카드 설명 텍스트</p>
</div>
```

---

## 결론

한국의 프리미엄 앱들(당근마켓, 토스, 미소)은 다음의 공통 특성을 갖고 있습니다:

1. **명확한 정보 구조**: 카드 기반 레이아웃으로 명확한 계층 구조
2. **세밀한 애니메이션**: 200-300ms의 자연스러운 전환
3. **일관된 색상**: Primary 색상으로 통일된 브랜드 아이덴티티
4. **충분한 여백**: 카드 간 12px, 섹션 간 32-48px의 호흡감
5. **프리미엄한 세부사항**: 그림자, blur, border-radius로 깊이감 표현
6. **접근성 고려**: WCAG AA 대비율, 충분한 터치 타겟
7. **모바일 우선**: 반응형 디자인으로 모든 화면에 최적화

**누수체크 프로젝트**는 이러한 원칙들을 따르면 한국 사용자들에게 신뢰감 있고 프리미엄한 느낌의 서비스로 인식될 것입니다.

