class CreateInsuranceClaims < ActiveRecord::Migration[7.1]
  def change
    create_table :insurance_claims do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }, index: true
      t.references :request, null: true, foreign_key: true, index: true

      t.string :status, default: "draft", null: false

      # 신청자 정보
      t.string :applicant_name, null: false
      t.string :applicant_phone, null: false
      t.string :applicant_email
      t.date   :birth_date

      # 사고 정보
      t.text    :incident_address, null: false
      t.string  :incident_detail_address
      t.date    :incident_date, null: false
      t.text    :incident_description, null: false
      t.string  :damage_type
      t.decimal :estimated_damage_amount, precision: 12, scale: 2

      # 보험 정보
      t.string :insurance_company
      t.string :policy_number
      t.string :insurance_type, default: "daily_liability"

      # 피해자(제3자) 정보
      t.string :victim_name
      t.string :victim_phone
      t.text   :victim_address

      # 관리
      t.text     :admin_notes
      t.string   :claim_number, null: false
      t.datetime :submitted_at
      t.datetime :reviewed_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :insurance_claims, :status
    add_index :insurance_claims, :claim_number, unique: true
  end
end
