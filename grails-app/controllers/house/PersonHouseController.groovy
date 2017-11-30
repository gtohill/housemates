package house

import grails.rest.RestfulController


class PersonHouseController extends RestfulController{

    static responseFormats = ['json', 'xml']

    PersonHouseController() {
        super(PersonHouse)
    }

    def index() {

    }
    //NEED TO ADD all users house mates to session object.
    def login() {
        def auth = params.googleProfile

        if(!auth.equals(',,,')) {
            String[] p = auth.split(',')
            String subId = p[2]
            //check database for login user.
            def personHouse =  PersonHouse.executeQuery("SELECT p.personId, p.houseId " +
                    "FROM PersonHouse p  " +
                    "WHERE p.personId = '${subId}' ")

            if(personHouse.isEmpty()){
                redirect(uri:'/', params:[message:"Sorry ${p[0]}, you are not in our database." +
                        "  Pleases click the Join button below."])
                return
            }

            if(personHouse[0] != '') {//if condition passes, then person is in house and has houseId

                String[] pidHid = personHouse[0]
                String pid = pidHid[0]
                String hid = pidHid[1]
                def person = Person.list()
                if(pid in person.subId){//check the passed subId(person) matches the database subId(Person)
                    session['subId'] = pid  //create a session
                    session['houseId'] = hid
                    def getPerson = Person.findBySubId(pid)
                    session['firstName'] = getPerson.firstName
                }
                //send user to users house.
                redirect(action:'myHouse', controller:'house', params:[persons:session])
            }

        }else{
            redirect(uri:'/', params:[message:"IMPORTANT- Please login to google to access the app"])
        }
    }
    //end users session
    def logout() {
        session.invalidate()

    }

    //redirect to login page
    def landing() {
        redirect(url: '/')
    }

    //fun with session
    def list() {
        if (session['subId']) {
            def list = PersonHouse.list()
            [list:list]
        } else {
            redirect(url:'/')
        }
    }

    //for one api call
    def getHouseMembers(){
        print("getting house members")
        def subId = params.subId
        def houseId = PersonHouse.findByPersonId(subId).getHouseId()
        PersonHouse.findAllByHouseId(houseId)
        def personList = []
        for(PersonHouse pHouse : PersonHouse.findAllByHouseId(houseId))
        {
            personList.add(Person.findBySubId(pHouse.getPersonId()))
        }
        println(personList)
        respond personList
    }
}
