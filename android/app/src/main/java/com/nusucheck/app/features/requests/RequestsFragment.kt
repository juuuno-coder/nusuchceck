package com.nusucheck.app.features.requests

import com.nusucheck.app.NusuCheckApplication
import dev.hotwire.navigation.fragments.HotwireWebFragment

/**
 * 고객 체크 목록 탭 (홈 화면)
 * 실제 UI는 Rails 서버에서 렌더링된 HTML을 WebView로 표시
 */
class RequestsFragment : HotwireWebFragment() {

    override fun startLocation() =
        "${NusuCheckApplication.BASE_URL}/customers/requests"
}
