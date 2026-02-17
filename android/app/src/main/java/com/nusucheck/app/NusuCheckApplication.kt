package com.nusucheck.app

import android.app.Application
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.turbo.config.PathConfiguration

class NusuCheckApplication : Application() {

    companion object {
        const val BASE_URL = "https://nusucheck.fly.dev"
        // 개발 시 로컬: "http://10.0.2.2:3000" (에뮬레이터) / "http://192.168.x.x:3000" (실기기)
    }

    override fun onCreate() {
        super.onCreate()
        configureHotwire()
    }

    private fun configureHotwire() {
        Hotwire.apply {
            // 경로 설정 - 서버에서 JSON을 내려받아 각 경로별 네비게이션 방식 결정
            loadPathConfiguration(
                context = this@NusuCheckApplication,
                location = PathConfiguration.Location(
                    assetFilePath = "json/configuration.json",     // 로컬 fallback
                    remoteFileUrl = "$BASE_URL/hotwire_native/configuration.json" // 서버에서 최신 설정
                )
            )

            // 사용자 에이전트 설정 (Rails에서 네이티브 앱 감지에 사용)
            userAgentSubstring = "NusuCheck/Android"
        }
    }
}
