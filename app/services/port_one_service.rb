# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

# 포트원(PortOne) 결제 서비스
# 토스페이먼츠를 포함한 여러 PG사를 통합 관리
class PortOneService
  class PaymentError < StandardError; end

  BASE_URL = "https://api.portone.io"

  def initialize
    @api_key = ENV.fetch("PORTONE_API_KEY", "")
    @api_secret = ENV.fetch("PORTONE_API_SECRET", "")
    @store_id = ENV.fetch("PORTONE_STORE_ID", "")

    if @api_key.blank? || @api_secret.blank?
      Rails.logger.warn "[PortOne] API 키가 설정되지 않음 - 테스트 모드"
    end
  end

  # 액세스 토큰 발급
  # @return [String] 액세스 토큰
  def get_access_token
    uri = URI("#{BASE_URL}/users/getToken")

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = {
      imp_key: @api_key,
      imp_secret: @api_secret
    }.to_json

    response = send_request(uri, request)

    unless response["code"] == 0
      raise PaymentError, "토큰 발급 실패: #{response['message']}"
    end

    response.dig("response", "access_token")
  end

  # 결제 단건 조회
  # @param imp_uid [String] 포트원 거래 고유번호
  # @return [Hash] 결제 정보
  def get_payment(imp_uid)
    access_token = get_access_token
    uri = URI("#{BASE_URL}/payments/#{imp_uid}")

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"

    response = send_request(uri, request)

    unless response["code"] == 0
      raise PaymentError, "결제 조회 실패: #{response['message']}"
    end

    response["response"]
  end

  # 결제 취소 (환불)
  # @param imp_uid [String] 포트원 거래 고유번호
  # @param amount [BigDecimal] 취소 금액 (nil이면 전액)
  # @param reason [String] 취소 사유
  # @return [Hash] 취소 결과
  def cancel_payment(imp_uid:, amount: nil, reason: "고객 요청")
    access_token = get_access_token
    uri = URI("#{BASE_URL}/payments/cancel")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    request["Content-Type"] = "application/json"

    body = {
      imp_uid: imp_uid,
      reason: reason
    }
    body[:amount] = amount.to_i if amount.present?

    request.body = body.to_json

    response = send_request(uri, request)

    unless response["code"] == 0
      raise PaymentError, "결제 취소 실패: #{response['message']}"
    end

    response["response"]
  end

  # 결제 정보 검증
  # 웹훅으로 받은 imp_uid와 merchant_uid를 검증
  # @param imp_uid [String] 포트원 거래 고유번호
  # @param merchant_uid [String] 가맹점 주문번호
  # @param amount [BigDecimal] 결제 금액
  # @return [Hash] 검증된 결제 정보
  def verify_payment(imp_uid:, merchant_uid:, amount:)
    payment = get_payment(imp_uid)

    # merchant_uid 검증
    unless payment["merchant_uid"] == merchant_uid
      raise PaymentError, "주문번호 불일치: expected=#{merchant_uid}, actual=#{payment['merchant_uid']}"
    end

    # 금액 검증
    paid_amount = payment["amount"].to_d
    unless paid_amount == amount.to_d
      raise PaymentError, "결제 금액 불일치: expected=#{amount}, actual=#{paid_amount}"
    end

    # 결제 상태 검증
    unless payment["status"] == "paid"
      raise PaymentError, "결제 상태 오류: #{payment['status']}"
    end

    payment
  end

  private

  # HTTP 요청 전송
  # @param uri [URI] 요청 URI
  # @param request [Net::HTTPRequest] HTTP 요청 객체
  # @return [Hash] 응답 데이터
  def send_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 10
    http.open_timeout = 5

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      raise PaymentError, "HTTP 요청 실패: #{response.code} #{response.message}"
    end

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    raise PaymentError, "JSON 파싱 실패: #{e.message}"
  rescue => e
    Rails.logger.error "[PortOne] API 요청 오류: #{e.class} - #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    raise PaymentError, "API 요청 중 오류 발생: #{e.message}"
  end
end
