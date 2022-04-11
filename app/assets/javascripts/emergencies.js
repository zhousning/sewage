$(".emergencies").ready(function() {
  if ($(".emergencies.index").length > 0) {
    getWareItems('emergencies');
    update_count('emergencies');
  }
});
