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
  
  
  
end

