ActiveAdmin.register Uphold  do

  permit_params  :uphold_date, :reason, :content, :cost, :state

  menu label: Setting.upholds.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :uphold_date, :label => Setting.upholds.uphold_date
  filter :reason, :label => Setting.upholds.reason
  filter :content, :label => Setting.upholds.content
  filter :cost, :label => Setting.upholds.cost
  filter :state, :label => Setting.upholds.state
  filter :created_at

  index :title=>Setting.upholds.label + "管理" do
    selectable_column
    id_column
    
    column Setting.upholds.uphold_date, :uphold_date
    column Setting.upholds.reason, :reason
    column Setting.upholds.content, :content
    column Setting.upholds.cost, :cost
    column Setting.upholds.state, :state

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.upholds.label do
      
      f.input :uphold_date, :label => Setting.upholds.uphold_date 
      f.input :reason, :label => Setting.upholds.reason 
      f.input :content, :label => Setting.upholds.content 
      f.input :cost, :label => Setting.upholds.cost 
      f.input :state, :label => Setting.upholds.state 
    end
    f.actions
  end

  show :title=>Setting.upholds.label + "信息" do
    attributes_table do
      row "ID" do
        uphold.id
      end
      
      row Setting.upholds.uphold_date do
        uphold.uphold_date
      end
      row Setting.upholds.reason do
        uphold.reason
      end
      row Setting.upholds.content do
        uphold.content
      end
      row Setting.upholds.cost do
        uphold.cost
      end
      row Setting.upholds.state do
        uphold.state
      end

      row "创建时间" do
        uphold.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        uphold.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
