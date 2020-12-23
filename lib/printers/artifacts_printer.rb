# frozen_string_literal: true

require 'printers/base_printer'

module LogsParser
  module Printers
    class ArtifactsPrinter < BasePrinter
      SECTION_NAME = 'INVALID LOGS'

      def call
        output_artifacts
      end

      private

      def output_artifacts
        output(SECTION_NAME, artifacts)
      end

      def artifacts
        data[:invalid]
      end

      def output(name, data)
        with_separators(name) do
          data.each_with_index do |invalid, index|
            source.puts "#{index}) #{invalid}"
          end
        end
      end
    end
  end
end
