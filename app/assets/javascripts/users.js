// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// document.addEventListener('turbolinks:load',function(){
//   $('.js-text_field').on('keyup', function () {
//     var name = $.trim($(this).val());
//     $.ajax({
//       type: 'GET', // リクエストのタイプ
//       url: '/users/searches', // リクエストを送信するURL
//       data:  { name: name }, // サーバーに送信するデータ
//       dataType: 'json' // サーバーから返却される型
//     })
//     .done(function (data) {
//       $('.js-users li,img').remove();
//       $(data).each(function(i,user) {
//         console.log(data);
//         var avatar = `${user.avatar.url}`;
//         console.log(avatar);
//         var html = `<img src=${user.avatar.url} class = "icon_image user">
//                     <li class="user"><a href="/users/${user.id}">${user.name}</a>${user.search_id}</li>`

//         $('.js-users').append(html);   
        
//       });
//     });  
//   });  
// })
