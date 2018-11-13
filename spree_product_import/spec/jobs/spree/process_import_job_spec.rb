# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::ProcessImportJob, type: :job do
  let(:correct_file) do
    fixture_file_upload('spec/fixtures/csv_correct.csv', 'text/csv')
  end
  context 'New background task' do
    it 'created by Spree::ProductImportTask#generate_from' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        Spree::ProductImportTask.generate_from(correct_file)
      end.to have_enqueued_job
    end
  end
end
