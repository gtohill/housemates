package house

class Post {

    String senderName
    String title
    String text
    String date

    static belongsTo = Person
    static hasMany = [receivers: Person]


    static constraints = {
        receivers nullable: true
    }
}
