package house

class HouseController {

    def index() {
        //check if user has valid session
        if(session['subId']) {
            def mess = params['message']
            def person = params['person']
            String[] p = person.split(',')
            Person per = new Person()
            per.subId = p[0]
            per.firstName = p[2]
            [message: mess, person: per]
        }
        else{
            redirect(action:'/')
        }
    }
    //direct method from controller: person, action:saveperson().  Method creates a new house
    def createhouse(){
        if(session['subId']) {
            def count = (House.count() + 1).toString()
            [idNumber: count]
        }else{
            redirect(url:'/')
        }
    }

    //redirect method from login - controller takes person to their house
    def myHouse() {
        if(session['subId']) {
            //get scores for all house members
            String houseId = session['houseId']
            def scores = Score.findAllByHouseId(houseId)

            //search database get all subId's associated with house Id
            def list = PersonHouse.executeQuery("SELECT p.personId "+
                    "FROM PersonHouse p " +
                    "WHERE p.houseId = '${houseId}' ")

            //remove user from list
            String[] findSubId = new String[list.size()-1]
            int k =0
            String pid = session['subId']
            for(int i = 0; i <list.size(); i++){
                String id = list[i]
                if(pid != id){
                    findSubId[k] = id
                    k++
                }
            }
            //calculate totals owed to each person in house
            //search Person table for firstName based on subId from list
            String[] emailList = new String[findSubId.size()]
            Person[] houseList = new Person[k]
            for(int i = 0; i < findSubId.size(); i++){
                String nameSubId = findSubId[i]
                def retPerson = Person.executeQuery("SELECT p.firstName, p.email, p.subId " +
                        "FROM Person p " +
                        "WHERE p.subId = '${nameSubId}'"
                )
                String[] retlist = retPerson[0]
                String firstname = retlist[0]
                String email = retlist[1]
                String subid = retlist[2]
                Person houseMember = [firstName: firstname, email: email, subId: subid]
                houseList[i] = houseMember
                emailList[i] = email
            }

            //get total amount owed/owe per house member
            LinkedList<Person> totalList = new LinkedList<>()

            for(Person member: houseList){
                Person person = Person.findBySubId(member.subId)
                //get credits owed by user to each house member
                def credits = []
                credits = Transaction.findAllByCreditorId(member.subId)
                int creditTotals = 0
                for(def credit:credits){
                    if(session['subId'] == credit.debitorId) {//each transaction where user owes member
                        creditTotals = creditTotals + credit.amountOwed
                        //render creditTotals
                    }
                }

                //get debits owed by member to user
                def debits= []
                debits = Transaction.findAllByDebitorId(member.subId)
                int debitTotals = 0

                for(def debit: debits){

                    if (session['subId'] == debit.creditorId) {
                        debitTotals = debitTotals + debit.amountOwed
                    }

                }
                String name = person.firstName
                String id = person.subId
                int netTotal = (creditTotals - debitTotals)
                Person ledgerItem = [firstName:name, subId:id, amount:netTotal.toString()]
                totalList.add(ledgerItem)
            }

            //get name of active user
            def name = Person.executeQuery("SELECT p.firstName " +
                    "FROM Person p " +
                    "WHERE p.subId = '${session['subId']}'")

            String firstName = name[0]

            [persons:houseList, user:firstName, emails:emailList, totalList:totalList, scores:scores]
        }
        else{
            def persons = Person.list()
            [person: persons]

        }

    }
    //from createhouse.gsp
    def save(){
        if(session['subId']) {
            def house = new House(params)
            house.save(flush : true)                             //save house to House table
            PersonHouse ph = new PersonHouse(personId: session['subId'], houseId:house.id)
            ph.save(flush : true)                               //save personhouse to PersonHouse Table
            session['houseId'] = house.id
            session['houseName'] = house.houseName
            //create new users score
            Person person = Person.findBySubId(session['subId'])
            //Score score =  new Score(firstName: person.firstName, lastName: person.lastName, subId: person.subId, houseId: session['subId']).save(flush : true)

            redirect(action:'index', controller:'EmailSender')
        }else{
            redirect(url:'/')
        }
    }

    def addroommate(){
        if(session['subId']) {
            [message: params['message']]
        }else{

        }
    }

    //method sends email to roommates added by house creator
    def sendLink(){
        render "Success"
        if(session['subId']) {
            def items = params
            //send email to roommates
            def message = "Hello ${session['firstName']}! Your house # is ${session['houseId']}"
            redirect(action:'addroommate')
        }else{
            redirect(url:'/')
        }
    }
    //CONSIDER DELETING

    def personsave(){
        def person = new Person(params)
        person.save(flush : true)
        render (view:"save.gsp")
    }

    //----this block of methods belong together
    //this is the controller for the page that referred user will use to join house
    def joinhouse(){

    }
    //this controller is to register user to a referred house
    def joinform(){
        def googleProfile = params.googleProfile
        if(!googleProfile.equals(',,,')) {
            String[] p = googleProfile.split(',')
            session['firstName'] = p[0]
            session['lastName'] = p[1]
            session['subId'] = p[2]
            session['email'] = p[3]

            [person: session]
        }else{
            def message ="IMPORTANT You need to log into google to access this app"
            redirect (uri:'/', params:[message:"IMPORTANT You need to log into google to access this app"])
        }
    }

    //saves new user to person table
    def saveform(){
        def userInformation = params
        String houseId = params.houseId
        String firstName = params.firstName
        String lastName = params.lastName
        String subId = params.subId
        String email = params.email
        //add to person table
        def person = new Person(firstName:firstName, lastName:lastName, subId:subId, email:email).save(flush : true)
        //add person and house id to personHouse table
        def personHouse = new PersonHouse(personId:subId, houseId:houseId).save(flush : true)
        //set up intial score for new member
        //Score newScore = new Score(firstName: firstName, lastName:lastName, subId:subId,houseId:houseId).save(flush : true)
        session.invalidate()
        redirect(uri:'/', params:[message:"Thank you for joining HouseMates! Please login below."])
    }
    //----block ends

    def houselist(){
        //use for getting list of all houses
        def list = House.list()
        render "House id: ${list.id}"
        render ",  House Name: ${list.houseName}"
    }
    def count(){
        def housecount = House.count()
        render housecount
    }



    def leaderboard(){

    }

    def settings(){
        String subId = session['subId']
        Person person = Person.findBySubId(subId)
        String image = person.image
        [person:person, image: image]
    }
}
