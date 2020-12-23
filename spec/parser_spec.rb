# frozen_string_literal: true

require 'parser'

RSpec.describe LogsParser::Parser do
  subject { described_class.new(path, adapter, presenter).call }

  let(:adapter) { double('Adapter') }
  let(:adapter_instance) { instance_double('Adapter') }

  let(:presenter) { double('Presenter') }
  let(:presenter_instance) { instance_double('Presenter') }

  describe '#call' do
    context 'when path exists' do
      let(:path) { 'some_path' }

      before do
        allow(adapter).to   receive(:new).and_return(adapter_instance)
        allow(presenter).to receive(:new).and_return(presenter_instance)

        allow(adapter_instance).to   receive(:call)
        allow(presenter_instance).to receive(:call)
      end

      it 'calls `adapter` and `presenter`' do
        expect(adapter).to receive(:new)
        expect(presenter).to receive(:new)
        expect(adapter_instance).to receive(:call)
        expect(presenter_instance).to receive(:call)

        subject
      end
    end

    context "when path doesn't exists" do
      let(:path) { nil }

      it { expect { subject }.to output("It seem's you aren't provided Path to file!\n").to_stdout }
    end
  end
end
