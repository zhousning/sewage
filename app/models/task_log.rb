class TaskLog < ActiveRecord::Base
  belongs_to :task
  belongs_to :wx_user


end
