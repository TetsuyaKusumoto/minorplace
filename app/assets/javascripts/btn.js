$(function(){
  $('.btn-want,btn-visit').on('ajax:send', function(xhr){
    $('.btn-visit,.btn-want').prop("disabled", true);
  });
});
