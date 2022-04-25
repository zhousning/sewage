$(".tasks").ready(function() {
  if ($(".tasks.show").length > 0) {
    initMap();
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
          var navg = pathSimplifierIns.createPathNavigator(i, {
              loop: true,
              speed: 1000000,
              pathNavigatorStyle: {
                  width: 24,
                  height: 24,
                  //使用图片
                  //content: PathSimplifier.Render.Canvas.getImageContent('./imgs/plane.png', onload, onerror),
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
          });
          navg.start();
        }
      });

    });
  }
});

function initMap() {
  var map = new AMap.Map('allmap', {
      zoom: 4
  });
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
        return pathData.name + '，点数量' + pathData.path.length;
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
  });
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
