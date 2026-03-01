import { Controller } from "@hotwired/stimulus"

// 삼쩜삼/토스 스타일 멀티 스텝 폼 컨트롤러
export default class extends Controller {
  static targets = ["step", "progress", "progressBar", "prevBtn", "nextBtn", "submitBtn"]
  static values = {
    currentStep: { type: Number, default: 1 },
    totalSteps: { type: Number, default: 4 }
  }

  connect() {
    this.showStep(this.currentStepValue)
    this.updateProgress()
  }

  next(event) {
    event.preventDefault()

    // 현재 단계 유효성 검사
    if (!this.validateCurrentStep()) {
      return
    }

    // 자동 저장
    this.autoSave()

    if (this.currentStepValue < this.totalStepsValue) {
      this.currentStepValue++
      this.showStep(this.currentStepValue)
      this.updateProgress()
      this.scrollToTop()
    }
  }

  prev(event) {
    event.preventDefault()

    if (this.currentStepValue > 1) {
      this.currentStepValue--
      this.showStep(this.currentStepValue)
      this.updateProgress()
      this.scrollToTop()
    }
  }

  goToStep(event) {
    const step = parseInt(event.currentTarget.dataset.step)
    if (step <= this.currentStepValue) {
      this.currentStepValue = step
      this.showStep(this.currentStepValue)
      this.updateProgress()
      this.scrollToTop()
    }
  }

  showStep(stepNumber) {
    this.stepTargets.forEach((step, index) => {
      if (index + 1 === stepNumber) {
        step.classList.remove("hidden")
        step.classList.add("fade-in")
      } else {
        step.classList.add("hidden")
        step.classList.remove("fade-in")
      }
    })

    // 버튼 표시/숨김
    if (this.hasPrevBtnTarget) {
      this.prevBtnTarget.classList.toggle("hidden", stepNumber === 1)
    }

    if (this.hasNextBtnTarget && this.hasSubmitBtnTarget) {
      const isLastStep = stepNumber === this.totalStepsValue
      this.nextBtnTarget.classList.toggle("hidden", isLastStep)
      this.submitBtnTarget.classList.toggle("hidden", !isLastStep)
    }
  }

  updateProgress() {
    const percentage = (this.currentStepValue / this.totalStepsValue) * 100

    // 프로그레스 바 업데이트
    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width = `${percentage}%`
    }

    // 프로그레스 텍스트 업데이트
    if (this.hasProgressTarget) {
      this.progressTarget.textContent = `${this.currentStepValue}/${this.totalStepsValue}`
    }

    // 단계별 인디케이터 업데이트
    document.querySelectorAll('[data-step-indicator]').forEach((indicator, index) => {
      const stepNum = index + 1
      const circle = indicator.querySelector('.step-circle')
      const label = indicator.querySelector('.step-label')

      if (stepNum < this.currentStepValue) {
        // 완료된 단계
        circle.classList.remove('bg-gray-300', 'bg-blue-600', 'text-gray-600', 'text-white')
        circle.classList.add('bg-green-500', 'text-white')
        circle.innerHTML = '<svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/></svg>'
        label.classList.remove('text-gray-600', 'text-blue-600')
        label.classList.add('text-green-600')
      } else if (stepNum === this.currentStepValue) {
        // 현재 단계
        circle.classList.remove('bg-gray-300', 'bg-green-500', 'text-gray-600')
        circle.classList.add('bg-blue-600', 'text-white')
        circle.textContent = stepNum
        label.classList.remove('text-gray-600', 'text-green-600')
        label.classList.add('text-blue-600', 'font-semibold')
      } else {
        // 미완료 단계
        circle.classList.remove('bg-blue-600', 'bg-green-500', 'text-white')
        circle.classList.add('bg-gray-300', 'text-gray-600')
        circle.textContent = stepNum
        label.classList.remove('text-blue-600', 'text-green-600', 'font-semibold')
        label.classList.add('text-gray-600')
      }
    })
  }

  validateCurrentStep() {
    const currentStepElement = this.stepTargets[this.currentStepValue - 1]
    const requiredInputs = currentStepElement.querySelectorAll('[required]')

    let isValid = true
    requiredInputs.forEach(input => {
      if (!input.value.trim()) {
        isValid = false
        input.classList.add('border-red-500')

        // 에러 메시지 표시
        let errorMsg = input.parentElement.querySelector('.error-message')
        if (!errorMsg) {
          errorMsg = document.createElement('p')
          errorMsg.className = 'error-message text-xs text-red-600 mt-1'
          errorMsg.textContent = '이 항목은 필수예요'
          input.parentElement.appendChild(errorMsg)
        }
      } else {
        input.classList.remove('border-red-500')
        const errorMsg = input.parentElement.querySelector('.error-message')
        if (errorMsg) {
          errorMsg.remove()
        }
      }
    })

    if (!isValid) {
      // 부드러운 shake 애니메이션
      currentStepElement.classList.add('shake')
      setTimeout(() => {
        currentStepElement.classList.remove('shake')
      }, 500)
    }

    return isValid
  }

  autoSave() {
    // 자동 저장 표시
    const saveIndicator = document.getElementById('autoSaveIndicator')
    if (saveIndicator) {
      saveIndicator.textContent = '💾 자동 저장 중...'
      saveIndicator.classList.remove('text-green-600', 'text-gray-500')
      saveIndicator.classList.add('text-blue-600')

      // 1초 후 저장 완료 표시
      setTimeout(() => {
        saveIndicator.textContent = '✅ 저장됨'
        saveIndicator.classList.remove('text-blue-600')
        saveIndicator.classList.add('text-green-600')

        setTimeout(() => {
          saveIndicator.textContent = '자동 저장됨'
          saveIndicator.classList.remove('text-green-600')
          saveIndicator.classList.add('text-gray-500')
        }, 2000)
      }, 1000)
    }

    // 실제 AJAX 저장은 여기서 구현 (선택적)
    // this.saveDraft()
  }

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }

  // 실시간 입력 유효성 검사
  validateInput(event) {
    const input = event.target
    if (input.required && input.value.trim()) {
      input.classList.remove('border-red-500')
      const errorMsg = input.parentElement.querySelector('.error-message')
      if (errorMsg) {
        errorMsg.remove()
      }
    }
  }
}
