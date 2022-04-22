class GdservicesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    url = "https://tsapi.amap.com/v1/track/service/list?key=" + Setting.systems.gdkey
    res = RestClient.get url
    obj = JSON.parse(res)
    if obj["errcode"] == 10000
      obj['data']['results'].each do |res|
        sid = res['sid']
        name = res['name']
        gdservice = Gdservice.where(:name => name, :sid => sid, :key => Setting.systems.gdkey).first
        if gdservice.nil?
          Gdservice.create!(:name => name, :sid => sid, :key => Setting.systems.gdkey)
        end
      end
    end
    @gdservices = Gdservice.all
  end
   

  def query_all 
    items = Gdservice.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :key => item.key,
       
        :name => item.name,
       
        :sid => item.sid
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   
  def show
   
    @gdservice = Gdservice.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @gdservice = Gdservice.new
    
  end
   

   
  def create
    url = "https://tsapi.amap.com/v1/track/service/add"
    params = {
      key: gdservice_params[:key],
      name: gdservice_params[:name]
    }
    res = RestClient.post url, params
    obj = JSON.parse(res)
    if obj["errcode"] == 10000
      sid = obj['data']['sid']
      name = obj['data']['name']
      @gdservice = Gdservice.new(format_params(gdservice_params, sid, name))
      if @gdservice.save
        redirect_to :action => :index
      else
        render :new
      end
    else
      @gdservice = Gdservice.new(gdservice_params)
      flash[:errmsg] = obj["errcode"].to_s + '  ' + obj['errmsg']
      render :new
    end
  end

  def format_params(old_params, sid, name)
    new_params = old_params
    new_params[:sid] = old_params[:sid]
    new_params[:name] = old_params[:name]
    new_params
  end
   

   
  def edit
   
    @gdservice = Gdservice.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @gdservice = Gdservice.find(iddecode(params[:id]))
   
    if @gdservice.update(gdservice_params)
      redirect_to gdservice_path(idencode(@gdservice.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @gdservice = Gdservice.find(iddecode(params[:id]))
   
    @gdservice.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def gdservice_params
      params.require(:gdservice).permit( :key, :name, :sid)
    end
  
  
  
end

