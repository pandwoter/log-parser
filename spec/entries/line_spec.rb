# frozen_string_literal: true

require 'entries/line'

RSpec.describe LogsParser::Entries::Line do
  subject { described_class.new(line, ip_validation_lib).call }

  let(:ip_validation_lib) { double(IPAddress) }

  describe '#call' do
    context 'with valid line' do
      let(:line) { '/help_page/1 543.910.244.929' }

      it 'correctly parse line' do
        allow(ip_validation_lib).to receive(:valid?).and_return(true)

        expect(subject[:path]).to eq(line.split[0])
        expect(subject[:addr]).to eq(line.split[1])
        expect(subject[:errors]).to eq([])
      end

      it 'calls validation library' do
        expect(ip_validation_lib).to receive(:valid?).with(line.split[1])
        subject
      end
    end

    context 'with invalid line' do
      before do
        allow(ip_validation_lib).to receive(:valid?).and_return(false)
      end

      context 'without attribute' do
        let(:line) { '/help_page/1' }

        it 'populates errors array' do
          expect(subject[:errors]).to include("Line format isn't valid!")
        end

        ##
        # We can assign nils to `addr` and `path` in case of invalid Line format
        # But to provide more info I decided to assign what's assignable
        it 'assigns first value to path' do
          expect(subject[:path]).to eq(line.split[0])
        end
      end

      context 'with invalid IP addr' do
        let(:line) { '/help_page/1 xxxxxx' }

        it 'populates errors array' do
          expect(subject[:errors]).to include("Provided IP addr isn't valid!")
        end

        it 'calls validation library' do
          expect(ip_validation_lib).to receive(:valid?).with(line.split[1])
          subject
        end
      end
    end
  end
end
