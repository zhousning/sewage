class TasksController < ApplicationController
  layout "application_control_map"
  before_filter :authenticate_user!
  before_action :my_factory
  #authorize_resource

   
  def index
    @tasks = @factory.tasks.all.page( params[:page]).per( Setting.systems.per_page )
  end
   

  def query_all 
    items = Task.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :task_date => item.task_date,
       
        :des => item.des
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @task = @factory.tasks.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @task = Task.new
    @wx_user_selector = []
    @wx_users = @factory.wx_users
  end
   

   
  def create
    @wx_user_selector = []
    @wx_users = @factory.wx_users
    @task = Task.new(task_params)
    @task.factory = @factory
    wx_users = params[:wx_users]
    @wx_users = [] 
    @wx_users = @factory.wx_users.find(wx_users) if wx_users
    @task.wx_users = @wx_users
     
    if @task.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
    @task = @factory.tasks.find(iddecode(params[:id]))
    @wx_users = @factory.wx_users
    wx_users = @task.wx_users
    @wx_user_selector = []
    wx_users.each do |u|
      @wx_user_selector << u.id
    end
  end
   

   
  def update
    @task = @factory.tasks.find(iddecode(params[:id]))
    wx_users = params[:wx_users]
    @wx_users = [] 
    @wx_users = @factory.wx_users.find(wx_users) if wx_users
    @task.wx_users = @wx_users
   
    if @task.update(task_params)
      redirect_to edit_factory_task_path(idencode(@factory.id), idencode(@task.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @task = @factory.tasks.find(iddecode(params[:id]))
   
    @task.destroy
    redirect_to :action => :index
  end
   
  def finish 
    @task = @factory.tasks.find(iddecode(params[:id]))
    @task.completed
    redirect_to :action => :index
  end

  def ongoing 
    @task = @factory.tasks.find(iddecode(params[:id]))
    @task.ongoing
    redirect_to :action => :index
  end
  
  private
    def task_params
      params.require(:task).permit( :task_date, :des , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
  
end

