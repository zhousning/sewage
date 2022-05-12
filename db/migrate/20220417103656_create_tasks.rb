class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    
      t.date :task_date,  null: false, default: Date.today
    
      t.text :des
    
      t.string :state,  null: false, default: Setting.states.ongoing


    
      t.references :factory
    

    
      t.timestamps null: false
    end
  end
end
