class PatrolersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @factory = my_factory
    @patroler = Patroler.new
    @users = @factory.users
    @patrolers = []
    @users.each do |user|
      @patrolers << user if user.has_role?(Setting.roles.role_patroler)
    end
  end
   

  def query_all 
    items = Patroler.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.name,
       
        :phone => item.phone,
       
        :password => item.password
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @patroler = Patroler.find(iddecode(params[:id]))
   
  end
   

   
  #def new
  #  @patroler = Patroler.new
  #  
  #end
   

   
  def create
    @factory = my_factory
    @role_patroler = Role.where(:name => Setting.roles.role_patroler).first

    resource = User.find_for_database_authentication(phone: patroler_params[:phone])

    if resource.nil? 
      user = User.new(:name => patroler_params[:name], :phone => patroler_params[:phone], :password => patroler_params[:password], :password_confirmation => patroler_params[:password], :factories => [@factory], :roles => [@role_patroler])
      user.save!
    end

    redirect_to :action => :index
  end
   

   
  def edit
   
    @factory = my_factory
    @user = @factory.users.find(iddecode(params[:id]))
    @patroler = Patroler.new(:id => @user.id, :phone => @user.phone, :name => @user.name) 
   
  end
   

   
  #功能不完善
  def patroler_update
    @factory = my_factory
    user = @factory.users.find(iddecode(params[:id]))
   
    #user_cache = User.find_for_database_authentication(phone: patroler_params[:phone])

    if !user.nil? && !patroler_params[:password].blank? 
      if user.update_attributes!(:name => patroler_params[:name], :phone => patroler_params[:phone], :password => patroler_params[:password], :password_confirmation => patroler_params[:password])
        redirect_to factory_patrolers_path(idencode(@factory.id)) 
      else
        render :edit
      end
    else
      render :edit
    end
  end
  

  private
    def patroler_params
      params.require(:patroler).permit( :name, :phone, :password , :avatar)
    end
  
  
  
end

