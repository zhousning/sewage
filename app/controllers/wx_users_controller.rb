require 'restclient'
require 'json'

class WxUsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update 
    wxuser = WxUser.find_by(:openid => params[:id])
    respond_to do |f|
      if wxuser.update(wx_user_params)
        f.json { render :json => {:status => "wxuser update success" }.to_json}
      else
        f.json { render :json => {:status => "wxuser update error"}.to_json}
      end
    end
  end

  def get_userid
    encryptedData = params[:encryptedData]
    iv = params[:iv]
    url = "https://api.weixin.qq.com/sns/jscode2session"
    data = {
      appid: "wxb8a77e86da1077f5", 
      secret: "72a4d35d55f59e29a66fc4ba0c3a2d40",
      js_code: params[:code].to_s,
      grant_type: 'authorization_code'
    }
    response = RestClient.get url, params: data, :accept => :json
    body = JSON.parse(response.body)
    unless body["errcode"]
      openid = body["openid"]
      session_key = body["session_key"]

      target = WxUser.find_by(:openid => openid)
      unless target
        wxuser = WxUser.new(:openid => openid)
        wxuser.save
      end

      respond_to do |f|
        f.json { render :json => { :openId => openid }.to_json }
      end
    else
      respond_to do |f|
        f.json { render :json => { :openId => body }.to_json }
      end
    end
  end

  def fcts
    objs = []
    fcts = Factory.all
    fcts.each do |fct|
      objs << fct.name
    end
    respond_to do |f|
      f.json { render :json => objs.to_json }
    end
  end

  def set_fct
    fct = Factory.find_by(:name => params[:fct])
    wxuser = WxUser.find_by(:openid => params[:id])
    respond_to do |f|
      if wxuser.update_attributes(:state => Setting.states.ongoing, :factory => fct, :name => params[:name], :phone => params[:phone] )
        f.json { render :json => {:status => "success" }.to_json}
      else
        f.json { render :json => {:status => "error"}.to_json}
      end
    end
  end

  def status
    wxuser = WxUser.find_by(:openid => params[:id])
    respond_to do |f|
      if wxuser.state == Setting.states.ongoing
        f.json { render :json => {:status => Setting.states.ongoing }.to_json}
      else
        f.json { render :json => {:status => Setting.states.completed, :name => wxuser.name, :phone => wxuser.phone, :fct => wxuser.factory.name}.to_json}
      end
    end
  end

  private
    def wx_user_params
      params.require(:wx_user).permit(:nickname, :avatarurl, :gender, :city, :province, :country, :language, :name, :phone)
    end                                  
end