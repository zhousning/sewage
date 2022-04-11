$(".upholds").ready(function() {
  if ($(".upholds.new").length > 0) {
    var data_fct = $('#fct').val();
    var url = "/factories/" + data_fct + "/upholds/query_devices";
    $.get(url).done(function (obj) {
      $("#device-select").select2({
        data: obj.results
      });
    })
  }

  if ($(".upholds.edit").length > 0) {
    var data_fct = $('#fct').val();
    var data_device = $('#device').val();
    var url = "/factories/" + data_fct + "/upholds/query_devices";
    $.get(url, {device: data_device}).done(function (obj) {
      $("#device-select").select2({
        data: obj.results
      });
    })
  }
});
