# 누수체크 Android App (Hotwire Native)

Rails 서버의 HTML을 네이티브 앱으로 감싸는 Hotwire Native 기반 Android 앱입니다.

## 동작 원리

```
Android Native Shell
  └─ WebView (Hotwire/Turbo)
       └─ Rails HTML 렌더링
            └─ 기존 web 코드 100% 재사용
```

- 네이티브 앱에서 Rails 뷰를 WebView로 표시
- Rails 서버가 `User-Agent`에서 `NusuCheck/Android` 감지 → 네비게이션/푸터 숨김
- Path Configuration JSON으로 모달/푸시/탭 네비게이션 결정

## 개발 환경 설정

### 요구사항
- Android Studio Hedgehog 이상
- JDK 17
- Android SDK 34

### 시작하기

1. Android Studio에서 `android/` 폴더 열기
2. Gradle Sync 실행
3. 에뮬레이터 또는 실기기 연결 후 Run

### 로컬 개발 서버 연결

`NusuCheckApplication.kt`에서 BASE_URL 변경:

```kotlin
// 에뮬레이터 (localhost 대신 10.0.2.2 사용)
const val BASE_URL = "http://10.0.2.2:3000"

// 실기기 (PC의 실제 IP 주소)
const val BASE_URL = "http://192.168.1.xxx:3000"
```

### 프로덕션 서버
```kotlin
const val BASE_URL = "https://nusucheck.fly.dev"
```

## 프로젝트 구조

```
android/
  app/src/main/
    java/com/nusucheck/app/
      NusuCheckApplication.kt    # Hotwire 초기화
      MainActivity.kt            # 하단 탭 + NavHostFragment
      features/
        requests/
          RequestsFragment.kt    # 내 체크 탭 (홈)
        notifications/
          NotificationsFragment.kt # 알림 탭
    assets/json/
      configuration.json         # 로컬 path configuration (fallback)
    res/
      layout/activity_main.xml   # 메인 레이아웃
      menu/bottom_nav_menu.xml   # 하단 탭 메뉴
      navigation/nav_graph.xml   # Navigation Component 그래프
```

## 네비게이션 규칙 (Path Configuration)

서버에서 `/hotwire_native/configuration.json`을 내려받아 각 경로별 처리 방식 결정:

| 경로 | 방식 |
|------|------|
| `/customers/requests` | 기본 (하단 탭) |
| `/customers/requests/new` | 모달 |
| `/customers/requests/:id` | Push (스택 네비게이션) |
| `/users/sign_in` | 모달 |
| `/notifications` | 기본 (하단 탭) |

## iOS 앱

iOS 앱은 Mac에서 Xcode + Swift로 개발 가능합니다.
- 공식 Hotwire Native iOS: https://github.com/hotwired/hotwire-native-ios
- Rails 서버 코드는 Android와 동일하게 재사용
