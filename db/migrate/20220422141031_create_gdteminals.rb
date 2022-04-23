class CreateGdteminals < ActiveRecord::Migration
  def change
    create_table :gdteminals do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :tid,  null: false, default: Setting.systems.default_str
    
      t.text :desc
    

    

    

      t.references :wx_user 
    
      t.references :gdservice
    

    
      t.timestamps null: false
    end
  end
end
