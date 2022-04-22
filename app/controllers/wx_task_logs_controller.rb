class WxTaskLogsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def task_start
    wxuser = WxUser.find_by(:openid => params[:id])
    @task = wxuser.tasks.find(params[:task_id])
    @task_log = TaskLog.new(:task => @task, :wx_user => wxuser, :start_time => Time.now)

    if @task_log.save!
      wxuser.task_working
      respond_to do |f|
        f.json{ render :json => {:state => 'success', :task_log_id => @task_log.id}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end

  def task_end
    wxuser = WxUser.find_by(:openid => params[:id])
    @task_log = TaskLog.where(:task_id => params[:task_id], :wx_user_id => wxuser.id, :id => params[:task_log_id]).first 

    if @task_log.update_attributes!(:end_time => Time.now)
      wxuser.task_pending
      respond_to do |f|
        f.json{ render :json => {:state => 'success'}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end
end
