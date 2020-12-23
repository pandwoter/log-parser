# frozen_string_literal: true

module LogsParser
  module Printers
    class BasePrinter
      DELEMITER = '==============================='

      def initialize(data, source = $stdout)
        @data = data
        @source = source
      end

      def call
        raise NotImplementedError, 'you schould implement this method in child class'
      end

      private

      attr_reader :source, :data

      def with_separators(name)
        source.puts "======#{name}======"
        yield
        source.puts DELEMITER
      end
    end
  end
end
