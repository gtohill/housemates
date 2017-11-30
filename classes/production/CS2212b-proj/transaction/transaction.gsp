<!DOCTYPE html>
<html>
    <head>
        <title>Transactions</title>
    </head>
    <body>
    <h4><g:link controller="house" action="myHouse">Back To My House</g:link></h4>
        <div>
            <g:each in ="${list}" var ="person">
                <br/>
                <g:link action="index" controller = "transaction" id="${person.subId}">${person.firstName}</g:link>
            </g:each>
        </div>
    </body>
</html>