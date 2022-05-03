class TasksController < ApplicationController
  layout "application_control_map"
  before_filter :authenticate_user!
  before_action :my_factory
  authorize_resource

   
  def index
    @tasks = @factory.tasks.all.order('task_date DESC').page( params[:page]).per( Setting.systems.per_page )
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
    @wx_users = @task.wx_users
    @task_reports = @task.task_reports.order('created_at DESC')
    #gon.car = view_context.image_tag('car.png')
    gon.center = [@factory.lnt, @factory.lat]
    gon.car = ActionController::Base.helpers.image_url('car.png')
    gon.blocal = ActionController::Base.helpers.image_url('blocal.png')
    gon.rlocal = ActionController::Base.helpers.image_url('rlocal.png')
   
    obj = []
    @task_reports.each do |rep|
      user = rep.wx_user
      device = rep.device
      time = rep.created_at.strftime('%H:%M:%S')
      obj << {time: time, site: device.name, name: user.name, avatar: user.avatarurl, phone: user.phone, longitude: rep.longitude, latitude: rep.latitude, state: rep.state} 
    end
    gon.obj = obj
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
    wx_users = !params[:wx_users].nil? ? @wx_users.find(params[:wx_users]) : [] 
    result = []
    wx_users.each do |u|
      result << u.name unless u.tasks.where(:task_date => task_params[:task_date]).blank?
    end
    if !result.blank?
      @error = result
      render :new
    else
      @task.wx_users = wx_users
       
      if @task.save
        redirect_to :action => :index
      else
        render :new
      end
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
    @wx_user_selector = []
    @wx_users = @factory.wx_users
    wx_users = @wx_users.find(params[:wx_users]) || []
    wx_users.each do |u|
      @wx_user_selector << u.id
    end

    @task = @factory.tasks.find(iddecode(params[:id]))
    result = []
    wx_users.each do |u|
      task_exist = u.tasks.where(:task_date => @task.task_date).first
      result << u.name if task_exist && task_exist.id != @task.id
    end

    if !result.blank?
      @error = result
      render :edit
    else
      @task.wx_users = wx_users
      if @task.update(task_params)
        redirect_to edit_factory_task_path(idencode(@factory.id), idencode(@task.id)) 
      else
        render :edit
      end
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

