package house

import java.util.*;
import java.text.*;
import java.util.Date;

class TransactionController {

    def index() {
        String userId = session['subId']
        String houseMemId = params.id

        //section gets total only
        /*def creditor = Transaction.executeQuery("SELECT p.invoiceId, p.houseId, p.creditorId, p.debitorId, p.creditorName, " +
                "p.debitorName, p.amountPaid, p.amountOwed, p.description, p.date " +
                "FROM Transaction p " +
                "WHERE p.creditorId = '107726694172578448865' "
        )

        def debitor = Transaction.executeQuery("SELECT p.invoiceId, p.houseId, p.creditorId, p.debitorId, p.creditorName, " +
                "p.debitorName, p.amountPaid, p.amountOwed, p.description, p.date " +
                "FROM Transaction p " +
                "WHERE p.debitorId = '107726694172578448865' ")


        def totalCredit = 0
        int len = creditor.size()
        //String[] creditList = new String[len];
        for(int y = 0; y < creditor.size(); y++) {
            String[] creditList = creditor[y]
            int creditAmount = creditList[7].toInteger()
            totalCredit = totalCredit + creditAmount
        }

        def totalDebit = 0
        //String[] creditList = new String[len];
        for(int y = 0; y < debitor.size(); y++) {
            String[] debitList = debitor[y]
            int debitAmount = debitList[7].toInteger()
            totalDebit = totalDebit + debitAmount
        }

        int total = (totalCredit -totalDebit) //total to be returned to front end*/


        //remove duplicate subId
        /*for(String w: subIdList){
            if(session['subId'] != w){
                newList[n] = w
            }
            n++
        }*/
        def listOfCreditDebit = Transaction.executeQuery("SELECT p.invoiceId, p.houseId, p.creditorId, p.debitorId, p.creditorName, " +
                "p.debitorName, p.amountPaid, p.amountOwed, p.description, p.date " +
                "FROM Transaction p " +
                "WHERE (p.debitorId = '${userId}' AND p.creditorId='${houseMemId}') OR (p.creditorId = '${userId}' AND p.debitorId='${houseMemId}') ")
        /*render listOfCreditDebit.size()
        return*/

        int size = listOfCreditDebit.size()
        Transaction[] list = new Transaction[size]
        for (int i = 0; i < listOfCreditDebit.size(); i++) {
            String[] transList = listOfCreditDebit[i]
            int invoiceId = transList[0].toInteger()
            int houseId = transList[1].toInteger()
            String creditorId = transList[2]
            String debitorId = transList[3]
            String creditorName = transList[4]
            String debitorName = transList[5]
            int amountPaid = transList[6].toInteger()
            int amountOwed = transList[7].toInteger()
            String description = transList[8]
            String date = transList[9]
            def trans = [invoiceId  : invoiceId, houseId: houseId, creditorId: creditorId, debitorId: debitorId, creditorName: creditorName,
                         debitorName: debitorName, amountPaid: amountPaid, amountOwed: amountOwed, description: description, date: date]

            list[i] = trans

        }
        [transactions: list, userId:session['subId']]
    }

    def transaction() {

        String userSubId = session['subId']
        String houseId = session['houseId']
        def list = PersonHouse.executeQuery("SELECT p.personId " +
                "FROM PersonHouse p " +
                "WHERE p.houseId = '${houseId}' ")

        //remove user from list

        String[] findSubId = new String[list.size() - 1]
        int k = 0
        for (int i = 0; i < list.size(); i++) {
            String id = list[i]
            if (userSubId != id) {
                findSubId[k] = id
                k++
            }
        }

        //search Person table for firstName based on subId from list
        Person[] houseList = new Person[k]
        for (int i = 0; i < findSubId.size(); i++) {
            String nameSubId = findSubId[i]
            def retPerson = Person.executeQuery("SELECT p.firstName, p.email, p.subId " +
                    "FROM Person p " +
                    "WHERE p.subId = '${nameSubId}'"
            )

            String[] retlist = retPerson[0]
            String firstname = retlist[0]
            String email = retlist[1]
            String subid = retlist[2]
            def houseMember = [firstName: firstname, email: email, subId: subid]
            houseList[i] = houseMember
        }

        [list: houseList]
    }



    def addpayment(){

        def payer = params.email
        Person person = Person.findByEmail(payer)
        if(person==null){
            println("oh no???")
            redirect(url:"http://localHost:8080/house/myHouse?subId+%3D+${session['subId']}%0A++firstName+%3D+${[session['firstName']]}", controller:'house')
            return
        }
        def message = params.message
        [person: person, message:message]
    }


    def payment(){
        def numOfPayments = params.amount //get the number of payments from params
        def invoiceNums = params.invoiceNum

        def notification
        //put payments in list
        LinkedList<Transaction> transList = new LinkedList<Transaction>()
        for(int i = 0; i < numOfPayments.size()-1; i++) {

            String amountPaid = numOfPayments[i]
            String invoice = invoiceNums[i]
            def insertItem = [invoiceId: invoice.toInteger(), amountOwed: amountPaid.toInteger()]

            transList.add(i, insertItem)
        }
        //process payments
        for(Transaction t: transList){
            Transaction toPay = Transaction.findByInvoiceId(t.invoiceId)
            if(toPay.amountOwed == t.amountOwed){

                String whoPaid = toPay.debitorName
                String description = toPay.description
                String amountOwed = toPay.amountOwed
                /**ENTER SCORE CALCULATIONS HERE*/
                def score = Score.findBySubId(toPay.debitorId)
                Date payDate = new Date()

                if(payDate.after(toPay.date)){
                    int numDays = payDate.minus(toPay.date)
                    if(numDays > 30 && numDays < 90){
                        score.score = score.score - 10
                        score.save()

                    }
                    if(numDays > 90 ){
                        score.score = score.score - 20
                        score.save()

                    }
                    if(numDays < 30){
                        score.score = score.score + 5
                        score.save()
                    }
                }


                Person p = Person.FindById(session['subId'])
                P.financeScore = score
                P.save(flush: true)


                toPay.delete(flush:true)
                Date today = new Date()
                redirect(action:'addPost', controller:'Post', params:[receivers: toPay.creditorId, subId: session['subId'], title: "Finance", text: "Paid: " +amountOwed+", FOR: " +description, date:today.toString() ])

                return

            }else{
                int amountPaid = toPay.amountOwed - t.amountOwed
                Transaction invoiceAdjust = Transaction.findByInvoiceId(t.invoiceId)
                invoiceAdjust.amountOwed = amountPaid
                invoiceAdjust.save(flush:true)
                String whoPaid = toPay.debitorName
                String description = toPay.description
                String amountOwed = toPay.amountOwed
                notification = [whoPaid: whoPaid, description: description, amountOwed: amountOwed]
                redirect(url:"http://localHost:8080/house/myHouse?subId+%3D+${session['subId']}%0A++firstName+%3D+${[session['firstName']]}", controller:'house', notification:notification)
                return
            }
        }
    }

    def savepayment(){
        def amountPaid = params.amountPaid
        def amountOwed = params.amountOwed
        def subId = params.subId

        Person debitorInfo = Person.findBySubId(subId)
        Person creditorInfo = Person.findBySubId(session['subId'])
        Transaction transInvoiceId = Transaction.last()
        int invoiceId = transInvoiceId.invoiceId +1
        String houseId = session['houseId']

        def today = new Date()
        Transaction trans = new Transaction(invoiceId:invoiceId, houseId:houseId.toInteger(),creditorId:session['subId'], debitorId:subId, creditorName: creditorInfo.firstName, debitorName: debitorInfo.firstName, amountPaid: amountPaid, amountOwed: amountOwed, description: params.description, date:today).save()

        def message = "Payment added"
        redirect(action:'addpayment' , params:[message:message, email:debitorInfo.email])

    }

    def translist(){
        def list = Transaction.list()
        render list.amountOwed
    }

    def calcdate(){
        def userSubId = session['subId']

        int score = 100
        if(modDate.after(date)){
            int numDays = modDate.minus(date)
            if(numDays > 30 && numDays < 90){
                score = score - 10
            }
            if(numDays > 90 ){
                score = score - 20
            }
        }else{
            render score
        }
        render score
    }
}
