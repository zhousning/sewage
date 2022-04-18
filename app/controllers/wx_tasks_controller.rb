class WxTasksController < ApplicationController
  skip_before_action :verify_authenticity_token

   
  def index
    @tasks = @factory.tasks.all.page( params[:page]).per( Setting.systems.per_page )
  end
   

  def query_all 
    wxuser = WxUser.find_by(:openid => params[:id])
    @factory = wxuser.factory

    items = @factory.tasks.where(['task_date > ? and state = ?', Date.yesterday, Setting.states.ongoing])
   
    obj = []
    items.each do |item|
      inspectors = item.wx_users
      arr = []
      inspectors.each do |ispt|
        arr << ispt.name + ispt.phone
      end
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :task_date => item.task_date,
       
        :desc => item.des,

        :inspectors => arr
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_finish
    wxuser = WxUser.find_by(:openid => params[:id])
    @factory = wxuser.factory

    items = @factory.tasks.where(['state = ?', Setting.states.completed])
   
    obj = []
    items.each do |item|
      inspectors = item.wx_users
      arr = []
      inspectors.each do |ispt|
        arr << ispt.name + ispt.phone
      end
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :task_date => item.task_date,
       
        :desc => item.des,

        :inspectors => arr
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def basic_card 
    #fct_id = params[:fct_id]
    device_id = params[:device_id].to_i
    wxuser = WxUser.find_by(:openid => params[:id])
    @factory = wxuser.factory
    @device = @factory.devices.find(iddecode(device_id))

    obj = []
    items = @factory.tasks.where(['task_date = ? and state = ?', Date.today, Setting.states.ongoing])
    items.each do |item|
      obj << {
        :task_id => idencode(item.id),
        :task_date => item.task_date,
      }
    end
    device = {:id => idencode(@device.id), :name => @device.name} 
    respond_to do |f|
      f.json{ render :json => {:device => device, :tasks => obj}.to_json}
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
   

  
  private
    def task_params
      params.require(:task).permit( :task_date, :des , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
  
end

