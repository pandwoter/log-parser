# frozen_string_literal: true

require 'parser'

RSpec.describe LogsParser::Parser do
  subject { described_class.new(path).call }

  describe 'Parser functionality' do
    context 'when real file provided' do
      let(:path) { File.expand_path('fixtures/valid_file.log', RSPEC_ROOT) }

      let(:script_result) do
        <<~MESSAGE
          ======MOST PAGE VIEWS======
          0) /some_path -- 2 visits
          1) /some_path1 -- 1 visits
          ===============================
          ======MOST UNIQ PAGE VIEWS======
          0) /some_path -- 2 visits
          1) /some_path1 -- 1 visits
          ===============================
          ======UNIQ VISITORS ADDRS======
          0) /some_path -- ["127.12.138.11", "127.12.138.10"] visits
          1) /some_path1 -- ["127.12.138.22"] visits
          ===============================
          ======INVALID LOGS======
          0) {:addr=>nil, :path=>"asdasdas", :errors=>["Line format isn't valid!", "Provided IP addr isn't valid!"]}
          1) {:addr=>nil, :path=>"asdasdasd", :errors=>["Line format isn't valid!", "Provided IP addr isn't valid!"]}
          ===============================
        MESSAGE
      end

      it 'prints valid output' do
        expect { subject }.to output(script_result).to_stdout
      end
    end

    context 'with invalid file path' do
      let(:path) { '/asdsadas' }

      it 'prints warning' do
        expect { subject }.to output("It seem's provided path is invalid\n").to_stdout
      end
    end

    context 'with invalid file extension' do
      let(:path) { File.expand_path('fixtures/invalid_file.pdf', RSPEC_ROOT) }

      it 'prints warning' do
        expect { subject }.to output("It seem's file extension is invalid\n").to_stdout
      end
    end
  end
end
