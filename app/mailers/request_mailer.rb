class RequestMailer < ApplicationMailer
  # 체크 접수 완료 (고객에게)
  def request_received(request)
    @request  = request
    @customer = request.customer
    mail(
      to:      @customer.email,
      subject: "[누수체크] 체크 접수가 완료되었어요 (##{request.id})"
    )
  end

  # 전문가 배정 완료 (고객에게)
  def master_assigned(request)
    @request  = request
    @customer = request.customer
    @master   = request.master
    mail(
      to:      @customer.email,
      subject: "[누수체크] 전문가가 배정되었어요 - #{@master.name} 전문가"
    )
  end

  # 견적 제출 알림 (고객에게)
  def estimate_submitted(request)
    @request  = request
    @customer = request.customer
    @estimate = request.estimates.pending.last
    mail(
      to:      @customer.email,
      subject: "[누수체크] 견적이 도착했어요 (##{request.id}) - 확인해주세요!"
    )
  end

  # 공사 완료 (고객에게 - 확인 요청)
  def construction_completed(request)
    @request  = request
    @customer = request.customer
    mail(
      to:      @customer.email,
      subject: "[누수체크] 공사가 완료되었어요 - 완료 확인을 눌러주세요"
    )
  end

  # 오더 배정 알림 (마스터에게)
  def new_open_order(master, request)
    @request = request
    @master  = master
    mail(
      to:      @master.email,
      subject: "[누수체크] 새로운 오더가 등록되었어요! #{symptom_label(request.symptom_type)} - 선착순"
    )
  end

  private

  def symptom_label(type)
    { 'wall_leak' => '벽면 누수', 'ceiling_leak' => '천장 누수', 'floor_leak' => '바닥 누수',
      'pipe_leak' => '배관 누수', 'toilet_leak' => '화장실 누수', 'outdoor_leak' => '외부 누수' }[type] || type
  end
end
