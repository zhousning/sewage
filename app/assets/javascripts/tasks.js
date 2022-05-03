$(".tasks").ready(function() {
  if ($(".tasks.show").length > 0) {
    initMap();
    var car = gon.car;
    $("#report-search").click(function() {
      var inspector = $("#inspector").val();
      var search_date = $("#inspect_date").val();
      var url = "/task_logs/query_trace?";
      $('<div id="loadingTip">加载数据，请稍候...</div>').appendTo(document.body);
      $.getJSON(url, {inspector: inspector, search_date: search_date}, function(d) {
      //$.getJSON('https://a.amap.com/amap-ui/static/data/big-routes.json', function(d) {
        $('#loadingTip').remove();
        var flyRoutes = [];
        pathSimplifierIns.setData(d);

        function onload() {
          pathSimplifierIns.renderLater();
        }

        function onerror(e) {
          alert('图片加载失败！');
        }

        for (var i=0; i<d.length; i++) {
          pathSimplifierIns.createPathNavigator(i, {
              loop: true,
              speed: 3000,
              pathNavigatorStyle: {
                  width: 26,
                  height: 52,
                  //width: 16,
                  //height: 32,
                  //使用图片
                  content: PathSimplifier.Render.Canvas.getImageContent(car, onload, onerror),
                  strokeStyle: null,
                  fillStyle: null,
                  //经过路径的样式
                  pathLinePassedStyle: {
                      lineWidth: 6,
                      strokeStyle: 'green',
                      dirArrowStyle: {
                          stepSpace: 15,
                          strokeStyle: 'white'
                      }
                  }
              }
          }).start();
        }
      });

    });
  }
});

function initMap() {
  var map = new AMap.Map('allmap', {
      zoom: 11,
      center: gon.center
  });

  var arr = [];
  var obj = gon.obj
  for (var i=0; i<obj.length; i++) {
    var longitude = obj[i].longitude;
    var latitude = obj[i].latitude;
    var avatar = obj[i].avatar;
    var name = obj[i].name;
    var site = obj[i].site;
    var state = obj[i].state;
    var phone = obj[i].phone;
    var time = obj[i].time;
    var infoWindow = mapInfoWindow(map, time, site, name, phone, avatar, longitude, latitude, state);
    var icon = '';
    var label = '';
    if (state == '0') {
      //icon: "https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png";
      //icon = gon.blocal;
      label = '<div class="info"><span style="font-size:11px;background-color:green;color:white;padding:5px;">正常</span></div>'
    } else {
      //icon: "https://webapi.amap.com/theme/v1.3/markers/n/mark_r.png";
      //icon = gon.rlocal;
      label = '<div class="info"><span style="font-size:11px;background-color:red;color:white;padding:5px;">异常</span></div>'
    }
    var startIcon = new AMap.Icon({
      size: new AMap.Size(40, 40),
      image: avatar,
      imageSize: new AMap.Size(40, 40)
      //imageOffset: new AMap.Pixel(-9, -3)
    });

    var marker = new AMap.Marker({
      icon: startIcon,
      position: [longitude, latitude],
      anchor:'bottom-center'
    });
    marker.setLabel({
      offset: new AMap.Pixel(0, 0),  //设置文本标注偏移量
      //content: "<div class='info'>我是 marker 的 label 标签</div>", //设置文本标注内容
      content: label, 
      direction: 'bottom' //设置文本标注方位
    });
    marker.on('click', function () {
      infoWindow.open(map, marker.getPosition());
    });
    arr.push(marker)
  }
  map.add(arr)

  AMapUI.load(['ui/misc/PathSimplifier', 'lib/$'], function(PathSimplifier, $) {
    if (!PathSimplifier.supportCanvas) {
      alert('当前环境不支持 Canvas！');
      return;
    }

    //just some colors
    var colors = [
      "#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#66aa00",
      "#b82e2e", "#316395", "#994499", "#22aa99", "#aaaa11", "#6633cc", "#e67300", "#8b0707",
      "#651067", "#329262", "#5574a6", "#3b3eac"
    ];

    var pathSimplifierIns = new PathSimplifier({
      zIndex: 100,
      //autoSetFitView:false,
      map: map, //所属的地图实例
      getPath: function(pathData, pathIndex) {
          return pathData.path;
      },
      getHoverTitle: function(pathData, pathIndex, pointIndex) {
        if (pointIndex >= 0) {
            //point 
            return pathData.name + '，点：' + pointIndex + '/' + pathData.path.length;
        }
        //return pathData.name + '，点数量' + pathData.path.length;
        return pathData.name;
      },
      renderOptions: {
        pathLineStyle: {
          dirArrowStyle: true
        },
        getPathStyle: function(pathItem, zoom) {
          var color = colors[pathItem.pathIndex % colors.length],
              lineWidth = Math.round(4 * Math.pow(1.1, zoom - 3));

          return {
            pathLineStyle: {
              strokeStyle: color,
              lineWidth: lineWidth
            },
            pathLineSelectedStyle: {
              lineWidth: lineWidth + 2
            },
            pathNavigatorStyle: {
              fillStyle: color
            }
          };
        }
      }
    });

    window.pathSimplifierIns = pathSimplifierIns;
    window.PathSimplifier = PathSimplifier;
  });
}

function mapInfoWindow(map, time, site, name, phone, avatar, longitude, latitude, state) {
  //实例化信息窗体
  var title = '' 
  if (state == '0') {
    title = site + '<span style="font-size:11px;color:green;">正常</span>'
  } else {
    title = site + '<span style="font-size:11px;color:red;">异常</span>'
  }
  var content = [];
  content.push("<img src='" + avatar + "'>" + "经度: " + longitude + ";纬度：" + latitude);
  content.push(name + "：" + phone);
  content.push('时间' + "：" + time);
  //content.push("<a href='https://ditu.amap.com/detail/B000A8URXB?citycode=110105'>详细信息</a>");
  
  var infoWindow = new AMap.InfoWindow({
      isCustom: true,  //使用自定义窗体
      content: createInfoWindow(title, content.join("<br/>")),
      offset: new AMap.Pixel(16, -45)
  });
  
  //构建自定义信息窗体
  function createInfoWindow(title, content) {
      var info = document.createElement("div");
      info.className = "custom-info input-card content-window-card";
  
      //可以通过下面的方式修改自定义窗体的宽高
      info.style.width = "400px";
      // 定义顶部标题
      var top = document.createElement("div");
      var titleD = document.createElement("div");
      var closeX = document.createElement("img");
      top.className = "info-top";
      titleD.innerHTML = title;
      closeX.src = "https://webapi.amap.com/images/close2.gif";
      closeX.onclick = closeInfoWindow;
  
      top.appendChild(titleD);
      top.appendChild(closeX);
      info.appendChild(top);
  
      // 定义中部内容
      var middle = document.createElement("div");
      middle.className = "info-middle";
      middle.style.backgroundColor = 'white';
      middle.innerHTML = content;
      info.appendChild(middle);
  
      // 定义底部内容
      var bottom = document.createElement("div");
      bottom.className = "info-bottom";
      bottom.style.position = 'relative';
      bottom.style.top = '0px';
      bottom.style.margin = '0 auto';
      var sharp = document.createElement("img");
      sharp.src = "https://webapi.amap.com/images/sharp.png";
      bottom.appendChild(sharp);
      info.appendChild(bottom);
      return info;
  }
  
  //关闭信息窗体
  function closeInfoWindow() {
      map.clearInfoWindow();
  }

  return infoWindow;
}
//var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.fct_id +"'>查看</button>"; 
//var factory = item.factory;
//var search = "<a class='button button-royal button-small mr-1' href='/factories/" + factory + "/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/factories/" + factory + "/" + method + "/" + id + "'>删除</a>"
//// 百度地图API功能
////GPS坐标
//var x = 116.32715863448607;
//var y = 39.990912172420714;
//var ggPoint = new BMap.Point(x,y);
//
////地图初始化
//var bm = new BMap.Map("allmap");
//bm.centerAndZoom(ggPoint, 15);
//bm.addControl(new BMap.NavigationControl());
//
////添加gps marker和label
//var markergg = new BMap.Marker(ggPoint);
//bm.addOverlay(markergg); //添加GPS marker
//var labelgg = new BMap.Label("未转换的GPS坐标（错误）",{offset:new BMap.Size(20,-10)});
//markergg.setLabel(labelgg); //添加GPS label
//
////坐标转换完之后的回调函数
//translateCallback = function (data){
//  if(data.status === 0) {
//    var marker = new BMap.Marker(data.points[0]);
//    bm.addOverlay(marker);
//    var label = new BMap.Label("转换后的百度坐标（正确）",{offset:new BMap.Size(20,-10)});
//    marker.setLabel(label); //添加百度label
//    bm.setCenter(data.points[0]);
//  }
//}
//
//setTimeout(function(){
//    var convertor = new BMap.Convertor();
//    var pointArr = [];
//    pointArr.push(ggPoint);
//    convertor.translate(pointArr, 1, 5, translateCallback)
//}, 1000);
//if ($(".tasks.index").length > 0) {
    //get_tasks('tasks');
 // }
//function get_tasks(method) {
//  var $table = $('#item-table');
//  var data = [];
//  //var data_fct = $('#fct').val();
//  //var url = "/factories/" + data_fct + "/" + method + "/query_all";
//  var url = "/" + method + "/query_all";
//  $.get(url).done(function (objs) {
//    $.each(objs, function(index, item) {
//      var id = item.id;
//      //var button = "<button id='info-btn' class = 'button button-primary button-small mr-1' type = 'button' data-rpt ='" + id + "'>查看</button>" + "<a class='button button-royal button-small mr-1' href='/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/" + method + "/" + id + "'>删除</a>"
//      var button = "<a class='button button-primary button-small mr-1' href='/" + method + "/" + id + "/'>查看</a>" + "<a class='button button-royal button-small mr-1' href='/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/" + method + "/" + id + "'>删除</a>"
//      data.push({
//        'id' : index + 1,
//         
//        'task_date' : item.task_date,
//         
//        'des' : item.des,
//        
//        'button' : button 
//      });
//    });
//    $table.bootstrapTable('load', data);
//  })
//}
//
