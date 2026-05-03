# frozen_string_literal: true

namespace :page_views do
  desc "Rails production.log에서 페이지뷰 데이터를 파싱해 page_views 테이블에 백필"
  task backfill: :environment do
    log_path = ENV.fetch("LOG_PATH", Rails.root.join("log/production.log").to_s)

    unless File.exist?(log_path)
      puts "로그 파일 없음: #{log_path}"
      exit 0
    end

    # Started GET "/path" for IP at 2026-05-03 14:57:05 +0000
    # Started POST, HEAD 등은 제외, GET만 카운트
    pattern = /\[(?<uuid>[^\]]+)\] Started GET "(?<path>[^"]+)" for [\d\.]+ at (?<ts>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/

    # 관리자/봇/헬스체크 제외 경로 패턴
    skip_paths = %r{\A(/up|/rails/|/assets/|/packs/|/cable|/admin)}

    inserted = 0
    skipped  = 0
    batch    = []
    now      = Time.current

    puts "파싱 시작: #{log_path}"

    File.foreach(log_path) do |line|
      m = line.match(pattern)
      next unless m

      path = m[:path].split("?").first  # 쿼리스트링 제거
      next if path.match?(skip_paths)

      begin
        ts        = Time.zone.parse(m[:ts])
        viewed_on = ts.to_date
      rescue
        next
      end

      batch << {
        viewed_on:       viewed_on,
        path:            path.slice(0, 255),
        controller_name: nil,
        action_name:     nil,
        user_id:         nil,
        created_at:      ts,
        updated_at:      ts
      }

      if batch.size >= 500
        PageView.insert_all(batch)
        inserted += batch.size
        batch = []
        print "."
      end
    end

    unless batch.empty?
      PageView.insert_all(batch)
      inserted += batch.size
    end

    puts "\n완료: #{inserted}건 삽입, #{skipped}건 스킵"
  end

  desc "오래된 page_views 정리 (기본 90일 이전 삭제)"
  task cleanup: :environment do
    days = ENV.fetch("DAYS", 90).to_i
    deleted = PageView.where("viewed_on < ?", days.days.ago.to_date).delete_all
    puts "#{deleted}건 삭제 (#{days}일 이전)"
  end
end
