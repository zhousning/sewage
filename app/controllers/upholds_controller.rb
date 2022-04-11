class UpholdsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @factory = my_factory
    @uphold = Uphold.new
   
    @upholds = @factory.upholds.all.order('uphold_date DESC').page( params[:page]).per( Setting.systems.per_page )
   
  end
   
  def query_devices
    @factory = my_factory
    items = @factory.devices
    device = params[:device]
   
    results = []
    if device 
      items.each do |item|
        id = idencode(item.id)
        text = item.name + '-' + item.mdno  + '-' + item.idno

        obj_item = Hash.new 
        if id.to_s == device
          obj_item["selected"] = true
        end
        obj_item['id'] = id
        obj_item['text'] = text

        results << obj_item 
      end
    else
      items.each do |item|
        text = item.name + '-' + item.mdno  + '-' + item.idno
        results << {
          :id => idencode(item.id),
          :text => text,
        }
      end
    end
    obj = {
      "results": results
    }
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   

   
  def show
   
    @factory = my_factory
    @uphold = @factory.upholds.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @factory = my_factory
    @uphold = Uphold.new
    
  end
   

   
  def create
    @factory = my_factory
    @uphold = Uphold.new(uphold_params)

    @device = @factory.devices.find(iddecode(params[:device]))
    @uphold.factory = @factory
    @uphold.device = @device
     
    if @uphold.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @factory = my_factory
    @uphold = @factory.upholds.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @factory = my_factory
    @device = @factory.devices.find(iddecode(params[:device]))
    @uphold = @factory.upholds.find(iddecode(params[:id]))
    @uphold.device = @device
   
    if @uphold.update(uphold_params)
      redirect_to edit_factory_uphold_path(idencode(@factory.id), idencode(@uphold.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @factory = my_factory
    @uphold = @factory.upholds.find(iddecode(params[:id]))
   
    @uphold.destroy
    redirect_to :action => :index
  end
   

  private
    def uphold_params
      params.require(:uphold).permit( :uphold_date, :reason, :content, :cost, :avatar)
    end
  
  
  
end

