<!DOCTYPE html>
<html>
<head>
    <title>ADD PAYMENT</title>
</head>
<body>
    <h3>Time to get Paid!</h3>
    <p>Fill-out the form below, and your House Mate will receive a notification to pay you!</p>
    <div>
          <g:form controller="transaction" action="savepayment">
                <label>Debitor:</label>
                <g:textField name="debitorName" value="${person.firstName}"/><br/>
                <label>Amount Paid: </label>
                <g:textField name="amountPaid" value=""/><br/>
                <label>Amount Owed: </label>
                <g:textField name="amountOwed" value=""/><br/>
                <label>Description: </label>
                <g:textField name="description" value="" />
                <g:hiddenField name="subId" value="${person['subId']}"/><br/>
                <lablel>email: </lablel>
                <g:textField name="email" value="${person['email']}"/>
                <g:hiddenField name="email" value="${person['email']}"/><br/>
                <g:actionSubmit controller='transaction' action='savepayment' value="Submit"/>
          </g:form>

    </div>
    <div>
        <h4>${message}</h4>
    </div>
    <h4><g:link controller="house" action="myHouse">Back To My House</g:link></h4>
</body>
</html>