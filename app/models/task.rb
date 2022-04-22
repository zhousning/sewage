class Task < ActiveRecord::Base
  belongs_to :factory

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true

  has_many :task_logs, :dependent => :destroy
  accepts_nested_attributes_for :task_logs, reject_if: :all_blank, allow_destroy: true

  has_many :task_wxusers, :dependent => :destroy
  has_many :wx_users, :through => :task_wxusers


  has_many :task_reports, :dependent => :destroy
  accepts_nested_attributes_for :task_reports, reject_if: :all_blank, allow_destroy: true


 STATESTR = %w(ongoing completed)
  STATE = [Setting.states.ongoing, Setting.states.completed]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.states.ongoing, 
    STATESTR[5] => Setting.states.completed
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def ongoing 
    update_attribute :state, Setting.states.ongoing
  end

  def completed
    update_attribute :state, Setting.states.completed
  end

end
