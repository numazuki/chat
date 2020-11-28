document.addEventListener('turbolinks:load',function(){
  $(function(){
    $('.tabcontent > div').hide();
     
    $('.tabnav a').click(function (e) {
      $('.tabcontent > div').hide().filter(this.hash).fadeIn();
      console.log(this.hash)
      if(this.hash == "#search"){
        $(".pagination").show();
      }else{
        $(".pagination").hide();
      }
      

      $('.tabnav a').removeClass('active');
      $(this).addClass('active');
     
      return false;
    }).filter(':eq(0)').click();
  });   
})
