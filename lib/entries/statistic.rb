# frozen_string_literal: true

module LogsParser
  module Entries
    class Statistic
      attr_reader :data

      def initialize
        @data = {}

        @data[:invalid] = []
        @data[:valid] = Hash.new { |hash, key| hash[key] = default_visit_value }
      end

      def add(line)
        addr, path, errors = line.values_at(:addr, :path, :errors)

        if errors.empty?
          process_valid_line(addr, path)
        else
          process_invalid_line(line)
        end
      end

      private

      def process_valid_line(addr, path)
        entry = data[:valid][path.to_sym]

        increment_views(entry, addr)
      end

      def increment_views(entry, addr)
        entry[:hits] += 1

        return if entry[:visitors].include? addr

        entry[:uniq_hits] += 1
        entry[:visitors] << addr
      end

      def default_visit_value
        { hits: 0, uniq_hits: 0, visitors: [] }
      end

      def process_invalid_line(line)
        data[:invalid] << line
      end
    end
  end
end
