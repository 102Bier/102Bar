import Foundation

class User: NSObject {
    
    var user: String = ""
    var username: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var rights: Int = 0
    
    init(user: String, username: String, firstname: String, lastname: String, email: String, rights: Int) {
        self.user = user
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.rights = rights
    }

}
