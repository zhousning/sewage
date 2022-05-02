class GdteminalsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  before_action :find_gdservice
  #authorize_resource

   
  def index
    url = "https://tsapi.amap.com/v1/track/terminal/list?key=" + Setting.systems.gdkey + "&sid=" + @gdservice.sid
    res = RestClient.get url
    obj = JSON.parse(res)
    if obj["errcode"] == 10000
      obj['data']['results'].each do |res|
        tid = res['tid']
        name = res['name']
        gdtemianl = @gdservice.gdteminals.where(:name => name, :tid => tid).first
        if gdtemianl.nil?
          Gdteminal.create!(:name => name, :tid => tid, :gdservice => @gdservice)
        end
      end
    end
    @gdteminals = @gdservice.gdteminals.all.page( params[:page]).per( Setting.systems.per_page )
  end
   

  def query_all 
    items = Gdteminal.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.name,
       
        :tid => item.tid,
       
        :desc => item.desc
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @gdteminal = Gdteminal.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @gdteminal = Gdteminal.new
    
  end
   

   
  def create
    url = "https://tsapi.amap.com/v1/track/terminal/add"
    params = {
      key: @gdservice.key,
      sid: @gdservice.sid,
      name: gdteminal_params[:name]
    }
    res = RestClient.post url, params
    obj = JSON.parse(res)
    if obj["errcode"] == 10000
      tid = obj['data']['tid']
      name = obj['data']['name']
      @gdteminal = Gdteminal.new(:tid => tid, :name => name, :gdservice => @gdservice)
      if @gdteminal.save
        redirect_to :action => :index
      else
        render :new
      end
    else
      @gdteminal = Gdteminal.new(gdteminal_params)
      flash[:errmsg] = obj["errcode"].to_s + '  ' + obj['errmsg']
      render :new
    end
  end
   

   
  def edit
   
    @gdteminal = Gdteminal.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @gdteminal = Gdteminal.find(iddecode(params[:id]))
   
    if @gdteminal.update(gdteminal_params)
      redirect_to gdteminal_path(idencode(@gdteminal.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @gdteminal = Gdteminal.find(iddecode(params[:id]))
   
    @gdteminal.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def gdteminal_params
      params.require(:gdteminal).permit( :name)
    end
  
    def find_gdservice
      @gdservice = Gdservice.find(iddecode(params[:gdservice_id].to_i))
    end
  
  
end

