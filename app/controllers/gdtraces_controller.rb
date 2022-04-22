class GdtracesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  before_action :find_gdteminal
  #authorize_resource

   
  def index
    url = "https://tsapi.amap.com/v1/track/terminal/list?key=" + Setting.systems.gdkey + "&sid=" + @gdteminal.sid
    res = RestClient.get url
    obj = JSON.parse(res)
    if obj["errcode"] == 10000
      obj['data']['results'].each do |res|
        tid = res['tid']
        name = res['name']
        gdtemianl = @gdteminal.gdteminals.where(:name => name, :tid => tid).first
        if gdtemianl.nil?
          Gdteminal.create!(:name => name, :tid => tid, :gdteminal => @gdteminal)
        end
      end
    end
    @gdteminals = @gdteminal.gdteminals.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = Gdtrace.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :trid => item.trid,
       
        :trname => item.trname
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @gdtrace = Gdtrace.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @gdtrace = Gdtrace.new
    
  end
   

   
  def create
    url = "https://tsapi.amap.com/v1/track/trace/add"
    service = @gdteminal.gdservice
    params = {
      key: service.key,
      sid: service.sid,
      tid: @gdteminal.tid
    }
    res = RestClient.post url, params
    obj = JSON.parse(res)
    if obj["errcode"] == 10000
      trid = obj['data']['trid']
      trname = obj['data']['trname']
      @gdtrace = Gdtrace.new(:trid => trid, :trname => trname, :gdteminal => @gdteminal)
      if @gdtrace.save
        redirect_to :action => :index
      else
        render :new
      end
    else
      @gdtrace = Gdtrace.new(gdteminal_params)
      flash[:errmsg] = obj["errcode"].to_s + '  ' + obj['errmsg']
      render :new
    end
  end
   

   
  def edit
   
    @gdtrace = Gdtrace.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @gdtrace = Gdtrace.find(iddecode(params[:id]))
   
    if @gdtrace.update(gdtrace_params)
      redirect_to gdtrace_path(idencode(@gdtrace.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @gdtrace = Gdtrace.find(iddecode(params[:id]))
   
    @gdtrace.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def gdtrace_params
      params.require(:gdtrace).permit( :trid, :trname)
    end
  
    def find_gdteminal
      @gdteminal = Gdteminal.find(iddecode(params[:gdteminal_id].to_i))
    end
  
  
end

