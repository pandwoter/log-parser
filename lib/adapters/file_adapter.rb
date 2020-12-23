# frozen_string_literal: true

require 'entries/line'
require 'entries/statistic'

require 'pathname'

module LogsParser
  module Adapters
    class FileAdapter
      ALLOWED_EXTENSIONS = ['.log', '.txt'].freeze

      class ValidationError < StandardError; end

      def initialize(
        path,
        line_entity = Entries::Line,
        path_creation_lib = Pathname,
        statistic_entity = Entries::Statistic.new
      )
        @path = path_creation_lib.new(path)

        @line_entity = line_entity
        @statistic_entity = statistic_entity
      end

      def call
        validate
        read_process_file
        statistic_entity.data
      rescue ValidationError => error
        puts error.message
      end

      private

      attr_reader :path, :line_entity, :statistic_entity

      def read_process_file
        File.foreach(path) { |line| process_line(line) }
      end

      def process_line(line)
        line_e = line_entity.new(line).call

        statistic_entity.add(line_e)
      end

      def validate
        present?
        allowed_extension?
      end

      def present?
        raise ValidationError, "It seem's provided path is invalid" unless path.exist?
      end

      def allowed_extension?
        raise ValidationError, "It seem's file extension is invalid" unless ALLOWED_EXTENSIONS.include? path.extname
      end
    end
  end
end
