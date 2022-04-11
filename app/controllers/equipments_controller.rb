class EquipmentsController < ApplicationController

  def fcts 
    items = Factory.all
    obj = []
    items.each do |item|
      obj << {
        :factory => idencode(item.id),
        :name => item.name,
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_all 
    @factory = Factory.find(iddecode(params[:factory_id]))
    items = @factory.devices
   
    obj = []
    items.each do |item|
      obj << {
        :factory => idencode(@factory.id),
        :id => idencode(item.id),
        :idno => item.idno,
        :name => item.name,
        :mdno => item.mdno,
        :unit => item.unit,
        :state => item.state,
        :pos => item.pos
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def upholds 
    @factory = Factory.find(iddecode(params[:factory_id]))
    @device = @factory.devices.find(iddecode(params[:id]))
    items = @device.upholds

    obj = []
    items.each do |item|
      obj << {
        :date => item.uphold_date,
        :cost => item.cost,
        :reason => item.reason,
        :img => item.avatar_url,
        :content => item.content
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
   
  end
   

end
