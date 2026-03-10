# 한국 프리미엄 앱 상호작용 패턴 분석

## 1. 버튼 상호작용 (Button Interactions)

### 1.1 Primary Button Flow

#### 기본 상태 (Default)
```
배경색:      #0050E8 (파란색)
텍스트색:    White
그림자:      0 2px 8px rgba(0, 0, 0, 0.08)
높이:        48px
너비:        100% (모바일) 또는 제한폭
```

#### 호버 상태 (Hover) - 마우스 또는 포커스
```
배경색:      #0040B8 (8% 어둡게)
그림자:      0 4px 12px rgba(0, 0, 0, 0.12) (증가)
변환:        scale(1.01) 또는 그림자만 증가
지속시간:    250ms ease-out
```

#### 프레스 상태 (Pressed/Active)
```
배경색:      #002E88 (16% 어둡게)
그림자:      0 2px 4px rgba(0, 0, 0, 0.08) (감소)
변환:        scale(0.99) 또는 inset shadow 추가
지속시간:    100ms (즉시 반응)
```

#### 비활성화 (Disabled)
```
배경색:      #EFEFEF (회색)
텍스트색:    #CCCCCC (밝은 회색)
커서:        not-allowed
불투명도:    60% 또는 배경색 변경
그림자:      없음
```

#### 로딩 상태 (Loading)
```
배경색:      #0050E8 (유지)
텍스트:      숨김 또는 투명하게
스피너:      흰색 회전 로더 (20px)
위치:        텍스트 왼쪽 또는 중앙
```

### 1.2 Secondary Button Flow

#### 기본 상태
```
배경색:      #F5F5F5 (밝은 회색)
텍스트색:    #333333 (검정색)
테두리:      1px solid #E0E0E0
```

#### 호버 상태
```
배경색:      #E8E8E8 (약간 어둡게)
테두리:      1px solid #CCCCCC
그림자:      0 2px 8px rgba(0, 0, 0, 0.08)
```

### 1.3 텍스트 버튼 (Text Only Button)

#### 기본 상태
```
배경색:      없음 (투명)
텍스트색:    #0050E8 (파란색)
```

#### 호버 상태
```
배경색:      rgba(0, 80, 232, 0.08) (10% 불투명한 파란색)
텍스트색:    #0040B8 (어둡게)
```

---

## 2. 입력 필드 상호작용 (Input Field Interactions)

### 2.1 텍스트 입력 필드

#### 기본 상태 (Default/Idle)
```
높이:          48px
패딩:          12px 좌우, 12px 상하
테두리:        1px solid #E0E0E0
배경색:        #FFFFFF (흰색)
텍스트색:      #333333
플레이스홀더:  #999999, 400 weight
그림자:        없음
```

#### 포커스 상태 (Focused)
```
테두리:        2px solid #0050E8 (파란색)
배경색:        #FFFFFF (유지)
그림자:        0 0 0 3px rgba(0, 80, 232, 0.1)
캐럿 색상:     #0050E8
지속시간:      200ms ease-out
```

#### 값 입력 상태 (With Value)
```
테두리:        1px solid #E0E0E0 (기본 유지)
배경색:        #FFFFFF
텍스트색:      #333333
라벨:          위쪽에 축소된 상태 (animate up)
```

#### 비활성화 상태 (Disabled)
```
배경색:        #EFEFEF (밝은 회색)
테두리:        1px solid #E0E0E0
텍스트색:      #CCCCCC
플레이스홀더:  #999999 (더 밝게)
커서:          not-allowed
```

#### 에러 상태 (Error)
```
테두리:        2px solid #FF6B35 (빨간색)
배경색:        #FFEBEE (매우 밝은 빨강)
텍스트색:      #333333
아이콘:        우측 12px, 경고 마크
에러 메시지:   필드 아래 12px, Red (#FF6B35)
지속시간:      300ms ease-out (나타남)
```

#### 성공 상태 (Success)
```
테두리:        2px solid #00B050 (초록색)
배경색:        #F1F8F4 (매우 밝은 초록)
체크마크:      우측, 초록색
```

### 2.2 라벨 애니메이션

#### Floating Label Pattern (당근마켓 미사용, 토스/미소 유사)
```
기본 상태:     라벨이 필드 위에 표시 (12px)
포커스 상태:   라벨 크기 축소, 색상 변경
지속시간:      200ms cubic-bezier(0.4, 0, 0.2, 1)
```

#### Fixed Label Pattern (한국 앱 대부분)
```
라벨 위치:     항상 필드 상단에 고정
라벨 크기:     12-14px, Semi-bold
라벨 색상:     기본 #333, 포커스 시 #0050E8
```

### 2.3 카운터/길이 표시

```
위치:          필드 우측 하단
포맷:          "현재 / 최대" (예: 5 / 100)
색상:          #999999 (회색)
크기:          12px
```

---

## 3. 선택 컴포넌트 (Selection Components)

### 3.1 체크박스

#### 기본 상태 (Unchecked)
```
크기:          20x20px (또는 24x24px)
테두리:        2px solid #E0E0E0
배경색:        #FFFFFF
```

#### 호버 상태
```
테두리:        2px solid #CCCCCC
배경색:        #FFFFFF
```

#### 선택됨 (Checked)
```
배경색:        #0050E8 (파란색)
테두리:        2px solid #0050E8
체크마크:      White, 14px
```

#### 포커스 상태
```
테두리:        2px solid #0050E8
아웃라인 링:   2px rgba(0, 80, 232, 0.2)
```

#### 비활성화
```
배경색:        #EFEFEF
테두리:        2px solid #CCCCCC
체크마크:      #999999 (회색)
커서:          not-allowed
```

#### 부분선택 (Indeterminate)
```
배경색:        #0050E8
기호:          대시 (—) 대신 체크마크
```

### 3.2 라디오 버튼

#### 기본 상태
```
크기:          20x20px (외부 원)
테두리:        2px solid #E0E0E0
배경색:        #FFFFFF
내부 원:       없음
```

#### 선택됨 (Selected)
```
외부 테두리:   2px solid #0050E8
내부 원:       8px 지름, #0050E8
애니메이션:    scale 0.6 → 1.0, 200ms
```

#### 호버 상태
```
외부 테두리:   2px solid #CCCCCC
배경색:        #FFFFFF
```

### 3.3 토글 스위치

#### 기본 상태 (Off)
```
너비:          48px
높이:          24px
배경색:        #E0E0E0
Border-radius: 12px
노브:          좌측, White 8x8px, 3px margin
```

#### 활성 상태 (On)
```
배경색:        #0050E8 (파란색)
노브:          우측 이동
애니메이션:    200ms ease-out
```

#### 애니메이션
```
노브 이동:     8px * 2 = 16px 거리
지속시간:      200ms
곡선:          ease-out
```

---

## 4. 탭/세그먼트 상호작용 (Tab/Segmented Control)

### 4.1 탭 네비게이션

#### 기본 상태 (Inactive)
```
배경색:        #FFFFFF 또는 transparent
텍스트색:      #999999 (회색)
텍스트 크기:   14px, Regular (400)
패딩:          12px 16px
밑줄:          없음
```

#### 활성 상태 (Active)
```
배경색:        transparent (변경 안 함)
텍스트색:      #0050E8 (파란색)
텍스트 크기:   14px, Semi-bold (600)
밑줄:          2px solid #0050E8
밑줄 애니메이션: width 0 → 100%, 200ms ease-out
```

#### 호버 상태 (Hover on Inactive)
```
텍스트색:      #333333 (더 어둡게)
배경색:        transparent
```

### 4.2 세그먼트 컨트롤

#### 기본 상태
```
배경색:        #F5F5F5 (회색 배경)
테두리:        1px solid #E0E0E0
패딩:          8px (내부)
Border-radius: 8px
높이:          40px
```

#### 세그먼트 (각 탭)
```
너비:          동일하게 배분
배경색:        transparent (상위에서 상속)
텍스트색:      #666666
패딩:          8px 12px
Border-radius: 6px
```

#### 선택됨 (Selected Segment)
```
배경색:        #FFFFFF (흰색)
텍스트색:      #0050E8 (파란색)
텍스트 굵기:   Semi-bold (600)
그림자:        0 1px 4px rgba(0, 0, 0, 0.08)
애니메이션:    300ms ease-out (배경 변경)
```

---

## 5. 드롭다운/셀렉트 (Dropdown/Select)

### 5.1 닫혀있는 상태 (Closed)

```
높이:          48px (입력 필드와 동일)
패딩:          12px 16px
배경색:        #FFFFFF
테두리:        1px solid #E0E0E0
테스트색:      #333333 (선택됨) 또는 #999999 (플레이스홀더)
아이콘:        우측 12px, chevron-down (회색)
Border-radius: 8px
```

### 5.2 열린 상태 (Opened)

```
테두리:        2px solid #0050E8
그림자:        0 4px 12px rgba(0, 0, 0, 0.15)
아이콘:        chevron-up (위 방향)
드롭다운 메뉴: 아래쪽 나타남
지속시간:      200ms ease-out
```

### 5.3 드롭다운 메뉴 항목

#### 기본 상태
```
높이:          44-48px
패딩:          12px 16px
배경색:        #FFFFFF
텍스트색:      #333333
```

#### 호버 상태
```
배경색:        #F5F5F5 (밝은 회색)
텍스트색:      #333333 (변경 없음)
```

#### 선택됨 (Selected)
```
배경색:        #F0F5FF (매우 밝은 파란색)
텍스트색:      #0050E8 (파란색)
아이콘:        체크마크 (우측, 파란색)
텍스트 굵기:   Semi-bold (600)
```

#### 비활성화
```
배경색:        #FFFFFF
텍스트색:      #CCCCCC (밝은 회색)
커서:          not-allowed
```

---

## 6. 카드 상호작용 (Card Interactions)

### 6.1 기본 카드

#### 기본 상태
```
배경색:        #FFFFFF
테두리:        1px solid #E0E0E0 (선택)
Border-radius: 12px
패딩:          16px
그림자:        0 2px 8px rgba(0, 0, 0, 0.08)
gap:           12px (내부 요소)
```

#### 호버 상태 (클릭 가능한 경우)
```
배경색:        #FFFFFF (유지)
테두리:        1px solid #E0E0E0 (약간 어둡게 선택)
그림자:        0 4px 12px rgba(0, 0, 0, 0.12) (증가)
변환:          translateY(-2px) 또는 scale(1.01)
지속시간:      200ms ease-out
커서:          pointer
```

#### 프레스 상태
```
그림자:        0 2px 4px rgba(0, 0, 0, 0.08) (감소)
변환:          translateY(0) (원래 위치)
```

### 6.2 이미지 오버레이 카드

#### 이미지 필터
```
기본 상태:     opacity 100%
호버 상태:     opacity 92% (다크 오버레이 8%)
오버레이:      rgba(0, 0, 0, 0.08) 추가
```

#### 텍스트 가독성
```
배경 그라데이션: transparent → rgba(0, 0, 0, 0.3)
방향:          하단으로 진해짐
텍스트:        White, 위치 하단
```

---

## 7. 모달 상호작용 (Modal Interactions)

### 7.1 열리는 애니메이션 (Open Animation)

```
배경 오버레이:
  - 색상: rgba(0, 0, 0, 0.4)
  - opacity: 0 → 1, 300ms ease-out
  - 배경흐림: 없음 또는 2px blur

모달 본체:
  - opacity: 0 → 1, 300ms ease-out
  - transform: scale(0.95) → 1
  - 시작점: 중앙
  - 곡선: cubic-bezier(0, 0, 0.2, 1)
```

### 7.2 닫히는 애니메이션 (Close Animation)

```
배경 오버레이:
  - opacity: 1 → 0, 150ms ease-in

모달:
  - opacity: 1 → 0, 150ms ease-in
  - transform: scale(1) → 0.95
  - 더 빠르게 (150ms vs 300ms)
```

### 7.3 키보드 상호작용

```
ESC 키: 모달 닫기 (exit 애니메이션 재생)
Tab:    모달 내 요소만 포커스 (focus trap)
Enter:  CTA 버튼 활성화
```

---

## 8. 바텀 시트 상호작용 (Bottom Sheet)

### 8.1 열리는 애니메이션

```
배경 오버레이:
  - opacity: 0 → 1, 250ms ease-out

바텀 시트:
  - transform: translateY(100%) → 0
  - 지속시간: 250ms ease-out
  - 곡선: cubic-bezier(0, 0, 0.2, 1)
  - 시작 위치: 화면 하단 아래
```

### 8.2 드래그 제스처

```
드래그 핸들:
  - 높이: 4-5px
  - 너비: 40-50px
  - 색상: #E0E0E0
  - 위치: 상단 중앙

드래그 우향 닫기:
  - 임계값: 30-50px
  - 속도: 빠르면 자동 닫기
  - 애니메이션: 200ms
```

### 8.3 닫히는 애니메이션

```
배경:        opacity 1 → 0, 200ms
바텀시트:    translateY(0) → 100%, 200ms ease-in
더 빠르게 반응 (250ms → 200ms)
```

---

## 9. 로딩 상태 (Loading States)

### 9.1 Spinner (로딩 표시기)

#### 기본 스피너
```
크기:          32px (기본), 48px (풀스크린)
선 너비:       3-4px
색상:          #0050E8 (파란색)
회전:          360도, 1초 주기
곡선:          linear (일정한 속도)
애니메이션:    infinite
```

#### 스타일 변형
```
토스 스피너:  더 얇은 원 (2px), 부드러운 호
미소 스피너:  두꺼운 원 (4px), 빠른 회전 (0.8초)
```

### 9.2 Skeleton Loading (스켈레톤)

#### 기본 구조
```
배경:          #E0E0E0 (회색)
높이:          예상 컨텐츠 높이와 동일
너비:          예상 컨텐츠 너비와 동일
Border-radius: 실제 요소와 동일
```

#### Shimmer Animation (반짝임 효과)
```
배경:          #E0E0E0 → #F0F0F0 → #E0E0E0
방향:          좌상향 → 우하향 (45도)
속도:          2초 주기
곡선:          ease-in-out
배경 크기:     200% 200%
```

#### 배치 패턴
```
리스트 아이템:
  - 아바타: 32px 원형
  - 텍스트 라인 1: 16px × 70% 너비
  - 텍스트 라인 2: 12px × 50% 너비

카드:
  - 이미지: 300px 높이
  - 제목: 18px × 60% 너비
  - 설명: 14px × 80% 너비 (2줄)
```

---

## 10. 토스트/알림 (Toast Notifications)

### 10.1 성공 토스트

```
배경색:        #00B050 (초록색)
텍스트색:      #FFFFFF
아이콘:        ✓ (체크마크)
높이:          48px
패딩:          12px 16px
Border-radius: 8px
위치:          화면 하단, 16px 마진
지속시간:      3초
```

### 10.2 에러 토스트

```
배경색:        #FF6B35 (빨간색)
텍스트색:      #FFFFFF
아이콘:        ⚠ (경고 기호)
지속시간:      4초 (더 길게)
```

### 10.3 나타나는 애니메이션

```
진입:
  - opacity: 0 → 1
  - transform: translateY(20px) → 0
  - 지속시간: 300ms ease-out

지속:
  - 고정된 시간 (3-4초)
  - 마우스 호버 시 타이머 일시정지

사라짐:
  - opacity: 1 → 0
  - transform: translateY(0) → -20px
  - 지속시간: 200ms ease-out
```

### 10.4 제스처 (모바일)

```
스와이프 다운:  즉시 닫기
터치 & 호버:   타이머 일시정지
다중 토스트:   스택 형태, 각각 12px 간격
```

---

## 11. 폼 상호작용 (Form Interactions)

### 11.1 필드 검증 실시간 피드백

```
입력 중:       테두리 변경 없음
유효한 입력:   초록 테두리 + 체크마크 표시
무효한 입력:   빨간 테두리 + 에러 메시지
포커스 아웃:   검증 실행

에러 메시지:
  - 위치: 필드 바로 아래
  - 색상: #FF6B35 (빨간색)
  - 크기: 12px
  - 아이콘: ⚠ 선택
  - 애니메이션: 300ms fadeIn
```

### 11.2 폼 전체 제출 상태

#### 제출 전
```
CTA 버튼:      활성화, 파란 배경
에러 요약:     없음
```

#### 제출 중
```
CTA 버튼:      비활성화, 회색
로더:          버튼 내 스피너 표시
입력 필드:     읽기전용 (readonly)
```

#### 제출 후 성공
```
토스트:        "저장되었습니다" 메시지
페이지:        새 페이지로 리다이렉트 또는 상태 변경
지속시간:      300ms 후 네비게이션
```

#### 제출 후 실패
```
에러 토스트:   "저장 실패" + 재시도 버튼
입력 필드:     다시 활성화
에러 표시:     각 필드에 빨간 테두리 + 메시지
포커스:        첫 번째 에러 필드로 이동
```

---

## 12. 스크롤 상호작용 (Scroll Interactions)

### 12.1 Sticky Header (헤더 고정)

```
위치:          상단 고정
배경색:        #FFFFFF
테두리:        하단 1px solid #E0E0E0
그림자:        스크롤 시 추가 (0 2px 8px rgba(0, 0, 0, 0.08))
애니메이션:    그림자 fade-in, 200ms ease-out
```

### 12.2 Pull-to-Refresh (아래로 당겨 새로고침)

```
드래그 영역:   상단 60px
진행 표시:     회전하는 아이콘
임계값:        80px (새로고침 실행)
애니메이션:    bouncy spring effect
새로고침:      로더 표시, 데이터 로드
완료:          600ms 후 자동 스크롤 원위치
```

### 12.3 Infinite Scroll (무한 스크롤)

```
트리거 영역:   화면 하단 100-200px
로더:          스켈레톤 또는 스피너
로드 시간:     최소 300ms (너무 빨라 보이지 않도록)
중복 로드 방지: 플래그 사용
```

---

## 13. Gesture Interactions (제스처)

### 13.1 탭 (Tap)

```
인식 시간:     ~150ms
피드백:        ripple 또는 배경 색상 변경
인식 영역:     최소 44x44px
취소 조건:     손가락을 벗어나거나 너무 오래 누름
```

### 13.2 더블 탭 (Double Tap)

```
인식 시간:     300ms 내에 2번
사용:          좋아요/싫어요 토글
피드백:        애니메이션 (하트 터짐 등)
```

### 13.3 길게 누르기 (Long Press)

```
인식 시간:     500ms
피드백:        haptic vibration (진동)
메뉴:          context menu 표시
취소:          손가락 움직이면 취소
```

### 13.4 스와이프 (Swipe)

```
최소 거리:     60px
속도:          150+ px/s
방향:          상/하/좌/우 명확히
예시:
  - 우측 스와이프: 뒤로가기
  - 좌측 스와이프: 삭제 또는 진행
  - 아래로 스와이프: 새로고침
```

### 13.5 핀치 (Pinch)

```
사용:          줌 인/아웃
시작:          2손가락
거리:          변경량 기반
감속도:        momentum scrolling 효과
```

---

## 14. 접근성 상호작용 (Accessibility)

### 14.1 포커스 네비게이션

```
포커스 표시:   2px solid 테두리 + 2px 간격
색상:          #0050E8 또는 Yellow (#FFD700)
명도 대비:     4.5:1 이상
깜빡임:        없음 (계속 표시)
순서:          좌상향 → 우하향 (row-major)
```

### 14.2 키보드 단축키

```
Enter/Space:   버튼 활성화, 체크박스 토글
Escape:        모달/드로어 닫기
Tab:           다음 요소로 포커스 이동
Shift + Tab:   이전 요소로 포커스 이동
Arrow keys:    라디오/탭 네비게이션
Home/End:      리스트 첫/마지막 항목
```

### 14.3 스크린 리더 지원

```
aria-label:     아이콘 버튼에 라벨
aria-live:      토스트 및 동적 콘텐츠
role:          semantic HTML 대신 필요시
aria-disabled:  비활성화 상태 표시
```

---

## 15. 에러 복구 (Error Recovery)

### 15.1 네트워크 에러

```
토스트:        "인터넷 연결을 확인하세요"
버튼:          "재시도" 버튼 표시
상태:          로더 닫기, 입력 필드 다시 활성화
자동 재시도:   WiFi 연결 감지 시 자동 재시도
```

### 15.2 Timeout 에러

```
메시지:        "요청 시간 초과. 다시 시도하시겠어요?"
대기 시간:     보통 30초
재시도 버튼:   명확한 위치에 배치
상태 표시:     "일부 데이터가 오래되었을 수 있습니다"
```

### 15.3 권한 거부 에러

```
메시지:        "카메라 권한이 필요합니다"
액션:          "설정 열기" 버튼
설명:          왜 필요한지 명확히 설명
```

---

## 구현 예제 코드

### 16.1 Button Interaction (Stimulus)

```javascript
// app/javascript/controllers/button_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text", "spinner"]

  connect() {
    this.loading = false
  }

  async submit(e) {
    if (this.loading) return

    this.loading = true
    this.textTarget.classList.add("hidden")
    this.spinnerTarget.classList.remove("hidden")
    this.element.disabled = true

    try {
      // API 요청
      const response = await fetch("/api/action", {
        method: "POST",
        body: JSON.stringify(this.data),
      })

      if (!response.ok) throw new Error("Request failed")

      // 성공 토스트
      this.showToast("완료되었습니다", "success")
    } catch (error) {
      this.showToast("오류가 발생했습니다", "error")
    } finally {
      this.loading = false
      this.textTarget.classList.remove("hidden")
      this.spinnerTarget.classList.add("hidden")
      this.element.disabled = false
    }
  }

  showToast(message, type) {
    const toast = document.createElement("div")
    toast.className = `toast toast-${type} animate-slideUp`
    toast.textContent = message
    document.body.appendChild(toast)

    setTimeout(() => toast.remove(), 3000)
  }
}
```

### 16.2 Input Validation (Stimulus)

```javascript
// app/javascript/controllers/input_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error", "success"]

  validate(e) {
    const value = e.target.value.trim()
    const isValid = value.length >= 3

    if (isValid) {
      this.inputTarget.classList.remove("border-red-600")
      this.inputTarget.classList.add("border-green-600")
      this.errorTarget.classList.add("hidden")
      this.successTarget.classList.remove("hidden")
    } else {
      this.inputTarget.classList.remove("border-green-600")
      this.inputTarget.classList.add("border-red-600")
      this.successTarget.classList.add("hidden")
      this.errorTarget.classList.remove("hidden")
      this.errorTarget.textContent = "3자 이상 입력하세요"
    }
  }
}
```

### 16.3 Modal Animation (CSS)

```css
/* 모달 열기 애니메이션 */
@keyframes modalEnter {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes overlayEnter {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.modal {
  animation: modalEnter 0.3s cubic-bezier(0, 0, 0.2, 1);
}

.modal-overlay {
  animation: overlayEnter 0.3s ease-out;
}
```

---

## 요약: 프리미엄 상호작용의 핵심

1. **즉시 피드백**: 모든 상호작용은 200ms 내 시각적 피드백
2. **자연스러운 애니메이션**: ease-out으로 부드럽게 시작해서 빠르게 끝남
3. **명확한 상태**: 4가지 상태(기본, 호버, 포커스, 비활성) 모두 구현
4. **접근성 우선**: 포커스 표시, 키보드 지원, 스크린 리더 호환
5. **에러 우아함**: 실패해도 사용자가 복구할 수 있는 명확한 경로
6. **제스처 반응**: 모바일에서 스와이프, 핀치 등 자연스러운 반응
7. **일관성**: 모든 상호작용이 일관된 패턴 따르기

