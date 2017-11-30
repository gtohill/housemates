<!doctype html>
<head>
    <asset:stylesheet src="login.css"/>
    <meta name="google-signin-scope" content="profile email https://www.googleapis.com/auth/calendar">
    <head>
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Lato">
    </head>
    <meta name="google-signin-client_id" content="724926326266-dhm6bt52ttmrlaessmt8rqp5oc6ueute.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>
</head>
<body>

    <br/>
    <h2 class="welcome" style="font-size: 20px">Welcome To</h2>

    <h2 class="housemates" style="font-size: 60px">House Mates</h2>

    <br/>

    <div>
        <h3 class="signup">Sign up with Gmail Below</h3>
    </div>
    <div id="googlebutton" class="g-signin2" data-onsuccess="onSignIn" data-theme="dark"></div>

        <br/>

        <div id="option">
        <div id="one"><h1 class="mem" style="text-align: left">Already a Member </h1></div>
        <div id="two"><h1 class="mem" style="text-align: right">Not a Member </h1></div>
        </div>

                <div id="wrapper">

            <div id="first">
        <div>

        <div>
            <g:form id="login" name="jftForm" controller="PersonHouse" action="login">
                <g:hiddenField name="googleProfile" value=""/>
                <g:submitButton id="login" name="login" value="Login"/>
            </g:form>

        </div></div></div>

            <div id="second">
        <div>
            <g:form name="jftForm" controller="person" action="createperson">
                <g:hiddenField name="googleProfile" value=""/>
                <g:submitButton id="createhouse" name="Login" value="Create House"/>
            </g:form>
        </div>
            </div>


        </div>

        <div>
         <br/>
            <a id="signoutgoogle" href="#" onclick="signOut();">Sign out of google</a>
        </div>
        <!-- javascript-->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <script>
            var subId;
            var email;
            var firstName;
            var lastName;

            function onSignIn(googleUser) {
                // The ID token you need to pass to your backend:
                // Useful data for your client-side scripts:
                var profile = googleUser.getBasicProfile();
                console.log("ID: " + profile.getId()); // Don't send this directly to your server!
                console.log('Full Name: ' + profile.getName());
                console.log('Given Name: ' + profile.getGivenName());
                console.log('Family Name: ' + profile.getFamilyName());
                console.log("Image URL: " + profile.getImageUrl());
                console.log("Email: " + profile.getEmail());

                // The ID token you need to pass to your backend:
                var id_token = googleUser.getAuthResponse().id_token;
                console.log("ID Token: " + id_token);
                subId = profile.getId();
                email = profile.getEmail();
                firstName = profile.getGivenName();
                lastName = profile.getFamilyName();

            };
            jQuery(function () {
                jQuery("[name='jftForm']").submit(function () {
                    jQuery("[name='googleProfile']").val([firstName,lastName,subId,email]);
                });
            })
        </script>
        <script>
            function signOut() {
                var auth2 = gapi.auth2.getAuthInstance();
                auth2.signOut().then(function () {
                    console.log('User signed out.');
                    location.reload();
                });
            }
        </script>
</body>
</html>
