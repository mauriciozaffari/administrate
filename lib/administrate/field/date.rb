require_relative "base"

module Administrate
  module Field
    class Date < Base
      def date
        return if data.blank?

        I18n.localize(
          data.in_time_zone(timezone).to_date,
          format: format,
        )
      end

      def datetime
        return if data.blank?

        I18n.localize(
          data.in_time_zone(timezone),
          format: format,
          default: data,
        )
      end

      def datetimepicker_format
        options.fetch(:datetimepicker_format, "")
      end

      private

      def format
        options.fetch(:format, :default)
      end

      def timezone
        options.fetch(:timezone, ::Time.zone.name || "UTC")
      end
    end
  end
end
