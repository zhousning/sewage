class Gdservice < ActiveRecord::Base






  has_many :gdteminals, :dependent => :destroy
  accepts_nested_attributes_for :gdteminals, reject_if: :all_blank, allow_destroy: true



end
