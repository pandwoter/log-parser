# frozen_string_literal: true

require 'printers/base_printer'

module LogsParser
  module Printers
    class VisitsPrinter < BasePrinter
      PAGE_VIEWS_SECTION_NAME = 'MOST PAGE VIEWS'
      VISITS_ADDR_SECTION_NAME = 'UNIQ VISITORS ADDRS'
      UNIQ_PAGE_VIEWS_SECTION_NAME = 'MOST UNIQ PAGE VIEWS'

      def call
        output_page_views
        output_uniq_page_views
        output_visits_addrs
      end

      private

      def output_page_views
        output(PAGE_VIEWS_SECTION_NAME, page_views, :hits)
      end

      def output_visits_addrs
        output(VISITS_ADDR_SECTION_NAME, page_views, :visitors)
      end

      def output_uniq_page_views
        output(UNIQ_PAGE_VIEWS_SECTION_NAME, uniq_page_views, :uniq_hits)
      end

      def page_views
        data[:valid].sort_by { |_, val| val[:hits] }.reverse
      end

      def uniq_page_views
        data[:valid].sort_by { |_, val| val[:uniq_hits] }.reverse
      end

      def output(name, data, data_key)
        with_separators(name) do
          data.each_with_index do |(key, value), index|
            source.puts "#{index}) #{key} -- #{value[data_key.to_sym]} visits"
          end
        end
      end
    end
  end
end
