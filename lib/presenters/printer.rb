# frozen_string_literal: true

module LogsParser
  module Presenters
    class Printer
      DELEMITER = '==============================='

      def initialize(source = $stdout)
        @source = source
      end

      def present_visits_count(name, data, data_key)
        with_separators(name) do
          data.each_with_index do |(key, value), index|
            source.puts "#{index}) #{key} -- #{value[data_key.to_sym]} visits"
          end
        end
      end

      def present_artifacts(name, data)
        with_separators(name) do
          data.each_with_index do |invalid, index|
            source.puts "#{index}) #{invalid}"
          end
        end
      end

      private

      attr_reader :source

      def with_separators(name)
        source.puts "======#{name}======"
        yield
        source.puts DELEMITER
      end
    end
  end
end
