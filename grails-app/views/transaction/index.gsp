<!DOCTYPE html>
<html>
<head>
    <title>Test Transactions</title>
</head>
    <body>

    <h4><g:link  base="http://localHost:8080/house/myHouse?subId+%3D+${session['subId']}%0A++firstName+%3D+${[session['firstName']]}">Back To My House</g:link></h4>


    <div>
        <g:set var="user" value="${userId}" scope="page"/>
        <g:set var="count" value="" scope="page"/>
        <g:set var="list" scope="page"/>
        <script>
        <g:each in="${transactions}" var="per1" status="j">
            count = ${j+1}
        </g:each>
        var array = list[count];
        document.write(count)
        </script>

    </div>

        <h2>Transactions</h2>
        <div>
            <g:form >
            <g:each in="${transactions}" var ="person" status="i">
                <h3>____________________________</h3>
                <p>Date:        ${person.date}</p>
                <p>Invoice #:   ${person.invoiceId}, House #:${person.houseId} </p>
                <p>Creditor:    ${person.creditorName}</p>
                <p>Debitor:     ${person.debitorName}</p>
                <p>Total:       ${person.amountPaid}</p>
                <p>Amount Owed: ${person.amountOwed}</p>
                <g:if test="${person.debitorId == user}">
                    $<g:textField name="amount" value="0"/>
                    <g:hiddenField name="invoiceNum" value="${person.invoiceId}" />
                </g:if>
                <p>Description: ${person.description}</p>
            </g:each>
                <g:hiddenField name="amount" value="0"/>
                <g:hiddenField name="invoiceNum" value="0"/>
                <g:actionSubmit action="payment" controller="transaction" value="Make Payment" />
            </g:form>
        </div>
    </body>
</html>
