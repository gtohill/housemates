<!DOCTYPE html>
<html>
<head>
    <title>Welcome Home!</title>
</head>
<body>
    <!--code for top right corner, user name, logout and add person -->
    <div style="position:relative; left: 1200px;">
        <h3>Welcome Home: ${user}</h3>
        <g:form controller="PersonHouse" action="logout">
            <g:submitButton name="logout" controller="PersonHouse" action="logout" value="logout" />
        </g:form>
    </div>

    <!-- send EMAIL to add new user-->
    <div style="position:relative; left: 1200px;">
        <g:form controller="EmailSender" action="index">
            <g:submitButton name="addRoommate" controller="EmailSender" action="index" value="Add Person" />
        </g:form>
    </div>
    <br/>

    <div style="width:auto;height:200px;"><h3>BIG BOX GOES HERE</h3></div>
    <!-- returns the users roommates -->

    <div>
        <h4>${user}'s HouseMates</h4>
        <g:each in="${persons}" var="item">
                <p>Name: ${item.firstName}</p>
                <p>Email: ${item.email}</p>
        </g:each>
    </div>
    <!--integrate with calendar add task/event drop down function-->

    <div style="position:relative; bottom: 300px; left: 1000px;">
        <h3>Finance</h3>
        <div>
            <h4>Select Person to Add Payment</h4>
            <g:form controller="transaction" action="addpayment">
                <g:select onchange="submit()"
                          name="email"
                          from="${emails}"
                          value="${emails}"
                          noSelection="['':'-Choose Persons Email-']"/>
            </g:form>
        </div>
        <div>
            <h4>Account Balances(+/-)</h4>
            <g:each in ="${totalList}" var ="person">
                <h4><g:link action="index" controller = "transaction" id="${person.subId}">${person.firstName} | Total: ${person.amount}</g:link></h4>
            </g:each>
        </div>
    </div>
    <div>
        <h3>Leader Board</h3>
        <g:each in="${scores}" var="score">
            <p>${score.firstName}   ${score.score}</p>
        </g:each>
    </div>

</body>
</html>