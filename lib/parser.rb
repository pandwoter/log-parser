# frozen_string_literal: true

require 'adapters/file_adapter'
require 'presenters/console_presenter'

module LogsParser
  class Parser
    def initialize(
      path,
      adapter = Adapters::FileAdapter,
      presenter = Presenters::ConsolePresenter
    )
      @path = path
      @adapter = adapter
      @presenter = presenter
    end
    
    def call
      unless path_present?
        puts "It seem's you aren't provided Path to file!"
        return
      end
    
      present
    end
    
    private
    
    attr_reader :path, :adapter, :presenter
    
    def path_present?
      !!path
    end
    
    def present
      presenter.new(collect_data).call
    end
    
    def collect_data
      adapter.new(path).call
    end
  end
end
