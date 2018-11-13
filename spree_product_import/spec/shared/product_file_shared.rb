require 'rails_helper'

shared_context 'shared product file' do
  let(:correct_file) do
    fixture_file_upload('spec/fixtures/csv_correct.csv', 'text/csv')
  end
end
