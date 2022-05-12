class CreateTaskReports < ActiveRecord::Migration
  def change
    create_table :task_reports do |t|
    
      t.float :longitude,  null: false, default: Setting.systems.default_num 
    
      t.float :latitude,  null: false, default: Setting.systems.default_num 
    
      t.string :state,  null: false, default: Setting.systems.default_str
    
      t.string :question,  null: false, default: Setting.systems.default_str
    
      t.text :img

    

    

    
      t.references :task
    
      t.references :device
    
      t.references :wx_user

    
      t.timestamps null: false
    end
  end
end
