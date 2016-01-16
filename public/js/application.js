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

 facebookLoginListener();

});

var facebookLoginListener = function(){
  $('.fb-login-button').click(function(e){
    e.preventDefault();
    FB.login(function(response){
      if(response.authResponse){
        $.getJSON('/auth/facebook/callback', function(json) {
          // if succesful redirect the browser to /auth/facebook/callback
          $('#connect').html('Connected! Callback complete.');
          $('#results').html(JSON.stringify(json));
          });
        }
      }, {scope: 'email,read_stream'});
    });
  }

 // This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
    console.log('statusChangeCallback');
    console.log(response);
    // The response object is returned with a status field that lets the
    // app know the current login status of the person.
    // Full docs on the response object can be found in the documentation
    // for FB.getLoginStatus().
    if (response.status === 'connected') {
      // Logged into your app and Facebook.
      testAPI();
    } else if (response.status === 'not_authorized') {
      // The person is logged into Facebook, but not your app.
      document.getElementById('status').innerHTML = 'Please log ' +
        'into this app.';
    } else {
      // The person is not logged into Facebook, so we're not sure if
      // they are logged into this app or not.
      document.getElementById('status').innerHTML = 'Please log ' +
        'into Facebook.';
    }
  }

  // This function is called when someone finishes with the Login
 // Button.  See the onlogin handler attached to it in the sample
 // code below.
function checkLoginState() {
   FB.getLoginStatus(function(response) {
     statusChangeCallback(response);
   });
 }

 // Now that we've initialized the JavaScript SDK, we call
  // FB.getLoginStatus().  This function gets the state of the
  // person visiting this page and can return one of three states to
  // the callback you provide.  They can be:
  //
  // 1. Logged into your app ('connected')
  // 2. Logged into Facebook, but not your app ('not_authorized')
  // 3. Not logged into Facebook and can't tell if they are logged into
  //    your app or not.
  //
  // These three cases are handled in the callback function.

  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });

  };


  // Here we run a very simple test of the Graph API after login is
  // successful.  See statusChangeCallback() for when this call is made.
function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
      console.log('Successful login for: ' + response.name);
      document.getElementById('status').innerHTML =
        'Thanks for logging in, ' + response.name + '!';
    });
  }
