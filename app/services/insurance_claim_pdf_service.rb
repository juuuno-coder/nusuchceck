class InsuranceClaimPdfService
  require 'prawn'
  require 'prawn/table'

  def initialize(insurance_claim)
    @claim = insurance_claim
    @pdf = Prawn::Document.new(page_size: 'A4', margin: 40)
  end

  def generate
    # 한글 폰트 설정
    setup_fonts

    # 헤더
    render_header

    # 신청서 번호 및 상태
    render_claim_info

    # 신청자 정보
    render_section("신청자 정보", [
      ["성명", @claim.applicant_name],
      ["연락처", @claim.applicant_phone],
      ["이메일", @claim.applicant_email || "-"],
      ["생년월일", @claim.birth_date&.strftime("%Y년 %m월 %d일") || "-"]
    ])

    # 사고 정보
    render_section("사고 정보", [
      ["사고 발생일", @claim.incident_date.strftime("%Y년 %m월 %d일")],
      ["사고 장소", @claim.incident_address + (@claim.incident_detail_address.present? ? " #{@claim.incident_detail_address}" : "")],
      ["피해 유형", @claim.damage_type_label],
      ["예상 피해 금액", @claim.estimated_damage_amount ? "#{number_with_delimiter(@claim.estimated_damage_amount)}원" : "-"]
    ])

    # 사고 내용 상세
    @pdf.move_down 15
    @pdf.text "사고 내용 상세", size: 12, style: :bold
    @pdf.move_down 5
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      @pdf.stroke_bounds
      @pdf.pad(10) do
        @pdf.text @claim.incident_description, size: 10
      end
    end

    # 보험 정보
    if @claim.insurance_company.present? || @claim.policy_number.present?
      render_section("보험 정보", [
        ["보험사", @claim.insurance_company || "-"],
        ["증권번호", @claim.policy_number || "-"]
      ])
    end

    # 피해자 정보
    if @claim.victim_name.present?
      render_section("피해자 정보", [
        ["성명", @claim.victim_name],
        ["연락처", @claim.victim_phone || "-"],
        ["주소", @claim.victim_address || "-"]
      ])
    end

    # 전문가 작성 정보
    if @claim.prepared_by_master?
      @pdf.move_down 20
      @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
        @pdf.fill_color "9333EA"
        @pdf.stroke_color "9333EA"
        @pdf.stroke_bounds
        @pdf.pad(10) do
          @pdf.fill_color "000000"
          @pdf.text "전문가가 작성한 신청서", size: 10, style: :bold
          @pdf.move_down 3
          @pdf.text "작성자: #{@claim.prepared_by_master.name}", size: 9
          if @claim.customer_reviewed?
            @pdf.text "고객 승인: #{@claim.customer_reviewed_at&.strftime('%Y년 %m월 %d일 %H:%M')}", size: 9
          end
        end
        @pdf.stroke_color "000000"
      end
    end

    # 푸터
    render_footer

    @pdf
  end

  private

  def setup_fonts
    # 기본적으로 Prawn은 한글을 지원하지 않으므로,
    # 실제 운영 환경에서는 한글 폰트를 추가해야 합니다.
    # 여기서는 기본 설정만 제공합니다.
  end

  def render_header
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      @pdf.fill_color "3B82F6"
      @pdf.text "보험 청구서", size: 24, style: :bold, align: :center
      @pdf.move_down 5
      @pdf.fill_color "6B7280"
      @pdf.text "누수체크 플랫폼", size: 12, align: :center
      @pdf.fill_color "000000"
    end
    @pdf.move_down 20
  end

  def render_claim_info
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width, height: 60) do
      @pdf.fill_color "EFF6FF"
      @pdf.fill_rectangle [0, @pdf.bounds.top], @pdf.bounds.width, @pdf.bounds.height
      @pdf.fill_color "000000"

      @pdf.pad(10) do
        @pdf.text "신청서 번호: #{@claim.claim_number}", size: 14, style: :bold
        @pdf.move_down 5
        @pdf.text "현재 상태: #{@claim.status_label}", size: 11
        @pdf.text "작성일: #{@claim.created_at.strftime('%Y년 %m월 %d일')}", size: 11
        if @claim.submitted_at.present?
          @pdf.text "제출일: #{@claim.submitted_at.strftime('%Y년 %m월 %d일 %H:%M')}", size: 11
        end
      end
    end
    @pdf.move_down 20
  end

  def render_section(title, data)
    @pdf.move_down 15
    @pdf.text title, size: 12, style: :bold
    @pdf.move_down 5

    table_data = data.map { |label, value| [label, value] }

    @pdf.table(table_data,
      width: @pdf.bounds.width,
      cell_style: {
        borders: [:top, :bottom, :left, :right],
        border_color: 'CCCCCC',
        padding: [8, 10]
      },
      column_widths: { 0 => 120 }
    ) do
      column(0).style(font_style: :bold, background_color: 'F3F4F6')
      column(1).style(background_color: 'FFFFFF')
    end
  end

  def render_footer
    @pdf.move_down 30
    @pdf.stroke_horizontal_rule
    @pdf.move_down 10

    @pdf.text "본 문서는 누수체크 플랫폼에서 생성되었습니다.", size: 8, align: :center, color: "6B7280"
    @pdf.text "문의: support@nusucheck.kr", size: 8, align: :center, color: "6B7280"

    # 페이지 번호
    @pdf.number_pages "<page> / <total>",
      at: [@pdf.bounds.right - 50, 0],
      align: :right,
      size: 8
  end

  def number_with_delimiter(number)
    number.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
  end
end
