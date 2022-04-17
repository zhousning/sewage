# == Schema Information
#
# Table name: wx_users
#
#  id         :integer          not null, primary key
#  unionid    :string           default(""), not null
#  openid     :string           default(""), not null
#  nickname   :string           default(""), not null
#  avatarurl  :string           default(""), not null
#  gender     :string           default(""), not null
#  city       :string           default(""), not null
#  province   :string           default(""), not null
#  country    :string           default(""), not null
#  language   :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WxUser < ActiveRecord::Base
  belongs_to :factory

  has_many :task_wxusers, :dependent => :destroy
  has_many :tasks, :through => :task_wxusers

  has_many :task_reports

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
