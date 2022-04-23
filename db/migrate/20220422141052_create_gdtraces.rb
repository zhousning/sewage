class CreateGdtraces < ActiveRecord::Migration
  def change
    create_table :gdtraces do |t|
    
      t.string :trid,  null: false, default: Setting.systems.default_str
    
      t.string :trname,  null: false, default: Setting.systems.default_str
    

    

    

      t.references :task_log
    
      t.references :gdteminal
    

    
      t.timestamps null: false
    end
  end
end
