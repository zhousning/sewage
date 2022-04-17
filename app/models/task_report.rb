class TaskReport < ActiveRecord::Base




  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true



  belongs_to :task
  belongs_to :wx_user
  belongs_to :device



end
