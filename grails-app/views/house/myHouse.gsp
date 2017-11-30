<!DOCTYPE html>
<html>
<asset:stylesheet src="style.css"/>
<asset:stylesheet src="postFeed.css"/>
<head>

    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

    <h1 id="welcome">Welcome Home: ${user}</h1>

    <div id="buttons">
        <div  id="logoutRight">
            <g:form controller="PersonHouse" action="logout">
                <g:submitButton name="logout" controller="PersonHouse" action="logout" value="logout" />
            </g:form>
        </div>

        <!-- send EMAIL to add new user-->
        <div  id="addLeft">
            <g:form controller="EmailSender" action="index">
                <g:submitButton name="addRoommate" controller="EmailSender" action="index" value="Add Person" />
            </g:form>
        </div>
    </div>

    <title>Welcome Home!</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto+Condensed" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Lato">

</head>
<div id="topbar">

    <div><g:form controller="House" action="settings">
        <g:submitButton name="settings" controller="House" action="settings" value="settings" />
    </g:form></div>

    <div id="calendar1">
        <div id="caleandar">
        </div>


        <div>
            Calendar Stuff
            <div id="addEventDiv" style="display:none">
                <button onclick="myFunction()">Add Event</button>
                Year: <input type="text" id="YearInputEvent" value="YYYY">
                Month: <input type="text" id="MonthInputEvent" value="MM">
                Day: <input type="text" id="DayInputEvent" value="DD">
                Description: <input type="text" id="DescriptionInputEvent" value="Description">
            </div>
            <div id="addTaskDiv" style="display:none">
                <button onclick="myFunction2()">Add Task</button>
                Year: <input type="text" id="YearInputTask" value="YYYY">
                Month: <input type="text" id="MonthInputTask" value="MM">
                Day: <input type="text" id="DayInputTask" value="DD">
                Description: <input type="text" id="DescriptionInputTask" value="Description">
                <select id="AssigneesTask" name="AssigneesTask" multiple="multiple">
                    <g:each in="${persons}" var="item">
                        <option value=${item.email}>${item.email}</option>
                    </g:each>
                </select>
            </div>
            <button onclick="myFunction5()">+E</button>
            <button onclick="myFunction6()">+T</button>
        </div>
    </div>
    <div id="notification1">
        <div id="root"> </div>
    </div>
</div>
<body>
<!--code for top right corner, user name, logout and add person -->

<br/>
%{--location to open js file--}%


<!--integrate with calendar add task/event drop down function-->

<div id="bottombar">

    <div id="housemates1">
        <h4>${user}'s HouseMates</h4>
        <div id="leaderboard"></div>
    </div>

    <div id="finance1">
        <h3>Finance</h3>
        <h4>Select Person to Add Payment</h4>
        <g:form controller="transaction" action="addpayment">
            <g:select onchange="submit()"
                      name="email"
                      from="${emails}"
                      value="${emails}"
                      noSelection="['':'-Choose Persons Email-']"/>
        </g:form>
        <h4>Account Balances(+/-)</h4>
        <g:each in ="${totalList}" var ="person">
            <h4><g:link action="index" controller = "transaction" id="${person.subId}">${person.firstName} | Total: ${person.amount}</g:link></h4>
        </g:each>


    </div>




</div>



<h3 id="calender">

    <div>




        <!--Add buttons to initiate auth sequence and sign out-->
        <pre id="content"></pre>
        <script defer src="https://apis.google.com/js/api.js"
                onload="this.onload=function(){};handleClientLoad()"
                onreadystatechange="if (this.readyState === 'complete') this.onload()">
        </script>
        <script async>
            /*
             Author: Jack Ducasse;
             Version: 0.1.0;
             (????)
             */
            var Calendar = function(model, options, date){
                // Default Values
                this.Options = {
                    Color: '',
                    LinkColor: 'red',
                    NavShow: true,
                    NavVertical: false,
                    NavLocation: '',
                    DateTimeShow: true,
                    DateTimeFormat: 'mmm, yyyy',
                    DatetimeLocation: '',
                    EventClick: '',
                    EventTargetWholeDay: false,
                    DisabledDays: [],
                    ModelChange: model
                };
                // Overwriting default values
                for(var key in options){
                    this.Options[key] = typeof options[key]=='string'?options[key].toLowerCase():options[key];
                }
                model?this.Model=model:this.Model={};
                this.Today = new Date();
                this.Selected = this.Today
                this.Today.Month = this.Today.getMonth();
                this.Today.Year = this.Today.getFullYear();
                if(date){this.Selected = date}
                this.Selected.Month = this.Selected.getMonth();
                this.Selected.Year = this.Selected.getFullYear();
                this.Selected.Days = new Date(this.Selected.Year, (this.Selected.Month + 1), 0).getDate();
                this.Selected.FirstDay = new Date(this.Selected.Year, (this.Selected.Month), 1).getDay();
                this.Selected.LastDay = new Date(this.Selected.Year, (this.Selected.Month + 1), 0).getDay();
                this.Prev = new Date(this.Selected.Year, (this.Selected.Month - 1), 1);
                if(this.Selected.Month==0){this.Prev = new Date(this.Selected.Year-1, 11, 1);}
                this.Prev.Days = new Date(this.Prev.getFullYear(), (this.Prev.getMonth() + 1), 0).getDate();
            };
            function createCalendar(calendar, element, adjuster){
                if(typeof adjuster !== 'undefined'){
                    var newDate = new Date(calendar.Selected.Year, calendar.Selected.Month + adjuster, 1);
                    calendar = new Calendar(calendar.Model, calendar.Options, newDate);
                    element.innerHTML = '';
                }else{
                    for(var key in calendar.Options){
                        typeof calendar.Options[key] != 'function' && typeof calendar.Options[key] != 'object' && calendar.Options[key]?element.className += " " + key + "-" + calendar.Options[key]:0;
                    }
                }
                var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                function AddSidebar(){
                    var sidebar = document.createElement('div');
                    sidebar.className += 'cld-sidebar';
                    var monthList = document.createElement('ul');
                    monthList.className += 'cld-monthList';
                    for(var i = 0; i < months.length - 3; i++){
                        var x = document.createElement('li');
                        x.className += 'cld-month';
                        var n = i - (4 - calendar.Selected.Month);
                        // Account for overflowing month values
                        if(n<0){n+=12;}
                        else if(n>11){n-=12;}
                        // Add Appropriate Class
                        if(i==0){
                            x.className += ' cld-rwd cld-nav';
                            x.addEventListener('click', function(){
                                typeof calendar.Options.ModelChange == 'function'?calendar.Model = calendar.Options.ModelChange():calendar.Model = calendar.Options.ModelChange;
                                createCalendar(calendar, element, -1);});
                            x.innerHTML += '<svg height="15" width="15" viewBox="0 0 100 75" fill="rgba(255,255,255,0.5)"><polyline points="0,75 100,75 50,0"></polyline></svg>';
                        }
                        else if(i==months.length - 4){
                            x.className += ' cld-fwd cld-nav';
                            x.addEventListener('click', function(){
                                typeof calendar.Options.ModelChange == 'function'?calendar.Model = calendar.Options.ModelChange():calendar.Model = calendar.Options.ModelChange;
                                createCalendar(calendar, element, 1);} );
                            x.innerHTML += '<svg height="15" width="15" viewBox="0 0 100 75" fill="rgba(255,255,255,0.5)"><polyline points="0,0 100,0 50,75"></polyline></svg>';
                        }
                        else{
                            if(i < 4){x.className += ' cld-pre';}
                            else if(i > 4){x.className += ' cld-post';}
                            else{x.className += ' cld-curr';}
                            //prevent losing var adj value (for whatever reason that is happening)
                            (function () {
                                var adj = (i-4);
                                //x.addEventListener('click', function(){createCalendar(calendar, element, adj);console.log('kk', adj);} );
                                x.addEventListener('click', function(){
                                    typeof calendar.Options.ModelChange == 'function'?calendar.Model = calendar.Options.ModelChange():calendar.Model = calendar.Options.ModelChange;
                                    createCalendar(calendar, element, adj);} );
                                x.setAttribute('style', 'opacity:' + (1 - Math.abs(adj)/4));
                                x.innerHTML += months[n].substr(0,3);
                            }()); // immediate invocation
                            if(n==0){
                                var y = document.createElement('li');
                                y.className += 'cld-year';
                                if(i<5){
                                    y.innerHTML += calendar.Selected.Year;
                                }else{
                                    y.innerHTML += calendar.Selected.Year + 1;
                                }
                                monthList.appendChild(y);
                            }
                        }
                        monthList.appendChild(x);
                    }
                    sidebar.appendChild(monthList);
                    if(calendar.Options.NavLocation){
                        document.getElementById(calendar.Options.NavLocation).innerHTML = "";
                        document.getElementById(calendar.Options.NavLocation).appendChild(sidebar);
                    }
                    else{element.appendChild(sidebar);}
                }
                var mainSection = document.createElement('div');
                mainSection.className += "cld-main";
                function AddDateTime(){
                    var datetime = document.createElement('div');
                    datetime.className += "cld-datetime";
                    if(calendar.Options.NavShow && !calendar.Options.NavVertical){
                        var rwd = document.createElement('div');
                        rwd.className += " cld-rwd cld-nav";
                        rwd.addEventListener('click', function(){createCalendar(calendar, element, -1);} );
                        rwd.innerHTML = '<svg height="15" width="15" viewBox="0 0 75 100" fill="rgba(0,0,0,0.5)"><polyline points="0,50 75,0 75,100"></polyline></svg>';
                        datetime.appendChild(rwd);
                    }
                    var today = document.createElement('div');
                    today.className += ' today';
                    today.innerHTML = months[calendar.Selected.Month] + ", " + calendar.Selected.Year;
                    datetime.appendChild(today);
                    if(calendar.Options.NavShow && !calendar.Options.NavVertical){
                        var fwd = document.createElement('div');
                        fwd.className += " cld-fwd cld-nav";
                        fwd.addEventListener('click', function(){createCalendar(calendar, element, 1);} );
                        fwd.innerHTML = '<svg height="15" width="15" viewBox="0 0 75 100" fill="rgba(0,0,0,0.5)"><polyline points="0,0 75,50 0,100"></polyline></svg>';
                        datetime.appendChild(fwd);
                    }
                    if(calendar.Options.DatetimeLocation){
                        document.getElementById(calendar.Options.DatetimeLocation).innerHTML = "";
                        document.getElementById(calendar.Options.DatetimeLocation).appendChild(datetime);
                    }
                    else{mainSection.appendChild(datetime);}
                }
                function AddLabels(){
                    var labels = document.createElement('ul');
                    labels.className = 'cld-labels';
                    var labelsList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                    for(var i = 0; i < labelsList.length; i++){
                        var label = document.createElement('li');
                        label.className += "cld-label";
                        label.innerHTML = labelsList[i];
                        labels.appendChild(label);
                    }
                    mainSection.appendChild(labels);
                }
                function AddDays(){
                    // Create Number Element
                    function DayNumber(n){
                        var number = document.createElement('p');
                        number.className += "cld-number";
                        number.innerHTML += n;
                        return number;
                    }
                    var days = document.createElement('ul');
                    days.className += "cld-days";
                    // Previous Month's Days
                    for(var i = 0; i < (calendar.Selected.FirstDay); i++){
                        var day = document.createElement('li');
                        day.className += "cld-day prevMonth";
                        //Disabled Days
                        var d = i%7;
                        for(var q = 0; q < calendar.Options.DisabledDays.length; q++){
                            if(d==calendar.Options.DisabledDays[q]){
                                day.className += " disableDay";
                            }
                        }
                        var number = DayNumber((calendar.Prev.Days - calendar.Selected.FirstDay) + (i+1));
                        day.appendChild(number);
                        days.appendChild(day);
                    }
                    // Current Month's Days
                    for(var i = 0; i < calendar.Selected.Days; i++){
                        var day = document.createElement('li');
                        day.className += "cld-day currMonth";
                        //Disabled Days
                        var d = (i + calendar.Selected.FirstDay)%7;
                        for(var q = 0; q < calendar.Options.DisabledDays.length; q++){
                            if(d==calendar.Options.DisabledDays[q]){
                                day.className += " disableDay";
                            }
                        }
                        var number = DayNumber(i+1);
                        // Check Date against Event Dates
                        for(var n = 0; n < calendar.Model.length; n++){
                            var evDate = calendar.Model[n].Date;
                            var toDate = new Date(calendar.Selected.Year, calendar.Selected.Month, (i+1));
                            if(evDate.getTime() == toDate.getTime()){
                                number.className += " eventday";
                                var title = document.createElement('span');
                                title.className += "cld-title";
                                if(typeof calendar.Model[n].Link == 'function' || calendar.Options.EventClick){
                                    var a = document.createElement('a');
                                    a.setAttribute('a', '#');
                                    a.innerHTML += calendar.Model[n].Title;
                                    if(calendar.Options.EventClick){
                                        var z = calendar.Model[n].Link;
                                        if(typeof calendar.Model[n].Link != 'string'){
                                            a.addEventListener('click', calendar.Options.EventClick.bind.apply(calendar.Options.EventClick, [null].concat(z)) );
                                            if(calendar.Options.EventTargetWholeDay){
                                                day.className += " clickable";
                                                day.addEventListener('click', calendar.Options.EventClick.bind.apply(calendar.Options.EventClick, [null].concat(z)) );
                                            }
                                        }else{
                                            a.addEventListener('click', calendar.Options.EventClick.bind(null, z) );
                                            if(calendar.Options.EventTargetWholeDay){
                                                day.className += " clickable";
                                                day.addEventListener('click', calendar.Options.EventClick.bind(null, z) );
                                            }
                                        }
                                    }else{
                                        a.addEventListener('click', calendar.Model[n].Link);
                                        if(calendar.Options.EventTargetWholeDay){
                                            day.className += " clickable";
                                            day.addEventListener('click', calendar.Model[n].Link);
                                        }
                                    }
                                    title.appendChild(a);
                                }else{
                                    var innerString = '';
                                    //"${email}".replace("&#64;", "@")
                                    //✓
                                    innerString += '<div class="tooltip">';
                                    if (calendar.Model[n].Title == 'RoomMateTask'){
                                        innerString +='★';
                                    }
                                    if (calendar.Model[n].Title == 'RoomMateEvent'){
                                        innerString +='☆';
                                    }
                                    if (attended[n] == 'yes'){
                                        innerString += '✓';
                                    }
                                    //innerString += calendar.Model[n].Title;
                                    innerString += '<span class="tooltiptext">'  + calendar.Model[n].Link + '<br/><div>';
                                    //if(event.attendees[y].responseStatus = "accepted"
                                    if (attended[n] == 'no'){
                                        innerString += '<button onclick="myFunction7(eventId[' + n + '])">Attend</button>';
                                    }else{
                                        if (attended[n] == 'yes'){
                                            innerString += 'Already attended';
                                        }else{
                                            innerString += 'You are the master of this task';
                                        }
                                    }
                                    innerString += '</div></span></div>';
                                    title.innerHTML += innerString;
                                    //title.innerHTML += '<div class="tooltip">' + calendar.Model[n].Title + '<span class="tooltiptext">' + calendar.Model[n].Link + '</span></div>';
                                }
                                number.appendChild(title);
                            }
                        }
                        day.appendChild(number);
                        // If Today..
                        if((i+1) == calendar.Today.getDate() && calendar.Selected.Month == calendar.Today.Month && calendar.Selected.Year == calendar.Today.Year){
                            day.className += " today";
                        }
                        days.appendChild(day);
                    }
                    // Next Month's Days
                    // Always same amount of days in calander
                    var extraDays = 13;
                    if(days.children.length>35){extraDays = 6;}
                    else if(days.children.length<29){extraDays = 20;}
                    for(var i = 0; i < (extraDays - calendar.Selected.LastDay); i++){
                        var day = document.createElement('li');
                        day.className += "cld-day nextMonth";
                        //Disabled Days
                        var d = (i + calendar.Selected.LastDay + 1)%7;
                        for(var q = 0; q < calendar.Options.DisabledDays.length; q++){
                            if(d==calendar.Options.DisabledDays[q]){
                                day.className += " disableDay";
                            }
                        }
                        var number = DayNumber(i+1);
                        day.appendChild(number);
                        days.appendChild(day);
                    }
                    mainSection.appendChild(days);
                }
                if(calendar.Options.Color){
                    mainSection.innerHTML += '<style>.cld-main{color:' + calendar.Options.Color + ';}</style>';
                }
                if(calendar.Options.LinkColor){
                    //mainSection.innerHTML += '<style>.cld-title a{color:' + calendar.Options.LinkColor + ';}</style>';
                }
                element.appendChild(mainSection);
                if(calendar.Options.NavShow && calendar.Options.NavVertical){
                    AddSidebar();
                }
                if(calendar.Options.DateTimeShow){
                    AddDateTime();
                }
                AddLabels();
                AddDays();
            }
            function caleandar(el, data, settings){
                var obj = new Calendar(data, settings);
                createCalendar(obj, el);
            }
            //cut
            var anDate;
            var year =[];
            var month = [];
            var day = [];
            var summary = [];
            var desc = [];
            var eventId = [];
            var attended = [];
            // Client ID and API key from the Developer Console
            var CLIENT_ID = '731832964818-uecs4clv5qsfubet2rbbr1co235pbost.apps.googleusercontent.com';
            //724926326266-dhm6bt52ttmrlaessmt8rqp5oc6ueute.apps.googleusercontent.com
            // Array of API discovery doc URLs for APIs used by the quickstart
            var DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];
            // Authorization scopes required by the API; multiple scopes can be
            // included, separated by spaces.
            var SCOPES = "https://www.googleapis.com/auth/calendar";
            /**
             *  On load, called to load the auth2 library and API client library.
             */
            function handleClientLoad() {
                gapi.load('client:auth2', initClient);
            }
            /**
             *  Initializes the API client library and sets up sign-in state
             *  listeners.
             */
            function initClient() {
                gapi.client.init({
                    discoveryDocs: DISCOVERY_DOCS,
                    clientId: CLIENT_ID,
                    scope: SCOPES
                }).then(function () {
                    // Listen for sign-in state changes.
                    gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);
                    // Handle the initial sign-in state.
                    updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
                });
            }
            /**
             *  Called when the signed in status changes, to update the UI
             *  appropriately. After a sign-in, the API is called.
             */
            function updateSigninStatus(isSignedIn) {
                if (isSignedIn) {
                    listUpcomingEvents();
                } else {
                }
            }
            /**
             * Append a pre element to the body containing the given message
             * as its text node. Used to display the results of the API call.
             *
             * @param {string} message Text to be placed in pre element.
             */
            function popupMessage(x){
                alert(x);
            }
            function appendPre(message) {
                var events = [];
                var b = {};
                for (i = 0; i < year.length; i++) {
                    //b = {'Date': new Date(year[i], month[i], day[i]), 'Title': summary[i], 'Link': desc[i]};
                    b = {'Date': new Date(year[i], month[i], day[i]), 'Title': summary[i], 'Link': desc[i]};
                    events.push(b);
                }
                var settings = {};
                var element = document.getElementById('caleandar');
                caleandar(element, events, settings);
            }
            /**
             * Print the summary and start datetime/date of the next ten events in
             * the authorized user's calendar. If no events are found an
             * appropriate message is printed.
             */
            function listUpcomingEvents() {
                gapi.client.calendar.events.list({
                    'calendarId': 'primary',
                    //'timeMin': (new Date()).toISOString(),
                    'showDeleted': false,
                    'singleEvents': true,
                    //'maxResults': 10,
                    'orderBy': 'startTime'
                }).then(function(response) {
                    var events = response.result.items;
                    if (events.length > 0) {
                        for (i = 0; i < events.length; i++) {
                            var event = events[i];
                            var when = event.start.dateTime;
                            if (when){
                                anDate = new Date(when);
                            }else{
                                anDate = new Date(event.start.date);
                            }
                            summary.push(event.summary);
                            desc.push(event.description);
                            year.push(anDate.getFullYear());
                            month.push(anDate.getMonth());
                            day.push(anDate.getDate());
                            eventId.push(event.id);
                            var checkIfHere = 'no';
                            if (event.attendees){
                                for(var w = 0; w < event.attendees.length; w++){
                                    if (event.attendees[w].email == "${email}".replace("&#64;", "@")){
                                        if (event.attendees[w].responseStatus == "accepted"){
                                            checkIfHere = 'yes';
                                        }
                                    }
                                }
                                if (checkIfHere == 'yes'){
                                    attended.push('yes');
                                }else{
                                    attended.push('no');
                                }
                            }else{
                                attended.push('invalid');
                            }
                            /*if (event.attendees){
                             for(var w = 0; w < event.attendees.length; w++){
                             if (event.attendees[w].email == "${email}".replace("&#64;", "@")){
                             //console.log(event.attendees[w].email+anDate.getDate()+event.attendees[w].responseStatus);
                             if (event.attendees[w].responseStatus == "accepted"){
                             console.log('a');
                             attended.push('yes');
                             }else{
                             console.log('a');
                             attended.push('no');
                             }
                             }
                             }
                             }else{
                             console.log('a');
                             attended.push('invalid');
                             }
                             */
                            if (!when) {
                                when = event.start.date;
                            }
                        }
                        appendPre(event.summary + ' ' + event.description + ' (' + when + ')')
                    } else {
                        appendPre('No upcoming events found.');
                    }
                });
            }
            function myFunction() {
                var x = 0;
                var testYear = document.getElementById("YearInputEvent").value;
                var testMonth = document.getElementById("MonthInputEvent").value;
                var testDay = document.getElementById("DayInputEvent").value;
                if (testYear.match(/^\d{0,4}$/) || testMonth.match(/^\d{0,2}$/) || testDay.match(/^\d{0,2}$/)){
                    if (testYear < 0 || testMonth < 1 || testMonth > 12 || testDay > 31 || testDay < 1){
                        alert("One of your YYYY/MM/DD inputs contains an invalid number.");
                        return;
                    }
                }else{
                    alert("One of your YYYY/MM/DD inputs either contains the wrong number of numbers, or non-numeric characters.");
                    return;
                }
                var event = {
                    //'summary': document.getElementById("SummaryInputEvent").value,
                    'summary': 'RoomMateEvent',
                    'description': document.getElementById("DescriptionInputEvent").value,
                    'start': {
                        'dateTime': document.getElementById("YearInputEvent").value + '-' +document.getElementById("MonthInputEvent").value + '-' + document.getElementById("DayInputEvent").value + 'T01:00:00-23:00',
                        'timeZone': 'America/Toronto'
                    },
                    'end': {
                        'dateTime': document.getElementById("YearInputEvent").value + '-' +document.getElementById("MonthInputEvent").value + '-' + document.getElementById("DayInputEvent").value + 'T01:00:00-23:00',
                        'timeZone': 'America/Toronto'
                    },
                    'recurrence': [
                        //'RRULE:FREQ=DAILY;COUNT=2'
                    ],
                    'attendees': [
                    ],
                    'reminders': {
                        'useDefault': false,
                        'overrides': [
                            {'method': 'email', 'minutes': 24 * 60},
                            {'method': 'popup', 'minutes': 10}
                        ]
                    }
                };
                var request = gapi.client.calendar.events.insert({
                    'calendarId': 'primary',
                    'resource': event
                });
                for (x=0;x<document.getElementById("AssigneesTask").length;x++)
                {
                    event.attendees.push({'email':document.getElementById("AssigneesTask")[x].value});
                }
                request.execute(function(event) {
                    alert('Event created: ' + event.htmlLink);
                });
            }
            /*
             */
            function myFunction2(){
                var x=0;
                var testYear = document.getElementById("YearInputTask").value;
                var testMonth = document.getElementById("MonthInputTask").value;
                var testDay = document.getElementById("DayInputTask").value;
                if (testYear.match(/^\d{0,4}$/) || testMonth.match(/^\d{0,2}$/) || testDay.match(/^\d{0,2}$/)){
                    if (testYear < 0 || testMonth < 1 || testMonth > 12 || testDay > 31 || testDay < 1){
                        alert("One of your YYYY/MM/DD inputs contains an invalid number.");
                        return;
                    }
                }else{
                    alert("One of your YYYY/MM/DD inputs either contains the wrong number of numbers, or non-numeric characters.");
                    return;
                }
                var event = {
                    //'summary': document.getElementById("SummaryInputTask").value,
                    'summary': 'RoomMateTask',
                    'description': document.getElementById("DescriptionInputTask").value,
                    'start': {
                        'dateTime': document.getElementById("YearInputTask").value + '-' +document.getElementById("MonthInputTask").value + '-' + document.getElementById("DayInputTask").value + 'T01:00:00-23:00',
                        'timeZone': 'America/Toronto'
                    },
                    'end': {
                        'dateTime': document.getElementById("YearInputTask").value + '-' +document.getElementById("MonthInputTask").value + '-' + document.getElementById("DayInputTask").value + 'T01:00:00-23:00',
                        'timeZone': 'America/Toronto'
                    },
                    'recurrence': [
                        //'RRULE:FREQ=DAILY;COUNT=2'
                    ],
                    'attendees': [
                    ],
                    'reminders': {
                        'useDefault': false,
                        'overrides': [
                            {'method': 'email', 'minutes': 24 * 60},
                            {'method': 'popup', 'minutes': 10}
                        ]
                    }
                };
                var request = gapi.client.calendar.events.insert({
                    'calendarId': 'primary',
                    'resource': event
                });
                for (x=0;x<document.getElementById("AssigneesTask").length;x++)
                {
                    if (document.getElementById("AssigneesTask")[x].selected)
                    {
                        event.attendees.push({'email':document.getElementById("AssigneesTask")[x].value});
                    }
                }
                request.execute(function(event) {
                    alert('Task created: ' + event.htmlLink);
                });
            }
            //cut
            function myFunction5() {
                if (document.getElementById("addEventDiv").style.display == "block"){
                    document.getElementById("addEventDiv").style.display = "none";
                }else{
                    if (document.getElementById("addTaskDiv").style.display == "block"){
                        document.getElementById("addTaskDiv").style.display = "none";
                    }
                    document.getElementById("addEventDiv").style.display = "block";
                }
            }
            function myFunction6() {
                if (document.getElementById("addTaskDiv").style.display == "block"){
                    document.getElementById("addTaskDiv").style.display = "none";
                }else{
                    if (document.getElementById("addEventDiv").style.display == "block"){
                        document.getElementById("addEventDiv").style.display = "none";
                    }
                    document.getElementById("addTaskDiv").style.display = "block";
                }
            }
            function myFunction7(text){
                var event;
                var myEmailVar = "${email}".replace("&#64;", "@");
                var request = gapi.client.calendar.events.get({
                    'calendarId': 'primary',
                    'eventId':text
                }).then(function(response) {
                    event = response.result;
                    if (event.attendees){
                        for(var y = 0; y < event.attendees.length; y++){
                            if (event.attendees[y].email == myEmailVar){
                                event.attendees[y].responseStatus = "accepted";
                            }
                        }
                    }
                    var request2 = gapi.client.calendar.events.update({
                        'calendarId': 'primary',
                        'eventId':text,
                        'resource': event
                    });
                    request2.execute(function(event) {
                        alert('Event updated successfully' );
                    });
                });
            }
        </script>


        <pre id="content"></pre>


</h3>

    <div id="leaderboard"></div>

<asset:javascript src="bundle.js"/>

</body>
</html>
