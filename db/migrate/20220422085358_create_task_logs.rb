class CreateTaskLogs < ActiveRecord::Migration
  def change
    create_table :task_logs do |t|
    
      t.datetime :start_time
    
      t.datetime :end_time
    
      t.string :state,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.references :task
    
      t.references :wx_user
    

    
      t.timestamps null: false
    end
  end
end
