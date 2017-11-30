package house

class EmailSenderController {

    def index() {

        String email = "Hello from HouseMates!  Your friend, ${session['firstName']}, is requesting that " +
                " you join HouseMates.  Please visit link http://localhost:8080/house/joinhouse. " +
                "You will be asked to authenticate your gmail account. After authentication, your gmail account infomation" +
                " will be used to to register your account. At that point, all you need to do is enter house number ${session['houseId']}. " +
                "" +
                "\n\n\nThank you from HouseMates!"

        [email:email]
    }

    //send method sends one or many emails at the same time.
    def send() {
        def addresses = params
        String[] splitAddress = addresses.address.split(';')
        String sub = addresses.subject
        String message = addresses.body
        def emailArray = new LinkedList()
        for(int i = 0; i < splitAddress.size(); i++){
        def insert = [splitAddress[i], sub, message]
            emailArray.add(i,insert)

        }
        for(int j = 0; j < emailArray.size(); j++) {
            def sendEmail = emailArray.get(j)
            String emailAdd = sendEmail[0]
            String subj = sendEmail[1]
            String sendMessage = sendEmail[2]

            sendMail {
                to emailAdd
                from "housemates2212@gmail.com"
                subject subj
                text sendMessage
            }

        }
        flash.message = "Message sent at "+new Date() + "Please add another HouseMate"
        redirect action:"index"
    }
}
