import UIKit

class Service: NSObject {
    
    let BASE_URL: String
    let URL_USER_LOGIN: String
    let URL_USER_REGISTER: String
    let URL_AVAILABLE_INGREDIENTS: String
    let URL_ORDERED_MIXES: String
    
    override init() {
        BASE_URL = "http://102bier.de/102bar/"
        URL_USER_LOGIN = BASE_URL + "login.php"
        URL_USER_REGISTER = BASE_URL + "register.php"
        URL_AVAILABLE_INGREDIENTS = BASE_URL + "availableIngredients.php"
        URL_ORDERED_MIXES = BASE_URL + "orderedMixes.php"
    }
    
    func login(username:String, password:String){
        
    }
    
    func register(username:String, firstname:String, lastname:String, email:String, password:String, confirmPassword:String){
        
    }
    
    func getAvailableIngredients(){
        
    }
    
    func getAvailableMixes(){
        
    }
    
    func getOrderedMixes(){
        
    }

}
