# frozen_string_literal: true

require 'presenters/printer'

module LogsParser
  module Presenters
    class ConsolePresenter
      def initialize(data, printer = Printer.new)
        @data = data
        @printer = printer
      end
      
      def call
        printer.present_visits_count('MOST PAGE VIEWS', page_views, 'hits')
        printer.present_visits_count('MOST UNIQ PAGE VIEWS', uniq_page_views, 'uniq_hits')
        printer.present_visits_count('UNIQ VISITORS ADDRS', page_views, 'visitors')
        printer.present_artifacts('INVALID LOGS', artifacts)
      end
      
      private
      
      attr_reader :data, :printer
      
      def page_views
        data[:valid].sort_by { |_, val| val[:hits] }.reverse
      end
      
      def uniq_page_views
        data[:valid].sort_by { |_, val| val[:uniq_hits] }.reverse
      end
      
      def artifacts
        data[:invalid]
      end
    end
  end
end
