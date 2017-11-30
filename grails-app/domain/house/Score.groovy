package house

/**
 * Created by gtohill on 21/03/17.
 */
class Score {

    String subId
    String firstName
    String lastName
    int score = 100
    int houseId

    static constraints = {
        subId unique:true
        lastName nullable:true
        houseId nullable:true

    }
}
