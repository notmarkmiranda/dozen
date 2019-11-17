$(document).ready(function() {
  $("tr.league-show__seasons-table[data-link]").click(function() {
    window.location = $(this).data("link")
  })
})
