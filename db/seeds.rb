# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role = Role.create(:name => Setting.roles.super_admin)

admin_permissions = Permission.create(:name => Setting.permissions.super_admin, :subject_class => Setting.admins.class_name, :action => "manage")

role.permissions << admin_permissions

user = User.new(:phone => Setting.admins.phone, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)
user.save!

user.roles = []
user.roles << role

AdminUser.create!(:phone => Setting.admins.phone, :email => Setting.admins.email, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)

@user = User.create!(:phone => "15763703188", :password => "15763703188", :password_confirmation => "15763703188")

###区分厂区和集团用户是为了sidebar显示
@role_fct = Role.where(:name => Setting.roles.role_fct).first
@role_grp = Role.where(:name => Setting.roles.role_grp).first

@role_position = Role.where(:name => Setting.roles.role_position).first
@role_device    = Role.where(:name => Setting.roles.role_device).first
@role_task    = Role.where(:name => Setting.roles.role_task).first
@role_inspector    = Role.where(:name => Setting.roles.role_inspector).first
@role_beidou    = Role.where(:name => Setting.roles.role_beidou).first

##厂区管理者
@fctmgn = [@role_fct, @role_position, @role_device, @role_task, @role_inspector]
##集团管理者
@grp_mgn = [@role_grp, @role_beidou] 

@lssw = Company.create!(:area => "梁山县", :name => "梁山农污")
@jiax = Company.create!(:area => "嘉祥县", :name => "嘉祥农污")
@wens = Company.create!(:area => "汶上县", :name => "汶上农污")
@qufu = Company.create!(:area => "曲阜市", :name => "曲阜农污")
@yanz = Company.create!(:area => "兖州区", :name => "兖州农污")
@zouc = Company.create!(:area => "邹城市", :name => "邹城农污")
@renc = Company.create!(:area => "任城区", :name => "任城农污")
@beih = Company.create!(:area => "太白湖新区", :name => "北湖农污")
@jinx = Company.create!(:area => "微山县", :name => "微山农污")

@lssw  = Factory.create!(:area => "梁山县",     :name => "梁山农污",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@zcsw  = Factory.create!(:area => "邹城市",     :name => "邹城农污",       :company => @zouc, :lnt => 117.007406, :lat => 35.402536, :design => 80000)
@jxsw  = Factory.create!(:area => "嘉祥县",     :name => "嘉祥农污",       :company => @jiax, :lnt => 116.342308, :lat => 35.40794, :design => 80000)
@wssw  = Factory.create!(:area => "汶上县",     :name => "汶上农污",       :company => @wens, :lnt => 116.497277, :lat => 35.711891, :design => 40000)
@qfsw  = Factory.create!(:area => "曲阜市",     :name => "曲阜农污",       :company => @qufu, :lnt => 116.986212, :lat => 35.581933, :design => 40000)
@yzsw  = Factory.create!(:area => "兖州区",     :name => "兖州农污",       :company => @yanz, :lnt => 116.78365, :lat => 35.551938, :design => 60000)
@rcws  = Factory.create!(:area => "任城区",     :name => "任城农污",     :company => @renc, :lnt => 116.605763, :lat => 35.444226, :design => 20000)
@bhws  = Factory.create!(:area => "太白湖新区", :name => "北湖农污",     :company => @beih, :lnt => 116.595498, :lat => 35.349988, :design => 20000)
@dsmt  = Factory.create!(:area => "微山县",     :name => "微山农污", :company => @jinx, :lnt => 117.129188,  :lat => 34.806657, :design => 20000)

User.create!(:phone => "053718180101", :password => "yzsw0101", :password_confirmation => "yzsw0101", :name => "兖州农污管理者",     :roles => @fctmgn,    :factories => [@yzsw])
User.create!(:phone => "053737080101", :password => "lssw0101", :password_confirmation => "lssw0101", :name => "梁山农污管理者",     :roles => @fctmgn,    :factories => [@lssw])
User.create!(:phone => "053766880909", :password => "zcsw0909", :password_confirmation => "zcsw0909", :name => "邹城农污管理者",     :roles => @fctmgn,    :factories => [@zcsw])
User.create!(:phone => "053711114567", :password => "jxsw4567", :password_confirmation => "jxsw4567", :name => "嘉祥农污管理者",     :roles => @fctmgn,    :factories => [@jxsw])
User.create!(:phone => "053766885858", :password => "wssw5858", :password_confirmation => "wssw5858", :name => "汶上农污管理者",     :roles => @fctmgn,    :factories => [@wssw])
User.create!(:phone => "053798983708", :password => "qfsw3708", :password_confirmation => "qfsw3708", :name => "曲阜农污管理者",     :roles => @fctmgn,    :factories => [@qfsw]) 
User.create!(:phone => "053766889999", :password => "rcws9999", :password_confirmation => "rcws9999", :name => "任城农污管理者",     :roles => @fctmgn,    :factories => [@rcws]) 
User.create!(:phone => "053756786789", :password => "bhws6789", :password_confirmation => "bhws6789", :name => "北湖农污管理者",     :roles => @fctmgn,    :factories => [@bhws]) 
User.create!(:phone => "053766881234", :password => "dsmt6688", :password_confirmation => "dsmt6688", :name => "微山农污管理者",     :roles => @fctmgn,    :factories => [@dsmt])



all_factories = Factory.all
user.factories << all_factories

#集团运营
#grp_opt = User.create!(:phone => "15763703588", :password => "swjt3588", :password_confirmation => "swjt3588", :name => "水务集团运营", :roles => @grp_opt, :factories => all_factories)

#集团管理
grp_mgn = User.create!(:phone => "1236688", :password => "swjt6688", :password_confirmation => "swjt6688", :name => "水务集团管理者", :roles => @grp_mgn, :factories => all_factories)


#User.create!(:phone => "053769699898", :password => "lssw9898", :password_confirmation => "lssw9898", :name => "梁山农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@lssw])
#User.create!(:phone => "053769693708", :password => "lssw3708", :password_confirmation => "lssw3708", :name => "梁山农污站点管理员", :roles => @fct_dvmgn, :factories => [@lssw])
#
#User.create!(:phone => "053766880606", :password => "zcsw0606", :password_confirmation => "zcsw0606", :name => "邹城农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@zcsw])
#User.create!(:phone => "053711115678", :password => "zcsw5678", :password_confirmation => "zcsw5678", :name => "邹城农污站点管理员", :roles => @fct_dvmgn, :factories => [@zcsw])
#
#User.create!(:phone => "053700006666", :password => "jxsw6666", :password_confirmation => "jxsw6666", :name => "嘉祥农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@jxsw])
#User.create!(:phone => "053700009999", :password => "jxsw9999", :password_confirmation => "jxsw9999", :name => "嘉祥农污站点管理员", :roles => @fct_dvmgn, :factories => [@jxsw])
#
#User.create!(:phone => "053766886969", :password => "wssw6969", :password_confirmation => "wssw6969", :name => "汶上农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@wssw])
#User.create!(:phone => "053766665656", :password => "wssw5656", :password_confirmation => "wssw5656", :name => "汶上农污站点管理员", :roles => @fct_dvmgn, :factories => [@wssw])
#
#User.create!(:phone => "053798985858", :password => "qfsw5858", :password_confirmation => "qfsw5858", :name => "曲阜农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@qfsw]) 
#User.create!(:phone => "053737081111", :password => "qfsw1111", :password_confirmation => "qfsw1111", :name => "曲阜农污站点管理员", :roles => @fct_dvmgn, :factories => [@qfsw]) 
#
#User.create!(:phone => "053766661818", :password => "rcws1818", :password_confirmation => "rcws1818", :name => "任城农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@rcws])
#User.create!(:phone => "053798986868", :password => "rcws6868", :password_confirmation => "rcws6868", :name => "任城农污站点管理员", :roles => @fct_dvmgn, :factories => [@rcws])
#
#User.create!(:phone => "053798986666", :password => "bhws6666", :password_confirmation => "bhws6666", :name => "北湖农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@bhws]) 
#User.create!(:phone => "053756788989", :password => "bhws8989", :password_confirmation => "bhws8989", :name => "北湖农污站点管理员", :roles => @fct_dvmgn, :factories => [@bhws]) 
#
#User.create!(:phone => "053798981919", :password => "dsmt1919", :password_confirmation => "dsmt1919", :name => "微山农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@dsmt])
#User.create!(:phone => "053756781234", :password => "dsmt1234", :password_confirmation => "dsmt1234", :name => "微山农污站点管理员", :roles => @fct_dvmgn, :factories => [@dsmt])

#User.create!(:phone => "053718189898", :password => "yzsw9898", :password_confirmation => "yzsw9898", :name => "兖州农污巡检人员管理员", :roles => @fct_whmgn, :factories => [@yzsw])
#User.create!(:phone => "053718183708", :password => "yzsw3708", :password_confirmation => "yzsw3708", :name => "兖州农污站点管理员", :roles => @fct_dvmgn, :factories => [@yzsw])
