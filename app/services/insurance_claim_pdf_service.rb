class InsuranceClaimPdfService
  FONT_PATH = Rails.root.join("app", "assets", "fonts")

  attr_reader :claim

  def initialize(claim)
    @claim = claim
  end

  def generate
    Prawn::Document.new(page_size: "A4") do |pdf|
      setup_fonts(pdf)

      # 헤더
      pdf.text "일상배상책임보험 신청서", size: 24, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "신청번호: #{claim.claim_number}", size: 12, align: :center, color: "666666"
      pdf.move_down 20
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      # 1. 신청자 정보
      pdf.text "1. 신청자 정보", size: 16, style: :bold
      pdf.move_down 10
      applicant_data = [
        ["성명", claim.applicant_name],
        ["연락처", claim.applicant_phone],
        ["이메일", claim.applicant_email || "-"],
        ["생년월일", claim.birth_date&.strftime("%Y년 %m월 %d일") || "-"]
      ]
      pdf.table(applicant_data, column_widths: [120, 400],
                cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 20

      # 2. 사고 정보
      pdf.text "2. 사고 정보", size: 16, style: :bold
      pdf.move_down 10
      incident_data = [
        ["사고 발생일", claim.incident_date.strftime("%Y년 %m월 %d일")],
        ["사고 장소", claim.incident_address],
        ["상세 주소", claim.incident_detail_address || "-"],
        ["피해 유형", claim.damage_type_label],
        ["예상 피해액", number_with_comma(claim.estimated_damage_amount)]
      ]
      pdf.table(incident_data, column_widths: [120, 400],
                cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 10
      pdf.text "사고 내용:", size: 12, style: :bold
      pdf.move_down 5
      pdf.text claim.incident_description, size: 11

      pdf.move_down 20

      # 3. 보험 정보
      pdf.text "3. 보험 정보", size: 16, style: :bold
      pdf.move_down 10
      insurance_data = [
        ["보험사", claim.insurance_company || "-"],
        ["증권번호", claim.policy_number || "-"],
        ["보험 종류", "일상배상책임보험"]
      ]
      pdf.table(insurance_data, column_widths: [120, 400],
                cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      # 4. 피해자 정보
      if claim.victim_name.present?
        pdf.move_down 20
        pdf.text "4. 피해자(제3자) 정보", size: 16, style: :bold
        pdf.move_down 10
        victim_data = [
          ["성명", claim.victim_name],
          ["연락처", claim.victim_phone || "-"],
          ["주소", claim.victim_address || "-"]
        ]
        pdf.table(victim_data, column_widths: [120, 400],
                  cell_style: { size: 11, padding: [5, 10] }) do
          column(0).font_style = :bold
          column(0).background_color = "F0F0F0"
        end
      end

      # 5. 연관 누수 신고
      if claim.request.present?
        pdf.move_down 20
        section_num = claim.victim_name.present? ? "5" : "4"
        pdf.text "#{section_num}. 연관 누수 신고", size: 16, style: :bold
        pdf.move_down 10
        request_data = [
          ["접수번호", "NSC-#{claim.request.id.to_s.rjust(6, '0')}"],
          ["접수일", claim.request.created_at.strftime("%Y년 %m월 %d일")],
          ["주소", claim.request.address]
        ]
        pdf.table(request_data, column_widths: [120, 400],
                  cell_style: { size: 11, padding: [5, 10] }) do
          column(0).font_style = :bold
          column(0).background_color = "F0F0F0"
        end
      end

      # 푸터
      pdf.move_down 40
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      pdf.text "본 신청서는 누수체크 플랫폼에서 자동 생성되었습니다.", size: 9, color: "999999", align: :center
      pdf.text "생성일: #{Time.current.strftime('%Y년 %m월 %d일')}", size: 9, color: "999999", align: :center
    end
  end

  private

  def setup_fonts(pdf)
    font_file = FONT_PATH.join("NanumGothic.ttf")
    bold_font_file = FONT_PATH.join("NanumGothicBold.ttf")

    if font_file.exist?
      pdf.font_families.update(
        "NanumGothic" => {
          normal: font_file.to_s,
          bold: bold_font_file.exist? ? bold_font_file.to_s : font_file.to_s
        }
      )
      pdf.font "NanumGothic"
    end
  end

  def number_with_comma(number)
    return "-" unless number
    number.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse + "원"
  end
end
