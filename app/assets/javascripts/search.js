document.addEventListener('turbolinks:load',function(){
  var search_list = $(".search_contents");

  function appendUser(user) {
    var html = `<a class="user_cell" href="/users/${user.id}">
                  <div class="user_content d-flex flex-row">
                    <div class="user_image">
                      <img src=${user.avatar.url} class = "icon_image user">
                    </div>
                    <div class="user_prof">
                      <h5 class="text-dark">${user.name}</h5>
                      <p class="text-secondary">@${user.search_id}</p>  
                      <p class="text-dark">${user.profile}</p>
                    </div>
                  </div>
                </a>
                `
    search_list.append(html);
  }

  function appendErrMsgToHTML(msg) {
    var html = `
　　　　　　　　 <div class="user_content">
                　<p class="user_name text-center">
                  　　${ msg }
                　</p>
              </div>
　　　　　　　　　`
    search_list.append(html);
    
  }

  
  $(".search_input").on("keyup", function() {

    var input = $(".search_input").val();
    
//---以下を追記---
    $.ajax({
      type: 'GET',
      url: '/users/searches',
      data: { keyword: input },
      dataType: 'json'
    })
    .done(function(users) {
      $(".pagination").hide();
      if ($(".search_input").val() == ''){
        $(".pagination").show();
        console.log('open')
      }
      
      console.log(users)
      $(".search_contents").empty();
      if (users.length !== 0) {
        users.forEach(function(user){
          appendUser(user);
        });
      } else {
        appendErrMsgToHTML("一致するユーザーはいません");
      }
    })
    .fail(function() {
      alert('error');
    });    
  });  
})