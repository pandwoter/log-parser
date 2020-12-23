# frozen_string_literal: true

require 'presenters/console_presenter'

RSpec.describe LogsParser::Presenters::ConsolePresenter do
  subject { described_class.new(data, printer).call }

  let(:printer) { instance_double('Printer') }

  let(:data) do
    {
      valid: {
        "/some_path": { hits: 2, uniq_hits: 2, visitors: ['127.12.138.11', '127.12.138.10'] },
        "/some_path1": { hits: 1, uniq_hits: 1, visitors: ['127.12.138.22'] }
      },
      invalid: [
        { addr: nil, path: 'asdasdas', valid?: ["Line format isn't valid!", "Provided IP addr isn't valid!"] },
        { addr: nil, path: 'asdasdasd', valid?: ["Line format isn't valid!", "Provided IP addr isn't valid!"] }
      ]
    }
  end

  let(:artifacts) { data[:invalid] }
  let(:data_by_page_views) { data[:valid].sort_by { |_k, v| v[:hits] }.reverse }
  let(:data_by_uniq_page_views) { data[:valid].sort_by { |_k, v| v[:uniq_hits] }.reverse }

  describe '#call' do
    before do
      allow(printer).to receive(:present_artifacts)
      allow(printer).to receive(:present_visits_count)
    end

    it 'calls `Printer` methods with sorted data hash' do
      expect(printer).to receive(:present_artifacts).with('INVALID LOGS', artifacts)
      expect(printer).to receive(:present_visits_count).with('MOST PAGE VIEWS', data_by_page_views, 'hits')
      expect(printer).to receive(:present_visits_count).with('MOST UNIQ PAGE VIEWS', data_by_uniq_page_views, 'uniq_hits')
      expect(printer).to receive(:present_visits_count).with('UNIQ VISITORS ADDRS', data_by_page_views, 'visitors')

      subject
    end
  end
end
