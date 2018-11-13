#
#  Product iport Tasks model
#
class CreateSpreeProductImportTasks < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_product_import_tasks do |t|
      t.string :filename
      t.string :content_type
      t.integer :filesize
      t.string :filepath
      t.string :status, default: :new
      t.string :error_message

      t.timestamps
    end
  end
end
