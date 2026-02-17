require "net/http"
require "json"
require "base64"

class TossPaymentsService
  API_BASE_URL = "https://api.tosspayments.com/v1"

  class PaymentError < StandardError; end

  def initialize
    @secret_key = ENV.fetch("TOSS_SECRET_KEY") { raise PaymentError, "TOSS_SECRET_KEY 환경변수가 설정되지 않았습니다." }
  end

  # 결제 승인 (고객 결제 완료 후 서버에서 호출)
  def confirm_payment(payment_key:, order_id:, amount:)
    response = post("/payments/confirm", {
      paymentKey: payment_key,
      orderId: order_id,
      amount: amount.to_i
    })

    unless response["status"] == "DONE"
      raise PaymentError, "결제 승인 실패: #{response.dig('failure', 'message') || response['message']}"
    end

    response
  end

  # 결제 취소/환불
  def cancel_payment(payment_key:, reason:, amount: nil)
    body = { cancelReason: reason }
    body[:cancelAmount] = amount.to_i if amount.present?

    response = post("/payments/#{payment_key}/cancel", body)

    unless response["cancels"].present?
      raise PaymentError, "환불 실패: #{response.dig('failure', 'message') || response['message']}"
    end

    response
  end

  # 결제 조회
  def get_payment(payment_key)
    get("/payments/#{payment_key}")
  end

  # 결제 조회 (orderId 기준)
  def get_payment_by_order(order_id)
    get("/payments/orders/#{order_id}")
  end

  private

  def auth_header
    encoded = Base64.strict_encode64("#{@secret_key}:")
    "Basic #{encoded}"
  end

  def post(path, body)
    uri = URI("#{API_BASE_URL}#{path}")
    req = Net::HTTP::Post.new(uri)
    req["Authorization"] = auth_header
    req["Content-Type"] = "application/json"
    req.body = body.to_json
    http_request(uri, req)
  end

  def get(path)
    uri = URI("#{API_BASE_URL}#{path}")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = auth_header
    http_request(uri, req)
  end

  def http_request(uri, req)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 30
    http.open_timeout = 10

    response = http.request(req)
    JSON.parse(response.body)
  rescue JSON::ParserError
    raise PaymentError, "Toss API 응답 파싱 오류"
  rescue => e
    raise PaymentError, "Toss API 통신 오류: #{e.message}"
  end
end
