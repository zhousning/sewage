class TaskReportsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @task_report = TaskReport.new
   
    #@task_reports = TaskReport.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = TaskReport.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :longitude => item.longitude,
       
        :latitude => item.latitude,
       
        :state => item.state,
       
        :question => item.question
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @task_report = TaskReport.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @task_report = TaskReport.new
    
  end
   

   
  def create
    @task_report = TaskReport.new(task_report_params)
     
    if @task_report.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @task_report = TaskReport.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @task_report = TaskReport.find(iddecode(params[:id]))
   
    if @task_report.update(task_report_params)
      redirect_to task_report_path(idencode(@task_report.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @task_report = TaskReport.find(iddecode(params[:id]))
   
    @task_report.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def task_report_params
      params.require(:task_report).permit( :longitude, :latitude, :state, :question , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
  
end

