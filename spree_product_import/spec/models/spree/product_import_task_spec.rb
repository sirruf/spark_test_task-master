require 'spec_helper'
require 'shared/product_file_shared'

describe Spree::ProductImportTask, type: :model do
  include_context 'shared product file'
  context 'New ProductImportTask' do
    it 'is valid with correct file' do
      task = described_class.generate_from(correct_file)
      expect(task).to be_valid
      expect(task.filename).to eq(correct_file.original_filename)
      expect(task.filepath).to eq(correct_file.tempfile.path)
      expect(task.filesize).to eq(correct_file.tempfile.length)
    end

    it 'has errors without file' do
      task = described_class.generate_from(nil)
      expect(task).to_not be_valid
      expect(task.errors.messages[:filename]).to eq ["can't be blank"]
      expect(task.errors.messages[:filepath]).to eq ["can't be blank"]
    end
  end
end
describe Spree::ProductImportTask, type: :model do
  include_context 'shared product file'
  context 'method class#generate' do
    it 'is create new task with correct file' do
      task = described_class.generate_from(correct_file)
      expect(Spree::ProductImportTask.last).to eq(task)
      expect(task.filename).to eq(correct_file.original_filename)
      expect(task.filepath).to eq(correct_file.tempfile.path)
      expect(task.filesize).to eq(correct_file.tempfile.length)
    end
    it 'is not create new task without file' do
      described_class.generate_from(nil)
      expect(Spree::ProductImportTask.last).to be_nil
    end
  end
  context 'method instance#process_available?' do
    it 'return true if processing available' do
      task = described_class.generate_from(correct_file)
      expect(task.process_available?).to eq(true)
    end
    it 'return false if processing unavailable' do
      task = described_class.generate_from(nil)
      expect(task.process_available?).to eq(false)
    end
  end
end
