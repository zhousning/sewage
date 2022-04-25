class TaskLogsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @task_log = TaskLog.new
   
    #@task_logs = TaskLog.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = TaskLog.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :start_time => item.start_time,
       
        :end_time => item.end_time,
       
        :state => item.state
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end


  #start_stamp = Time.parse(inspect_date + " 00:00:00").to_i
  #end_stamp   = Time.parse(inspect_date + " 23:00:00").to_i
  def query_trace
    inspect_date = params[:search_date]
    inspector = iddecode(params[:inspector])
    @wx_user = WxUser.find(inspector)

    @task = @wx_user.tasks.where(:task_date => inspect_date).first
    @task_logs = @task.task_logs

    obj = []
    @task_logs.each do |log|
      puts log.id
      if log.gdtrace
        trid = log.gdtrace.trid
        start_time = log.start_time 
        end_time   = log.end_time
        #name = start_time.strftime('%Y-%m-%d %H:%M:%S') + ' -> ' + end_time.strftime('%Y-%m-%d %H:%M:%S')
        name = start_time.to_s + ' -> ' + end_time.to_s
        path = get_points(@wx_user, trid) 
        obj << {:name => name, :path => path} unless path.blank?
      end
    end

    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_latest_point
    @factory = current_user.factories.first
    #@task = @factory.tasks.where(:task_date => Date.today).first
    @task = @factory.tasks.where(:task_date => Date.new(2022,4,24)).first

    @wx_users = @task.wx_users

    obj = []
    @wx_users.each do |user|
      name = user.name
      point = latest_point(user) 
      obj << {name: name, point: point} unless point.blank?
    end

    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end


  #[123213,3123123]
  def latest_point(wxuser) 
    url = "https://tsapi.amap.com/v1/track/terminal/lastpoint"
    @gdteminal = wxuser.gdteminal
    @gdservice = @gdteminal.gdservice

    params = {
      key: @gdservice.key,
      sid: @gdservice.sid,
      tid: @gdteminal.tid,
      correction: 'n'
    }
    res = RestClient.get url, params: params
    obj = JSON.parse(res)
    puts '**************'
    puts obj
    puts '**************'
    point = []
    if obj["errcode"] == 10000
      point = obj['data']['location'].split(',')
      locatetime = obj['data']['locatetime']
    end
    point
  end

   
  def show
   
    @task_log = TaskLog.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @task_log = TaskLog.new
    
  end
   

   
  def create
    @task_log = TaskLog.new(task_log_params)
     
    if @task_log.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @task_log = TaskLog.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @task_log = TaskLog.find(iddecode(params[:id]))
   
    if @task_log.update(task_log_params)
      redirect_to task_log_path(idencode(@task_log.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @task_log = TaskLog.find(iddecode(params[:id]))
   
    @task_log.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def task_log_params
      params.require(:task_log).permit( :start_time, :end_time, :state)
    end
  
    #{"name":"北京 -> 乌鲁木齐","path":[[116.405289,39.904987],[116.406265,39.905015]]}
    def get_points(wxuser, trid) 
      url = "https://tsapi.amap.com/v1/track/terminal/trsearch"
      @gdteminal = wxuser.gdteminal
      @gdservice = @gdteminal.gdservice

      params = {
        key: @gdservice.key,
        sid: @gdservice.sid,
        tid: @gdteminal.tid,
        trid: trid
      }
      res = RestClient.get url, params: params
      obj = JSON.parse(res)
      #puts '**************'
      #puts obj
      #puts '**************'
      locations = []
      if obj["errcode"] == 10000
        points = obj['data']['tracks'][0]['points']
        points.each do |point|
          locations << point['location'].split(',')
        end
      end
      locations
    end
  
  
end

