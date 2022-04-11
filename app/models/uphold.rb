class Uphold < ActiveRecord::Base

  mount_uploader :avatar, EnclosureUploader






  belongs_to :device


  belongs_to :factory



end
