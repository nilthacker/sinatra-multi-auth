$(document).ready(function () {
  $('#login-form').on('show.bs.modal', function (e) {
    $('#login-box').modal('hide');
  })
  $('#login-form').on('hide.bs.modal', function (e) {
    $('#login-box').modal('show');
  })

$('#registration-form').on('show.bs.modal', function (e) {
    $('#login-box').modal('hide');
  })
  $('#registration-form').on('hide.bs.modal', function (e) {
    $('#login-box').modal('show');
  })
});