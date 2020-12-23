# frozen_string_literal: true

require 'adapters/file_adapter'
require 'printers/visits_printer'
require 'printers/artifacts_printer'

module LogsParser
  class Parser
    def initialize(
      path,
      adapter = Adapters::FileAdapter,
      printers = [Printers::VisitsPrinter, Printers::ArtifactsPrinter]
    )
      @path = path
      @adapter = adapter
      @printers = printers
    end

    def call
      unless path_present?
        puts "It seem's you aren't provided Path to file!"
        return
      end

      print_result
    end

    private

    attr_reader :path, :adapter, :printers

    def path_present?
      !!path
    end

    def print_result
      return unless collected_data

      printers.each { |p| p.new(collected_data).call }
    end

    def collected_data
      @collected_data ||= adapter.new(path).call
    end
  end
end
