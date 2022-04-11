class CreateUpholds < ActiveRecord::Migration
  def change
    create_table :upholds do |t|
    
      t.date :uphold_date
    
      t.text :reason
    
      t.text :content
    
      t.float :cost,  null: false, default: Setting.systems.default_num 
    
      t.string :state,  null: false, default: Setting.systems.default_str
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str
    

    

    
      t.references :device
    
      t.references :factory
    

    
      t.timestamps null: false
    end
  end
end
