# frozen_string_literal: true

require 'adapters/file_adapter'

RSpec.describe LogsParser::Adapters::FileAdapter do
  subject { described_class.new(path, line_entity, path_creation_lib, statistic_entity_instance).call }

  let(:line_entity)       { double('LineEntity') }
  let(:path_creation_lib) { double('Pathname') }

  let(:line_entity_instance)       { instance_double('LineEntity') }
  let(:statistic_entity_instance)  { instance_double('StatisticEntity') }
  let(:path_creation_lib_instance) { instance_double('Pathname') }

  describe '#call' do
    before do
      allow(path_creation_lib).to receive(:new).and_return(path_creation_lib_instance)
      allow(line_entity).to       receive(:new).and_return(line_entity_instance)
    end

    context 'with existing file' do
      before do
        allow(path_creation_lib).to receive(:new).and_return(Pathname.new(path))
      end

      context 'when file is valid' do
        before do
          allow(line_entity_instance).to receive(:call).and_return(line_entity_instance)
          allow(statistic_entity_instance).to receive(:add)
          allow(statistic_entity_instance).to receive(:data)
        end

        let(:path) { File.expand_path('fixtures/valid_file.log', RSPEC_ROOT) }

        it 'reads file by line and returns `StatisticEntity.data`' do
          File.foreach(path) do |l|
            expect(line_entity).to receive(:new).with(l)
            expect(line_entity_instance).to receive(:call)
            expect(statistic_entity_instance).to receive(:add).with(line_entity_instance)
          end

          expect(statistic_entity_instance).to receive(:data)

          subject
        end
      end

      context 'when file has invalid format' do
        let(:path) { File.expand_path('fixtures/invalid_file.pdf', RSPEC_ROOT) }

        it 'prints invalid file extension warning' do
          expect { subject }.to output("It seem's file extension is invalid\n").to_stdout
        end
      end
    end

    context 'when file is not exists' do
      let(:path) { '/some_not_existing_path' }

      before do
        allow(path_creation_lib_instance).to receive(:exist?).and_return(false)
      end

      it 'prints not existing file warning' do
        expect { subject }.to output("It seem's provided path is invalid\n").to_stdout
      end
    end
  end
end
