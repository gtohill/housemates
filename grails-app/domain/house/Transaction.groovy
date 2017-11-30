package house

/**
 * Created by gtohill on 08/03/17.
 */
class Transaction {
    int invoiceId
    int houseId
    String creditorId
    String debitorId
    String creditorName
    String debitorName
    int amountPaid
    int amountOwed
    String description
    Date date

    public Transaction(int invoiceId, int houseId, String creditorId, String debitorId, String creditorName, String debitorName,
                       int amountPaid, int amountOwed, String description, String date){
        invoiceId = invoiceId
        houseId = houseId
        creditorId = creditorId
        debitorId = debitorId
        creditorName = creditorName
        debitorName = debitorName
        amountPaid = amountPaid
        amountOwed = amountOwed
        description = description
        date = date
    }

    static constraints = {
        invoiceId unique: true, blank:false
        houseId blank:false
        creditorId blank:false
        debitorId blank:false
        amountPaid blank:false
        amountOwed blank:false
        description maxSize: 100
        date blank:false

    }


}
