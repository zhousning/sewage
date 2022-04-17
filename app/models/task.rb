class Task < ActiveRecord::Base
  belongs_to :factory

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true


  has_many :task_wxusers, :dependent => :destroy
  has_many :wx_users, :through => :task_wxusers


  has_many :task_reports, :dependent => :destroy
  accepts_nested_attributes_for :task_reports, reject_if: :all_blank, allow_destroy: true



end
