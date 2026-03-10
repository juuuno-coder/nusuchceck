# 누수체크 디자인 시스템 업그레이드 - 분석 산출물 색인

## 개요

한국의 프리미엄 앱 3개 (당근마켓, 토스, 미소)의 1,877개 스크린샷을 분석하여 누수체크 디자인 시스템 업그레이드를 위한 명확한 가이드와 토큰을 제시합니다.

---

## 핵심 발견사항 (30초 요약)

| 항목 | 발견사항 |
|------|--------|
| **Primary 색상** | Blue #0050E8 (신뢰감, 전문성) |
| **간격 시스템** | 8px 기본 그리드 (4, 8, 12, 16, 24, 32, 48px) |
| **애니메이션** | 200-300ms ease-out (모든 전환) |
| **버튼 높이** | 48px (터치 최적화) |
| **카드 패딩** | 16px (내부), 12px (외부 마진) |
| **타이포그래피** | 24px 제목, 16px 소제목, 14px 본문, 12px 캡션 |
| **포커스 상태** | 2px 파란 테두리 + 3px 링 shadow |
| **에러 색상** | Red #FF6B35 또는 #D32F2F |
| **성공 색상** | Green #00B050 |
| **그림자 시스템** | 4단계 elevation (0, 1, 2, 3) |

---

## 분석 문서 가이드

### 1. REFERENCE_ANALYSIS.md (27KB, 22개 섹션)

**목적**: 한국 프리미엄 앱의 전체 디자인 원칙 분석

**주요 내용**:
- 1. 색상 시스템 (Primary, Status, Background)
- 2. 타이포그래피 & 텍스트 스타일 (4단계 계층)
- 3. 간격 & 레이아웃 (8px 그리드, 패딩, 마진)
- 4. 호버 & 상호작용 상태 (버튼, 카드, 입력)
- 5. 마이크로 애니메이션 (지속시간, 곡선, 키프레임)
- 6. 빈 상태 & 에러 처리 (UI 패턴)
- 7. 로딩 패턴 (스켈레톤, 스피너, shimmer)
- 8. 다크모드 고려사항
- 9. 접근성 기준 (WCAG AA, 명도대비)
- 10. 모달 & 바텀시트 (구조, 애니메이션)
- 11. 폼 & 입력 필드 (모든 상태, 검증)
- 12. 토스트 알림 (타입별, 애니메이션)
- 13. 배지 & 라벨
- 14. 네비게이션 (헤더, 탭, 드로어)
- 15. 프리미엄 디테일 (그림자, 그라데이션, blur)
- 16. 이미지 최적화
- 17. 반응형 설계 (breakpoints)
- 18-20. 원칙, 토큰 맵핑, 코드 예제
- 21. 누수체크 적용 전략
- 22. 체크리스트

**사용자**:
- 디자이너: 색상, 타이포그래피, 컴포넌트 레퍼런스
- 개발자: 구체적 수치값, 애니메이션 지속시간
- PM: 전체 전략, 우선순위

**검색 팁**:
- Ctrl+F "당근마켓" → 마켓플레이스 UI 패턴
- Ctrl+F "토스" → 금융 서비스 UI 패턴
- Ctrl+F "Priority 1" → 즉시 적용 항목

---

### 2. DESIGN_TOKENS.md (14KB, 구체적 수치값)

**목적**: 모든 설계 결정을 수치화된 토큰으로 제공

**주요 섹션**:

#### 색상 토큰
```
blue-600:      #0050E8 (Primary)
blue-700:      #0040B8 (Hover)
blue-800:      #002E88 (Press)
green-600:     #00B050 (Success)
red-600:       #FF6B35 (Error)
gray-900:      #333333 (Text)
... 등 25개 이상의 색상
```

#### 간격 토큰
```
1:  4px
2:  8px
3:  12px
4:  16px (가장 자주)
6:  24px
8:  32px
12: 48px
```

#### 타이포그래피 토큰
```
heading-xl:    24px Bold
heading-lg:    20px Bold
body-md:       14px Regular
caption-md:    12px Regular
```

#### 애니메이션 토큰
```
duration-200:  200ms (기본)
duration-300:  300ms (모달)
ease-out:      cubic-bezier(0, 0, 0.2, 1)
```

#### 그림자 토큰
```
shadow-1:      0 2px 8px rgba(0,0,0,0.08)
shadow-2:      0 4px 12px rgba(0,0,0,0.12)
shadow-3:      0 8px 24px rgba(0,0,0,0.15)
```

**사용 방법**:
1. CSS 변수로 복사
2. Tailwind config.js에 추가
3. 모든 색상값을 이 토큰으로 대체

**예제 포함**:
- Tailwind config.js 구성
- CSS 변수 정의
- 컴포넌트별 토큰 맵핑

---

### 3. INTERACTION_PATTERNS.md (21KB, 15개 상호작용 패턴)

**목적**: 각 UI 요소의 모든 상태와 애니메이션 정의

**주요 패턴**:

1. **버튼 상호작용**
   - Default, Hover, Pressed, Disabled, Loading
   - Primary, Secondary, Text-only 버튼

2. **입력 필드**
   - Default, Focused, With Value, Disabled, Error, Success
   - Floating Label vs Fixed Label
   - 에러 메시지 위치, 유효성 검사

3. **선택 컴포넌트**
   - 체크박스, 라디오, 토글 스위치
   - Indeterminate 상태

4. **탭 & 세그먼트**
   - Active vs Inactive
   - Hover 상태
   - 밑줄 애니메이션

5. **드롭다운**
   - 열림/닫힘 상태
   - 메뉴 항목 호버, 선택
   - 비활성화 항목

6. **카드**
   - 기본 카드, 이미지 오버레이
   - 호버 시 shadow 증가, transform 변화

7. **모달**
   - 열기/닫기 애니메이션 (300ms)
   - 배경 오버레이
   - ESC 키 동작

8. **바텀 시트**
   - 드래그 진입 (250ms)
   - 드래그 제스처로 닫기
   - 빠른 퇴출 (200ms)

9. **로딩 상태**
   - Spinner (360도, 1초)
   - Skeleton (shimmer 2초)
   - 배치 패턴 (아바타, 텍스트, 이미지)

10. **토스트**
    - Success (3초), Error (4초)
    - SlideUp 300ms 진입
    - Swipe 제스처로 닫기

11. **폼 검증**
    - 실시간 피드백
    - 에러 표시 (빨간 테두리 + 메시지)
    - 성공 표시 (초록 테두리 + 체크마크)

12. **스크롤**
    - Sticky header (그림자 fade-in)
    - Pull-to-refresh
    - Infinite scroll

13. **제스처**
    - Tap (150ms, 44x44px)
    - Double tap (300ms)
    - Long press (500ms)
    - Swipe (60px, 150px/s)

14. **접근성**
    - 포커스 네비게이션 (2px 테두리)
    - 키보드 단축키 (Enter, Tab, ESC)
    - 스크린 리더 (aria-*)

15. **에러 복구**
    - 네트워크 에러 → 재시도 버튼
    - Timeout → 다시 시도
    - 권한 거부 → 설정 열기

**코드 예제**:
- Stimulus controller 예제 (로딩, 검증)
- CSS 애니메이션 예제
- HTML 마크업 예제

---

### 4. ANALYSIS_SUMMARY.md (7.5KB, 높은 수준의 요약)

**목적**: 분석 결과를 경영진, PM, 의사결정자 대상으로 요약

**포함 내용**:
- 분석 대상 (1,877개 스크린샷)
- 주요 발견사항 7가지
- 한국 사용자 기대치
- 피해야 할 패턴 6가지
- Priority 1, 2, 3 별 즉시 적용 항목
- 4주 구현 계획
- 문서별 활용 가이드

**이 문서 읽는 시간**: 5분

---

## 사용자별 읽기 가이드

### 디자이너 (Design Lead)
**우선순위**:
1. ANALYSIS_SUMMARY.md (5분) - 전체 전략 파악
2. REFERENCE_ANALYSIS.md 색상 & 타이포 섹션 (30분)
3. DESIGN_TOKENS.md 색상 토큰 (15분)

**할일**:
- Figma 색상 라이브러리 생성
- 타이포그래피 스타일 정의
- 컴포넌트 스펙 작성

### 프론트엔드 개발자
**우선순위**:
1. DESIGN_TOKENS.md 전체 (30분)
2. REFERENCE_ANALYSIS.md 간격 & 레이아웃 (20분)
3. INTERACTION_PATTERNS.md 필요한 패턴만 (30분)

**할일**:
- Tailwind config.js 업데이트
- 색상 변수 정의
- 컴포넌트 마크업 작성

### UX 개발자 (Animation/Interaction)
**우선순위**:
1. INTERACTION_PATTERNS.md 전체 (60분)
2. DESIGN_TOKENS.md 애니메이션 섹션 (10분)
3. REFERENCE_ANALYSIS.md 마이크로 애니메이션 (20분)

**할일**:
- Stimulus 컨트롤러 작성
- CSS 애니메이션 정의
- 키프레임 구현

### Product Manager
**우선순위**:
1. ANALYSIS_SUMMARY.md 전체 (5분)
2. REFERENCE_ANALYSIS.md 누수체크 적용 전략 (15분)

**정보**:
- 한국 사용자 기대치 이해
- 3주 구현 로드맵
- 우선순위 결정 근거

### QA/테스터
**우선순위**:
1. ANALYSIS_SUMMARY.md (5분) - 기준 이해
2. REFERENCE_ANALYSIS.md 모든 상태 섹션 (45분)
3. INTERACTION_PATTERNS.md 전체 (60분)

**할일**:
- 모든 상태 확인 체크리스트 작성
- 명도 대비 검증 (WCAG AA)
- 터치 타겟 크기 검증 (44x44px)

---

## 빠른 참조 (Quick Reference)

### 색상 팔레트
```
Primary:    #0050E8 (Blue)
Success:    #00B050 (Green)
Warning:    #FFC107 (Yellow)
Error:      #FF6B35 (Red)
Text:       #333333 (Dark Gray)
SubText:    #999999 (Gray)
Border:     #E0E0E0 (Light Gray)
Background: #F5F5F5 (Very Light Gray)
White:      #FFFFFF
```

### 간격 표준값
```
4px  - 미세한 간격
8px  - 기본 단위
12px - 섹션 내 간격
16px - 기본 패딩
24px - 큼 간격
32px - 매우 큼 간격
48px - 섹션 사이
```

### 애니메이션 공식
```
Duration:  200ms ~ 300ms
Easing:    cubic-bezier(0, 0, 0.2, 1)  (ease-out)
Keyframe:  @keyframes [name] { from {} to {} }
Property:  opacity, transform, box-shadow
```

### 버튼 크기
```
높이:  48px
패딩:  16px 좌우, 12px 상하
아이콘: 24px
```

### 터치 타겟 (모바일)
```
최소 크기: 44x44px
권장 크기: 48x48px
간격:     8px 이상
```

---

## 구현 체크리스트

### Week 1 - 기초
- [ ] 색상 팔레트 Figma에 정의
- [ ] Tailwind config.js 색상 업데이트
- [ ] 타이포그래피 스타일 정의
- [ ] 기본 버튼 컴포넌트 (4가지 상태)

### Week 2 - 인터랙션
- [ ] CSS 애니메이션 라이브러리
- [ ] 카드 컴포넌트 (호버 효과)
- [ ] 입력 필드 (4가지 상태)
- [ ] 모달/바텀시트 애니메이션

### Week 3 - 고급
- [ ] 폼 검증 UI
- [ ] 스켈레톤 로딩
- [ ] 토스트 알림
- [ ] 접근성 검증

### Week 4 - 검증
- [ ] 사용자 테스트
- [ ] 피드백 수집
- [ ] DESIGN_SYSTEM.md 최종화
- [ ] 팀 교육

---

## 파일 위치

```
/nusucheck/
├── REFERENCE_ANALYSIS.md           (27KB) 전체 분석
├── DESIGN_TOKENS.md                (14KB) 수치화된 토큰
├── INTERACTION_PATTERNS.md         (21KB) 상호작용 패턴
├── ANALYSIS_SUMMARY.md             (7.5KB) 요약
└── DESIGN_SYSTEM_UPGRADE_INDEX.md  (이 파일)
```

---

## FAQ

### Q: 어떤 문서부터 읽어야 하나?
**A**: 역할별로 다릅니다.
- 모두: ANALYSIS_SUMMARY.md (5분)
- 그 다음: 역할별 "사용자별 읽기 가이드" 참조

### Q: 색상값을 어디서 찾나?
**A**: DESIGN_TOKENS.md의 "색상 토큰" 섹션 또는 REFERENCE_ANALYSIS.md의 "1. 색상 시스템"

### Q: 애니메이션 지속시간은?
**A**: 모두 200-300ms
- 버튼 호버: 250ms
- 모달 진입: 300ms
- 일반 전환: 200ms

### Q: 버튼 높이는?
**A**: 48px (모바일 터치 최적화)

### Q: 에러 메시지 색상은?
**A**: Red #FF6B35 (선호) 또는 #D32F2F

### Q: 텍스트 색상은?
**A**: 주요 텍스트 #333333, 보조 #999999, 라벨 #666666

### Q: WCAG 기준을 어떻게 만족하나?
**A**: REFERENCE_ANALYSIS.md의 "9. 접근성" 섹션 참조
- 명도 대비 4.5:1 이상
- 터치 타겟 44x44px
- 포커스 표시 2px 테두리

---

## 추가 리소스

### 참고 자료
- Tailwind CSS 공식 문서: https://tailwindcss.com/
- WCAG 2.1 가이드: https://www.w3.org/WAI/WCAG21/quickref/
- Material Design 3: https://m3.material.io/

### 관련 문서
- CLAUDE.md: 프로젝트 개발 가이드
- DESIGN_SYSTEM.md: 기존 디자인 시스템
- OKR.md: 분기 목표

---

## 버전 관리

| 버전 | 날짜 | 변경사항 |
|------|------|---------|
| 1.0 | 2026-03-10 | 초기 분석 완료 |
| | | 4개 핵심 문서 작성 |
| | | 1,877개 스크린샷 분석 |

---

## 문의 및 피드백

분석 결과에 대한 질문이나 피드백이 있으면:
1. 해당 문서의 관련 섹션 확인
2. Slack #design-system 채널에서 질문
3. 주간 디자인 리뷰에서 논의

---

**최종 업데이트**: 2026-03-10
**상태**: 분석 완료, 구현 준비 완료
**다음 단계**: Week 1 색상 팔레트 정의 시작

