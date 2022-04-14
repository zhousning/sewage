class CreatePatrolers < ActiveRecord::Migration
  def change
    create_table :patrolers do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :phone,  null: false, default: Setting.systems.default_str
    
      t.string :password,  null: false, default: Setting.systems.default_str
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.timestamps null: false
    end
  end
end
