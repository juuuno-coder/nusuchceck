class PdfGeneratorService
  attr_reader :request

  FONT_PATH = Rails.root.join("app", "assets", "fonts")

  def initialize(request)
    @request = request
  end

  # 보험 보고서 PDF 생성
  def insurance_report
    Prawn::Document.new(page_size: "A4") do |pdf|
      setup_fonts(pdf)

      # 헤더
      pdf.text "누수 탐지 보고서", size: 24, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "보험사 제출용", size: 12, align: :center, color: "666666"
      pdf.move_down 20
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      # 기본 정보
      pdf.text "1. 신고 정보", size: 16, style: :bold
      pdf.move_down 10

      info_data = [
        ["접수번호", "NSC-#{request.id.to_s.rjust(6, '0')}"],
        ["접수일시", request.created_at.strftime("%Y년 %m월 %d일 %H:%M")],
        ["증상유형", I18n.t("activerecord.enums.request.symptom_type.#{request.symptom_type}")],
        ["건물유형", I18n.t("activerecord.enums.request.building_type.#{request.building_type}")],
        ["주소", request.address],
        ["상세주소", request.detailed_address || "-"],
        ["층수", request.floor_info || "-"]
      ]

      pdf.table(info_data, column_widths: [120, 400], cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 20

      # 고객 정보
      pdf.text "2. 신고자 정보", size: 16, style: :bold
      pdf.move_down 10

      customer_data = [
        ["성명", request.customer.name],
        ["연락처", request.customer.phone || "-"],
        ["이메일", request.customer.email]
      ]

      pdf.table(customer_data, column_widths: [120, 400], cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 20

      # 탐지 결과
      pdf.text "3. 탐지 결과", size: 16, style: :bold
      pdf.move_down 10

      detection_data = [
        ["탐지일시", request.detection_started_at&.strftime("%Y년 %m월 %d일 %H:%M") || "-"],
        ["담당 마스터", request.master&.name || "-"],
        ["탐지결과", detection_result_label],
        ["상세소견", request.detection_notes || "-"]
      ]

      pdf.table(detection_data, column_widths: [120, 400], cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 20

      # 증상 상세
      if request.description.present?
        pdf.text "4. 증상 상세", size: 16, style: :bold
        pdf.move_down 10
        pdf.text request.description, size: 11
        pdf.move_down 20
      end

      # 푸터
      pdf.move_down 30
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      pdf.text "본 보고서는 누수체크 플랫폼에서 자동 생성되었습니다.", size: 9, color: "999999", align: :center
      pdf.text "생성일: #{Time.current.strftime('%Y년 %m월 %d일')}", size: 9, color: "999999", align: :center
    end
  end

  # 견적서 PDF 생성
  def estimate_pdf(estimate)
    Prawn::Document.new(page_size: "A4") do |pdf|
      setup_fonts(pdf)

      # 헤더
      pdf.text "견 적 서", size: 28, style: :bold, align: :center
      pdf.move_down 20
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      # 기본 정보
      basic_data = [
        ["견적번호", "EST-#{estimate.id.to_s.rjust(6, '0')}"],
        ["접수번호", "NSC-#{request.id.to_s.rjust(6, '0')}"],
        ["작성일", estimate.created_at.strftime("%Y년 %m월 %d일")],
        ["유효기간", estimate.valid_until&.strftime("%Y년 %m월 %d일") || "7일"],
        ["고객명", request.customer.name],
        ["주소", request.address],
        ["담당 마스터", request.master&.name || "-"]
      ]

      pdf.table(basic_data, column_widths: [120, 400], cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 20

      # 견적 항목
      pdf.text "견적 상세", size: 16, style: :bold
      pdf.move_down 10

      items = estimate.parsed_line_items
      if items.any?
        header = ["구분", "항목명", "단위", "수량", "단가", "금액"]
        rows = items.map do |item|
          [
            category_label(item[:category]),
            item[:name],
            item[:unit] || "-",
            item[:quantity].to_s,
            number_with_comma(item[:unit_price]),
            number_with_comma(item[:amount])
          ]
        end

        pdf.table([header] + rows, column_widths: [60, 160, 50, 50, 100, 100],
                  header: true, cell_style: { size: 10, padding: [5, 5] }) do
          row(0).font_style = :bold
          row(0).background_color = "333333"
          row(0).text_color = "FFFFFF"
          columns(3..5).align = :right
        end
      end

      pdf.move_down 20

      # 합계
      totals_data = [
        ["탐지비 소계", number_with_comma(estimate.detection_subtotal)],
        ["공사비 소계", number_with_comma(estimate.construction_subtotal)],
        ["자재비 소계", number_with_comma(estimate.material_subtotal)],
        ["부가세 (10%)", number_with_comma(estimate.vat)],
        ["총 합계", number_with_comma(estimate.total_amount)]
      ]

      pdf.table(totals_data, column_widths: [400, 120], cell_style: { size: 11, padding: [5, 10] }) do
        columns(1).align = :right
        row(-1).font_style = :bold
        row(-1).background_color = "FFF3CD"
      end

      # 비고
      if estimate.notes.present?
        pdf.move_down 20
        pdf.text "비고", size: 14, style: :bold
        pdf.move_down 5
        pdf.text estimate.notes, size: 11
      end

      # 푸터
      pdf.move_down 40
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      pdf.text "본 견적서는 누수체크 플랫폼에서 자동 생성되었습니다.", size: 9, color: "999999", align: :center
    end
  end

  # 완료 보고서 PDF 생성
  def completion_report
    Prawn::Document.new(page_size: "A4") do |pdf|
      setup_fonts(pdf)

      pdf.text "공사 완료 보고서", size: 24, style: :bold, align: :center
      pdf.move_down 20
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      # 공사 개요
      pdf.text "1. 공사 개요", size: 16, style: :bold
      pdf.move_down 10

      overview_data = [
        ["접수번호", "NSC-#{request.id.to_s.rjust(6, '0')}"],
        ["증상유형", I18n.t("activerecord.enums.request.symptom_type.#{request.symptom_type}")],
        ["주소", request.address],
        ["담당 마스터", request.master&.name || "-"],
        ["공사시작", request.construction_started_at&.strftime("%Y년 %m월 %d일 %H:%M") || "-"],
        ["공사완료", request.construction_completed_at&.strftime("%Y년 %m월 %d일 %H:%M") || "-"],
        ["고객확인", request.closed_at&.strftime("%Y년 %m월 %d일 %H:%M") || "-"]
      ]

      pdf.table(overview_data, column_widths: [120, 400], cell_style: { size: 11, padding: [5, 10] }) do
        column(0).font_style = :bold
        column(0).background_color = "F0F0F0"
      end

      pdf.move_down 20

      # 비용 요약
      pdf.text "2. 비용 요약", size: 16, style: :bold
      pdf.move_down 10

      estimate = request.accepted_estimate
      if estimate
        cost_data = [
          ["탐지비", number_with_comma(estimate.detection_subtotal)],
          ["공사비", number_with_comma(estimate.construction_subtotal)],
          ["자재비", number_with_comma(estimate.material_subtotal)],
          ["부가세", number_with_comma(estimate.vat)],
          ["총 비용", number_with_comma(estimate.total_amount)]
        ]

        pdf.table(cost_data, column_widths: [120, 400], cell_style: { size: 11, padding: [5, 10] }) do
          column(0).font_style = :bold
          column(0).background_color = "F0F0F0"
          row(-1).font_style = :bold
          columns(1).align = :right
        end
      end

      # 리뷰
      if request.review.present?
        pdf.move_down 20
        pdf.text "3. 고객 평가", size: 16, style: :bold
        pdf.move_down 10
        pdf.text "총점: #{request.review.overall_rating}/5.0", size: 14
        pdf.move_down 5
        pdf.text request.review.comment || "(코멘트 없음)", size: 11
      end

      # 푸터
      pdf.move_down 40
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      pdf.text "본 보고서는 누수체크 플랫폼에서 자동 생성되었습니다.", size: 9, color: "999999", align: :center
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

  def detection_result_label
    case request.detection_result
    when "leak_confirmed" then "누수 확인"
    when "no_leak" then "누수 미확인"
    when "inconclusive" then "판정 불가"
    else "대기 중"
    end
  end

  def category_label(category)
    case category.to_s
    when "trip" then "출장비"
    when "detection" then "탐지"
    when "construction" then "공사"
    when "material" then "자재"
    else category.to_s
    end
  end

  def number_with_comma(number)
    return "0" unless number
    number.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse + "원"
  end
end
