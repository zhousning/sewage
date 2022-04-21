class WxTasksController < ApplicationController
  skip_before_action :verify_authenticity_token

   
  def index
    @tasks = @factory.tasks.all.page( params[:page]).per( Setting.systems.per_page )
  end
   

  def query_all 
    wxuser = WxUser.find_by(:openid => params[:id])
    @factory = wxuser.factory

    #items = @factory.tasks.where(['task_date > ? and state = ?', Date.yesterday, Setting.states.ongoing])
    items = @factory.tasks.where(['task_date > ? ', Date.yesterday])
   
    obj = []
    items.each do |item|
      inspectors = item.wx_users
      arr = []
      inspectors.each do |ispt|
        arr << ispt.name + ispt.phone
      end
      obj << {
        #:factory => idencode(factory.id),
        :task_id => item.id,
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

    #items = @factory.tasks.where(['state = ?', Setting.states.completed])
    items = @factory.tasks.where(['task_date < ? ', Date.today])
   
    obj = []
    items.each do |item|
      inspectors = item.wx_users
      arr = []
      inspectors.each do |ispt|
        arr << ispt.name + ispt.phone
      end
      obj << {
        #:factory => idencode(factory.id),
        :task_id => item.id,
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
    #items = @factory.tasks.where(['task_date = ? and state = ?', Date.today, Setting.states.ongoing])
    items = @factory.tasks.where(['task_date = ? ', Date.today])
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

  def report_create 
    device_id = params[:site_id].to_i
    task_id = params[:task_id].to_i
    longitude = params[:longitude]
    latitude = params[:latitude]
    state = params[:state]
    question = params[:question]
    imgs = params[:imgs].join(',')
    wxuser = WxUser.find_by(:openid => params[:id])
    @factory = wxuser.factory
    @device = @factory.devices.find(iddecode(device_id))
    @task = @factory.tasks.find(iddecode(task_id))

    @task_report = TaskReport.new(:task => @task, :wx_user => wxuser, :device => @device, :longitude => longitude, :latitude => latitude, :question => question, :state => state, :img => imgs) 

    if @task_report.save
      respond_to do |f|
        f.json{ render :json => {:state => 'success'}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end
   
  def task_info 
    task_id = params[:task_id].to_i
    wxuser = WxUser.find_by(:openid => params[:id])
    @task = wxuser.tasks.find(task_id)

    arr = []
    @task.wx_users.each do |ispt|
      arr << ispt.name + ispt.phone
    end
    task = {:task_date => @task.task_date, :desc => @task.des, :inspectors => arr}

    reports = [] 
    inspectors = []
    @task.task_reports.order('created_at DESC').each do |rep|
      user = rep.wx_user
      inspectors << user.name + ' ' + rep.created_at.strftime('%Y-%m-%d %H:%M:%S')
      imgs = rep.img.split(',')
      img_arr = []
      imgs.each do |img|
        img_arr << Setting.systems.host + img
      end
      reports << {
        name: user.name,
        avatar: user.avatarurl,
        time: rep.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        question: rep.question,
        state: rep.state,
        imgs: img_arr 
      }
    end
   
    respond_to do |f|
      f.json{ render :json => {:task => task, :inspectors => inspectors, :reports => reports}.to_json}
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

