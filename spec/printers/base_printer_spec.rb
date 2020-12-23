# frozen_string_literal: true

require 'printers/base_printer'

RSpec.describe LogsParser::Printers::BasePrinter do
  subject { described_class.new([]).call }

  describe '#call' do
    it 'raises not ImplementedError' do
      expect { subject }.to raise_error(NotImplementedError, 'you schould implement this method in child class')
    end
  end
end
