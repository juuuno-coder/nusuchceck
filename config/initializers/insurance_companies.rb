# frozen_string_literal: true

# 보험사 정보 상수 정의
INSURANCE_COMPANIES = {
  "삼성화재" => {
    name: "삼성화재",
    email: "claim@samsungfire.com", # 실제 이메일로 교체 필요
    phone: "1588-5114",
    app_name: "삼성화재 다이렉트",
    website: "https://direct.samsungfire.com",
    claim_menu: "보험금 청구",
    logo_emoji: "🔵"
  },
  "현대해상" => {
    name: "현대해상",
    email: "claim@hi.co.kr", # 실제 이메일로 교체 필요
    phone: "1588-5656",
    app_name: "굿앤굿",
    website: "https://www.hi.co.kr",
    claim_menu: "간편청구",
    logo_emoji: "🟢"
  },
  "DB손해보험" => {
    name: "DB손해보험",
    email: "claim@idbins.com", # 실제 이메일로 교체 필요
    phone: "1588-0100",
    app_name: "DB손해보험",
    website: "https://www.idbins.com",
    claim_menu: "보험금 청구",
    logo_emoji: "🔴"
  },
  "메리츠화재" => {
    name: "메리츠화재",
    email: "claim@meritzfire.com", # 실제 이메일로 교체 필요
    phone: "1566-7711",
    app_name: "메리츠화재",
    website: "https://www.meritzfire.com",
    claim_menu: "보험금 청구",
    logo_emoji: "🟡"
  },
  "KB손해보험" => {
    name: "KB손해보험",
    email: "claim@kbinsure.co.kr", # 실제 이메일로 교체 필요
    phone: "1544-0114",
    app_name: "KB손해보험",
    website: "https://www.kbinsure.co.kr",
    claim_menu: "보험금 청구",
    logo_emoji: "🟠"
  },
  "롯데손해보험" => {
    name: "롯데손해보험",
    email: "claim@lotteins.co.kr", # 실제 이메일로 교체 필요
    phone: "1588-3344",
    app_name: "롯데손해보험",
    website: "https://www.lotteins.co.kr",
    claim_menu: "보험금 청구",
    logo_emoji: "⚪"
  }
}.freeze

# 보험사 목록 (선택 옵션용)
INSURANCE_COMPANY_OPTIONS = INSURANCE_COMPANIES.keys.freeze
