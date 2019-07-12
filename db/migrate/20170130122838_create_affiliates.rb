class CreateAffiliates < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliates do |t|
      t.string :company, :null => false
      t.string :a_id, :null => false
      t.text :a_tag, :null => false
      t.boolean :delete_flg,default: false, :null => false
      t.timestamps
    end
  end
end
