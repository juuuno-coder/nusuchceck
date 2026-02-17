package com.nusucheck.app.features.notifications

import com.nusucheck.app.NusuCheckApplication
import dev.hotwire.navigation.fragments.HotwireWebFragment

/**
 * 알림 탭
 */
class NotificationsFragment : HotwireWebFragment() {

    override fun startLocation() =
        "${NusuCheckApplication.BASE_URL}/notifications"
}
