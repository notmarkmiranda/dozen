$(document).ready(function() {
  $("tr.league-show__seasons-table[data-link], tr.season-show__games-table[data-link]").click(function() {
    window.location = $(this).data("link")
  })
})
