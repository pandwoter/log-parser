# frozen_string_literal: true

require 'presenters/printer'

RSpec.describe LogsParser::Presenters::Printer do
  subject { described_class.new }

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

  let(:valid_message) do
    <<~MESSAGE
      ======MOST PAGE VIEWS======
      0) /some_path -- 2 visits
      1) /some_path1 -- 1 visits
      ===============================
    MESSAGE
  end

  let(:valid_artifact_message) do
    <<~MESSAGE
      ======INVALID LOGS======
      0) {:addr=>nil, :path=>"asdasdas", :valid?=>["Line format isn't valid!", "Provided IP addr isn't valid!"]}
      1) {:addr=>nil, :path=>"asdasdasd", :valid?=>["Line format isn't valid!", "Provided IP addr isn't valid!"]}
      ===============================
    MESSAGE
  end

  describe '#present_visits_count' do
    it 'outputs visits count' do
      expect { subject.present_visits_count('MOST PAGE VIEWS', data_by_page_views, 'hits') }
        .to output(valid_message).to_stdout
    end
  end

  describe '#present_artifacts' do
    it 'outputs log artifacts' do
      expect { subject.present_artifacts('INVALID LOGS', artifacts) }
        .to output(valid_artifact_message).to_stdout
    end
  end
end
