# frozen_string_literal: true

class LeakInspectionAnalysisJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(inspection_id)
    inspection = LeakInspection.find(inspection_id)
    return if inspection.completed? || inspection.failed?

    LeakInspectionService.new(inspection).analyze!
  rescue LeakInspectionService::AnalysisError => e
    Rails.logger.error("[LeakInspectionAnalysisJob] #{e.message}")
    Sentry.capture_exception(e) if defined?(Sentry)
  end
end
