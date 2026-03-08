import { Controller } from "@hotwired/stimulus"

// 파일 업로드 진행률 표시 컨트롤러
// XHR을 사용하여 실시간 업로드 진행 상황을 추적하고 표시
export default class extends Controller {
  static targets = [
    "form",
    "progressModal",
    "progressBar",
    "progressText",
    "uploadedSize",
    "totalSize",
    "cancelButton",
    "errorMessage"
  ]

  static values = {
    uploadUrl: String,
    redirectUrl: String
  }

  connect() {
    this.xhr = null
    this.isUploading = false

    // 폼 제출 이벤트 인터셉트
    if (this.hasFormTarget) {
      this.formTarget.addEventListener("submit", this.handleSubmit.bind(this))
    }
  }

  disconnect() {
    // XHR 정리
    if (this.xhr) {
      this.xhr.abort()
    }
  }

  // 폼 제출 핸들러
  handleSubmit(event) {
    event.preventDefault()
    event.stopPropagation()

    // 이미 업로드 중이면 무시
    if (this.isUploading) {
      return false
    }

    // 파일이 선택되었는지 확인
    const fileInput = this.formTarget.querySelector('input[type="file"]')
    if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
      // 파일이 없으면 일반 폼 제출
      this.formTarget.removeEventListener("submit", this.handleSubmit.bind(this))
      this.formTarget.submit()
      return false
    }

    // XHR 업로드 시작
    this.startUpload()

    return false
  }

  // XHR 업로드 시작
  startUpload() {
    this.isUploading = true

    // FormData 생성
    const formData = new FormData(this.formTarget)

    // 총 파일 크기 계산
    let totalSize = 0
    const fileInputs = this.formTarget.querySelectorAll('input[type="file"]')
    fileInputs.forEach(input => {
      if (input.files) {
        Array.from(input.files).forEach(file => {
          totalSize += file.size
        })
      }
    })

    // 프로그레스 모달 표시
    this.showProgressModal(totalSize)

    // XHR 생성 및 설정
    this.xhr = new XMLHttpRequest()

    // 업로드 진행률 이벤트
    this.xhr.upload.addEventListener("progress", (e) => {
      if (e.lengthComputable) {
        const percentComplete = (e.loaded / e.total) * 100
        this.updateProgress(percentComplete, e.loaded, e.total)
      }
    })

    // 업로드 완료 이벤트
    this.xhr.addEventListener("load", () => {
      if (this.xhr.status >= 200 && this.xhr.status < 300) {
        this.handleSuccess()
      } else {
        this.handleError(`서버 오류 (${this.xhr.status})`)
      }
    })

    // 업로드 에러 이벤트
    this.xhr.addEventListener("error", () => {
      this.handleError("네트워크 오류가 발생했습니다")
    })

    // 업로드 취소 이벤트
    this.xhr.addEventListener("abort", () => {
      this.handleCancel()
    })

    // XHR 요청 전송
    const url = this.uploadUrlValue || this.formTarget.action
    this.xhr.open("POST", url, true)

    // CSRF 토큰 설정
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    if (csrfToken) {
      this.xhr.setRequestHeader("X-CSRF-Token", csrfToken)
    }

    // Turbo 비활성화 (직접 XHR 처리)
    this.xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest")

    // FormData 전송
    this.xhr.send(formData)

    // Analytics: 업로드 시작 이벤트
    this.dispatchAnalyticsEvent("upload_started", {
      total_size: totalSize,
      file_count: this.countFiles()
    })
  }

  // 프로그레스 모달 표시
  showProgressModal(totalSize) {
    if (this.hasProgressModalTarget) {
      this.progressModalTarget.classList.remove("hidden")
      this.progressModalTarget.classList.add("flex")
    }

    if (this.hasTotalSizeTarget) {
      this.totalSizeTarget.textContent = this.formatFileSize(totalSize)
    }

    if (this.hasUploadedSizeTarget) {
      this.uploadedSizeTarget.textContent = this.formatFileSize(0)
    }

    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width = "0%"
    }

    if (this.hasProgressTextTarget) {
      this.progressTextTarget.textContent = "0%"
    }

    // 에러 메시지 숨김
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.classList.add("hidden")
    }
  }

  // 진행률 업데이트
  updateProgress(percent, loaded, total) {
    const percentRounded = Math.round(percent)

    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width = `${percentRounded}%`
    }

    if (this.hasProgressTextTarget) {
      this.progressTextTarget.textContent = `${percentRounded}%`
    }

    if (this.hasUploadedSizeTarget) {
      this.uploadedSizeTarget.textContent = this.formatFileSize(loaded)
    }

    // Analytics: 진행률 50%, 75%, 90% 시점 추적
    if ([50, 75, 90].includes(percentRounded) && !this[`milestone_${percentRounded}`]) {
      this[`milestone_${percentRounded}`] = true
      this.dispatchAnalyticsEvent("upload_progress", {
        progress: percentRounded,
        uploaded_bytes: loaded,
        total_bytes: total
      })
    }
  }

  // 업로드 성공
  handleSuccess() {
    this.isUploading = false

    // 100% 표시
    this.updateProgress(100, 1, 1)

    // Analytics: 업로드 완료 이벤트
    this.dispatchAnalyticsEvent("upload_completed", {
      file_count: this.countFiles()
    })

    // 서버 응답 처리
    try {
      const response = JSON.parse(this.xhr.responseText)

      // 리다이렉트 URL이 있으면 이동
      if (response.redirect_url || this.redirectUrlValue) {
        setTimeout(() => {
          window.location.href = response.redirect_url || this.redirectUrlValue
        }, 500)
      } else {
        // 성공 메시지 표시 후 모달 닫기
        this.showSuccessMessage()
        setTimeout(() => {
          this.hideProgressModal()
          // 페이지 새로고침 또는 Turbo visit
          window.location.reload()
        }, 1500)
      }
    } catch (e) {
      // JSON 파싱 실패 시 HTML 응답으로 간주하고 리다이렉트
      if (this.xhr.responseURL && this.xhr.responseURL !== window.location.href) {
        window.location.href = this.xhr.responseURL
      } else {
        // 응답 URL이 없으면 그냥 새로고침
        window.location.reload()
      }
    }
  }

  // 업로드 에러
  handleError(message) {
    this.isUploading = false

    console.error("Upload error:", message)

    // 에러 메시지 표시
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.textContent = message || "업로드 중 오류가 발생했습니다"
      this.errorMessageTarget.classList.remove("hidden")
    }

    // 취소 버튼을 "닫기"로 변경
    if (this.hasCancelButtonTarget) {
      this.cancelButtonTarget.textContent = "닫기"
    }

    // Analytics: 업로드 에러 이벤트
    this.dispatchAnalyticsEvent("upload_failed", {
      error_message: message
    })

    // Sentry: 에러 추적
    this.element.dispatchEvent(new CustomEvent("sentry:error", {
      detail: {
        error: new Error(`Upload failed: ${message}`),
        context: {
          error_type: "upload_error",
          file_count: this.countFiles()
        }
      },
      bubbles: true
    }))
  }

  // 업로드 취소
  handleCancel() {
    this.isUploading = false

    console.log("Upload cancelled by user")

    // Analytics: 업로드 취소 이벤트
    this.dispatchAnalyticsEvent("upload_cancelled", {
      file_count: this.countFiles()
    })

    // 모달 닫기
    this.hideProgressModal()
  }

  // 성공 메시지 표시
  showSuccessMessage() {
    if (this.hasProgressTextTarget) {
      this.progressTextTarget.textContent = "✅ 업로드 완료!"
      this.progressTextTarget.classList.add("text-green-600")
    }
  }

  // 프로그레스 모달 숨김
  hideProgressModal() {
    if (this.hasProgressModalTarget) {
      this.progressModalTarget.classList.add("hidden")
      this.progressModalTarget.classList.remove("flex")
    }
  }

  // 업로드 취소 버튼 클릭
  cancel(event) {
    event.preventDefault()

    if (!this.isUploading) {
      // 업로드 중이 아니면 그냥 모달 닫기
      this.hideProgressModal()
      return
    }

    if (confirm("업로드를 취소하시겠습니까?")) {
      if (this.xhr) {
        this.xhr.abort()
      }
    }
  }

  // 파일 개수 카운트
  countFiles() {
    let count = 0
    const fileInputs = this.formTarget.querySelectorAll('input[type="file"]')
    fileInputs.forEach(input => {
      if (input.files) {
        count += input.files.length
      }
    })
    return count
  }

  // 파일 크기 포맷팅
  formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes'

    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))

    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i]
  }

  // Analytics 이벤트 발생
  dispatchAnalyticsEvent(eventName, params) {
    this.element.dispatchEvent(new CustomEvent("analytics:custom", {
      detail: {
        event_name: eventName,
        params: params
      },
      bubbles: true
    }))
  }
}
