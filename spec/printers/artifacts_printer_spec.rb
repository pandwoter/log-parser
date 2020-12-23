# frozen_string_literal: true

require 'printers/artifacts_printer'

RSpec.describe LogsParser::Printers::ArtifactsPrinter do
  subject { described_class.new(data, outstream).call }

  let(:outstream) { StringIO.new }

  let(:data) do
    {
      invalid: [
        { addr: nil, path: 'asdasdas', errors: ["Line format isn't valid!", "Provided IP addr isn't valid!"] },
        { addr: nil, path: 'asdasdasd', errors: ["Line format isn't valid!", "Provided IP addr isn't valid!"] }
      ]
    }
  end

  let(:artifacts_section) do
    <<~MESSAGE
      ======INVALID LOGS======
      0) {:addr=>nil, :path=>"asdasdas", :errors=>["Line format isn't valid!", "Provided IP addr isn't valid!"]}
      1) {:addr=>nil, :path=>"asdasdasd", :errors=>["Line format isn't valid!", "Provided IP addr isn't valid!"]}
      ===============================
    MESSAGE
  end

  describe '#call' do
    before do
      subject
    end

    it 'output Artifacts section' do
      expect(outstream.string).to include(artifacts_section)
    end
  end
end
