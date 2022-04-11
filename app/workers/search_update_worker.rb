class SearchUpdateWorker
  include Sidekiq::Worker

  def perform
    CtgMtrl.reindex
    #WaterItem.reindex
    #SewageItem.reindex
    #ProjectItem.reindex
    #RepairPart.reindex
    #Emergency.reindex
    #Stuff.reindex
  end

end
