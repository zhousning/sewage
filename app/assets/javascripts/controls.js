$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
    var map = new AMap.Map('allmap', {
      resizeEnable: true,
      zoom: 11 
      //center: [116.397428, 39.90923]
    });

    var marker1 = new AMap.Marker({
      icon: "https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png",
      position: [116.405467, 39.907761],
      anchor:'bottom-center'
    });
    var marker2 = new AMap.Marker({
      icon: "https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png",
      position: [116.305467, 39.607761],
      anchor:'bottom-center'
    });

    setInterval(function(){
      url = "/task_logs/query_latest_point"
      $.get(url).done(function (obj) {
        map.clearMap();
        var arr = [];
        for (var i=0; i<obj.length; i++) {
          var point = obj[i]['point'];
          var marker = new AMap.Marker({
            icon: "https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png",
            position: point,
            anchor:'bottom-center'
          });
          arr.push(marker)
        }
        map.add(arr)
      })
    }, 10000)
  }

});

function addSearchParam() {
  $(".search-blank-text").val(gon.search);
  $(":radio[value='" + gon.ware + "']").prop("checked", true);
} 

function controlSearch() {
  //var table = controlSearchTable()
  //$("#search-result-ctn").html(table);
  var $table = $('#item-table')
  var data = [];
  var search = $(".search-blank-text").val();
  var ware_search = $(":radio[name='ware_search']:checked").val();

  var url = "/controls/search";
  $table.bootstrapTable('showLoading');
  $.get(url, {search: search, ware_search: ware_search}).done(function (objs) {
    $.each(objs, function(index, item) {
      data.push({
        'id' : index + 1,
        'name' : item.name,
        'mdno' : item.mdno,
        'count' : item.count,
        'fctname' : item.fctname
      });
    });
    $table.bootstrapTable('load', data);
    $table.bootstrapTable('hideLoading');
  })
}

function controlSearchTable() {
  //动态插入的 bootstraptable不管用
  var html = "<table id='item-table' class='text-center' data-toggle = 'table' data-id-table='advancedTable' data-pagination='true' data-page-size = '15' data-search = 'true' data-advanced-search='true' data-virtual-scroll = false> <thead><tr><th scope = 'col' data-field = 'id'> #</th><th scope = 'col' data-field = 'name'>名称</th><th scope = 'col' data-field = 'mdno'>型号</th><th scope = 'col' data-field = 'count'>库存</th><th scope = 'col' data-field = 'fct'>厂家</th><th scope = 'col' data-field = 'fctname'>公司</th></tr></thead></table>"
  return html;
}



/*$(".chart-statistic-ctn").each(function(index, e) {
  radarChartSet(e);
});

$(".chart-gauge-ctn").each(function(index, that_chart) {
  var qcode = that_chart.dataset['code'];
  var factory_id = that_chart.dataset['fct'];
  var chart = echarts.init(that_chart);
  chart.showLoading();

  var obj = {factory_id: factory_id, qcode: qcode }
  var url = "/day_pdt_rpts/new_quota_chart";
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = gaugeOption(data.name, data.value, data.min, data.max, data.color)
    chart.setOption(new_Option, true);
  });
});*/
