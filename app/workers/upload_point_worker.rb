class UploadPointWorker
  include Sidekiq::Worker

  #location_dir = File.join(Rails.root, "public", "locationlog")
  #Dir::mkdir(location_dir) unless File.directory?(location_dir)
  #@upload_error = Logger.new( location_dir + '/upload_location.log')
  #if obj["errcode"] != 10000
  #  errorpoints = obj['data']['errorpoints']
  #  @upload_error.error errorpoints
  #end
  def perform(id, task_log_id, points)
    wxuser = WxUser.find_by(:openid => id)
    task_log = wxuser.task_logs.find(task_log_id)
    @gdtrace = task_log.gdtrace
    @gdteminal = wxuser.gdteminal
    @gdservice = @gdteminal.gdservice
    start_flag = 0
    end_flag   = 80

    puts '777777777777'
    puts points
    puts '777777777777'
    array_slice(points, start_flag, end_flag, @gdservice, @gdteminal, @gdtrace)

  end 


  private
    def array_slice(arr, start_flag, end_flag, gdservice, gdteminal, gdtrace)
      url = "https://tsapi.amap.com/v1/track/point/upload"
      new_array = arr.nil? ? [] : arr[start_flag..end_flag]
      if !new_array.blank?
        points = new_array.to_json
        params = {
          key: gdservice.key,
          sid: gdservice.sid,
          tid: gdteminal.tid,
          trid: gdtrace.trid,
          points: points
        }
        res = RestClient.post url, params
        obj = JSON.parse(res)

        start_flag = start_flag + end_flag
        end_flag = end_flag + end_flag

        array_slice(new_array, start_flag, end_flag, gdservice, gdteminal, gdtrace)
      end
    end
  

end
