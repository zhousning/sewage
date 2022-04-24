class WxTaskLogsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def task_start
    wxuser = WxUser.find_by(:openid => params[:id])
    @task = wxuser.tasks.find(params[:task_id])
    @task_log = TaskLog.new(:task => @task, :wx_user => wxuser, :start_time => Time.now)

    if @task_log.save!
      trace_id = create_gdtrace(wxuser, @task_log)
      if trace_id
        wxuser.task_working
        respond_to do |f|
          f.json{ render :json => {:state => 'success', :task_log_id => @task_log.id, :trace_id => trace_id}.to_json}
        end
      else
        respond_to do |f|
          f.json{ render :json => {:state => 'error'}.to_json}
        end
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end

  def task_end
    points = params[:points]
    wxuser = WxUser.find_by(:openid => params[:id])
    @task_log = TaskLog.where(:task_id => params[:task_id], :wx_user_id => wxuser.id, :id => params[:task_log_id]).first 

    if @task_log.update_attributes!(:end_time => Time.now)
      wxuser.task_pending
      upload_position(wxuser, @task_log, points)
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end

  #params openid  task_log_id
  def accept_points
    points = params[:points]
    wxuser = WxUser.find_by(:openid => params[:id])
    task_log = wxuser.task_logs.find(params[:task_log_id])
    upload_position(wxuser, task_log, points)
  end
  
  def upload_position(wxuser, task_log, points) 
    location_dir = File.join(Rails.root, "public", "locationlog")
    Dir::mkdir(location_dir) unless File.directory?(location_dir)
    @upload_error = Logger.new( location_dir + '/upload_location.log')

    url = "https://tsapi.amap.com/v1/track/point/upload"
    @gdtrace = task_log.gdtrace
    @gdteminal = wxuser.gdteminal
    @gdservice = @gdteminal.gdservice


    points = points.to_json

    params = {
      key: @gdservice.key,
      sid: @gdservice.sid,
      tid: @gdteminal.tid,
      trid: @gdtrace.trid,
      points: points
    }
    res = RestClient.post url, params
    obj = JSON.parse(res)
    puts '**************'
    puts obj
    puts '**************'
    trace_id = nil 
    if obj["errcode"] != 10000
      errorpoints = obj['data']['errorpoints']
      @upload_error.error errorpoints
    end

    respond_to do |f|
      f.json{ render :json => {:state => 'success'}.to_json}
    end
  end

  private 
    def create_gdtrace(wxuser, task_log)
      url = "https://tsapi.amap.com/v1/track/trace/add"
      @gdteminal = wxuser.gdteminal
      @gdservice = @gdteminal.gdservice
      params = {
        key: @gdservice.key,
        sid: @gdservice.sid,
        tid: @gdteminal.tid
      }
      res = RestClient.post url, params
      obj = JSON.parse(res)
      puts '..........'
      puts obj
      puts '..........'

      trace_id = nil 
      if obj["errcode"] == 10000
        trid = obj['data']['trid']
        #trname = obj['data']['trname']
        @gdtrace = Gdtrace.new(:trid => trid, :gdteminal => @gdteminal, :task_log => task_log)
        if @gdtrace.save
          trace_id = @gdtrace.trid
        end
      end
      trace_id
    end

end
