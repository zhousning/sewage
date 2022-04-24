class TaskLog < ActiveRecord::Base
  belongs_to :task
  belongs_to :wx_user

  has_one :gdtrace


end
