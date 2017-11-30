<!DOCTYPE html>
<html>
<asset:stylesheet src="settings.css"/>
<head>
</head>
<body>
<div>
<g:form controller="person" action="changeName">
    <label>First Name: </label>
    <g:textField name="firstName"/><br/>
    <label>Last Name:  </label>
    <g:textField name="lastName"/><br/>
    <g:hiddenField name="subId" value="${person.subId}"/><br/>
    <g:actionSubmit controller="person" action="changeName" value="Change Name"/>
</g:form>
</div>


<g:img dir="images" file="${image}"/>

<fieldset>
    <div id="DROPZONEHERE" align="center"></div>
</fieldset>
<asset:javascript src="bundle.js"/>

</body>
</html>
