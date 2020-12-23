# frozen_string_literal: true

require 'printers/visits_printer'

RSpec.describe LogsParser::Printers::VisitsPrinter do
  subject { described_class.new(data, outstream).call }

  let(:outstream) { StringIO.new }

  let(:data) do
    {
      valid: {
        "/some_path": { hits: 2, uniq_hits: 2, visitors: ['127.12.138.11', '127.12.138.10'] },
        "/some_path1": { hits: 1, uniq_hits: 1, visitors: ['127.12.138.22'] }
      }
    }
  end

  let(:page_views_section) do
    <<~MESSAGE
      ======MOST PAGE VIEWS======
      0) /some_path -- 2 visits
      1) /some_path1 -- 1 visits
      ===============================
    MESSAGE
  end

  let(:uniq_page_views_section) do
    <<~MESSAGE
      ======MOST UNIQ PAGE VIEWS======
      0) /some_path -- 2 visits
      1) /some_path1 -- 1 visits
      ===============================
    MESSAGE
  end

  let(:visits_addr_section) do
    <<~MESSAGE
      ======UNIQ VISITORS ADDRS======
      0) /some_path -- ["127.12.138.11", "127.12.138.10"] visits
      1) /some_path1 -- ["127.12.138.22"] visits
      ===============================
    MESSAGE
  end

  describe '#call' do
    before do
      subject
    end
    
    it 'output PageViews section' do
      expect(outstream.string).to include(page_views_section)
    end

    it 'outputs UniqPageViews section' do
      expect(outstream.string).to include(uniq_page_views_section)
    end

    it 'outputs VisitsCount section' do
      expect(outstream.string).to include(visits_addr_section)
    end
  end
end
