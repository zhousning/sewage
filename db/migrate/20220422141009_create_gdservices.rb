class CreateGdservices < ActiveRecord::Migration
  def change
    create_table :gdservices do |t|
    
      t.string :key,  null: false, default: Setting.systems.default_str
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :sid,  null: false, default: Setting.systems.default_str
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
