# frozen_string_literal: true

require 'entries/statistic'

RSpec.describe LogsParser::Entries::Statistic do
  subject { described_class.new }

  describe '#add' do
    before do
      subject.add(line)
    end

    context 'when line is valid' do
      let(:line) do
        {
          addr: '172.168.1.1',
          path: '/some_path',
          valid?: []
        }
      end

      let(:line2) do
        {
          addr: '172.168.1.2',
          path: '/some_path',
          valid?: []
        }
      end

      let(:path_key) { line[:path].to_sym }

      it 'populates :valid hash with standart values' do
        expect(subject.data[:valid]).to have_key(path_key)
        expect(subject.data[:valid][path_key][:hits]).to eq 1
        expect(subject.data[:valid][path_key][:uniq_hits]).to eq 1
        expect(subject.data[:valid][path_key][:visitors]).to eq [line[:addr]]
      end

      it 'increase :uniq_hits when uniq visit happens' do
        subject.add(line2)

        expect(subject.data[:valid][path_key][:hits]).to eq 2
        expect(subject.data[:valid][path_key][:uniq_hits]).to eq 2
        expect(subject.data[:valid][path_key][:visitors]).to eq [line[:addr], line2[:addr]]
      end

      it "increase :hits and don't increase :visitors and :uniq_hits"\
         'when not uniq visit happens' do
        subject.add(line)

        expect(subject.data[:valid][path_key][:hits]).to eq 2
        expect(subject.data[:valid][path_key][:uniq_hits]).to eq 1
        expect(subject.data[:valid][path_key][:visitors]).to eq [line[:addr]]
      end
    end

    context 'when line is invalid' do
      let(:line) do
        {
          addr: 'xxxx',
          path: '123',
          valid?: ['some error', 'error']
        }
      end

      it 'populates invalid hash' do
        expect(subject.data[:invalid]).to include line
      end
    end
  end
end
