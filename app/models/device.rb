class Device < ActiveRecord::Base

  dragonfly_accessor :qrcode do
    storage_options :opts_for_storage
  end

  def opts_for_storage
    path = '/devices/fct' + self.factory.id.to_s + '/' + self.id.to_s
    { path: path}
  end

  mount_uploader :avatar, EnclosureUploader


  has_many :upholds, :dependent => :destroy
  accepts_nested_attributes_for :upholds, reject_if: :all_blank, allow_destroy: true


  belongs_to :factory

  #不在这里使用异步会出问题做个警示
  #after_commit :set_qrcode
  #def set_qrcode
  #  puts ' 1 model device'
  #  #DeviceQrcodeWorker.perform_async(self.id)
  #end

end
