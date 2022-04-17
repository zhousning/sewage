class CreateTaskWxusers < ActiveRecord::Migration
  def change
    create_table :task_wxusers do |t|
      t.integer :task_id
      t.integer :wx_user_id

      t.timestamps null: false
    end
  end
end
