class Gdteminal < ActiveRecord::Base





  belongs_to :wx_user

  belongs_to :gdservice


  has_many :gdtraces, :dependent => :destroy
  accepts_nested_attributes_for :gdtraces, reject_if: :all_blank, allow_destroy: true



end
