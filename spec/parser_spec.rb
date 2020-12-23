# frozen_string_literal: true

require 'parser'

RSpec.describe LogsParser::Parser do
  subject { described_class.new(path, adapter, printers).call }

  let(:adapter) { double(LogsParser::Adapters::FileAdapter) }
  let(:adapter_instance) { instance_double(LogsParser::Adapters::FileAdapter) }

  let(:printers) { [printer] }

  let(:printer) { double(LogsParser::Printers::VisitsPrinter) }
  let(:printer_instance) { instance_double(LogsParser::Printers::VisitsPrinter) }

  describe '#call' do
    context 'with invalid path' do
      let(:path) { 'some_path' }

      it 'calls `adapter`' do
        allow(adapter).to receive(:new).and_return(adapter_instance)

        expect(adapter_instance).to receive(:call)

        subject
      end
    end

    context 'with valid path' do
      let(:path) { File.expand_path('fixtures/valid_file.log', RSPEC_ROOT) }

      it 'calls `adapter` and `printer`' do
        allow(adapter).to receive(:new).and_return(adapter_instance)
        allow(printer).to receive(:new).and_return(printer_instance)
        allow(adapter_instance).to receive(:call).and_return([])

        expect(adapter_instance).to receive(:call)
        expect(printer_instance).to receive(:call)

        subject
      end
    end

    context "when path doesn't exists" do
      let(:path) { nil }

      it { expect { subject }.to output("It seem's you aren't provided Path to file!\n").to_stdout }
    end
  end
end
