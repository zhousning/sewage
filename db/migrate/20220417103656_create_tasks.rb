class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    
      t.date :task_date
    
      t.text :des
    

    

    

    
      t.references :factory
    

    
      t.timestamps null: false
    end
  end
end
