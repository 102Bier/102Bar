import UIKit
import Alamofire

class Service: NSObject {
    
    let BASE_URL: String
    let URL_USER_LOGIN: String
    let URL_USER_REGISTER: String
    let URL_AVAILABLE_INGREDIENTS: String
    let URL_ORDERED_MIXES: String
    
    let defaultValues = UserDefaults.standard
    
    override init() {
        BASE_URL = "http://102bier.de/102bar/"
        URL_USER_LOGIN = BASE_URL + "login.php"
        URL_USER_REGISTER = BASE_URL + "register.php"
        URL_AVAILABLE_INGREDIENTS = BASE_URL + "availableIngredients.php"
        URL_ORDERED_MIXES = BASE_URL + "orderedMixes.php"
    }
    
    public func login(loginController: LoginController, username:String, password:String){
        
        let parameters: Parameters=[
            "username": username,
            "password": password
        ]
        
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                debugPrint(response)
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        //getting the user from response
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        
                        //getting user values
                        let userId = user.value(forKey: "id") as! Int
                        let userName = user.value(forKey: "username") as! String
                        let userFirstname = user.value(forKey: "firstname") as! String
                        let userLastname = user.value(forKey: "lastname") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        
                        //saving user values to defaults
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userFirstname, forKey: "userfirstname")
                        self.defaultValues.set(userLastname, forKey: "userlastname")
                        
                        loginController.changeView()
                    }else{
                        //error message in case of invalid credential
                        loginController.labelMessage.text = "Invalid username or password"
                    }
                    
                }
        }
    }
    
    public func register(registerController: RegisterController,username:String, firstname:String, lastname:String, email:String, password:String){
        
        let parameters: Parameters=[
            "username": username,
            "password": password,
            "firstname": firstname,
            "lastname": lastname,
            "email": email
        ]
        
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message in label
                    registerController.labelMessage.text = jsonData.value(forKey: "message") as? String
                }
        }
    }
    
    public func getAvailableIngredients(){
        var availableIngredients: NSDictionary!
        Alamofire.request(self.URL_AVAILABLE_INGREDIENTS).responseJSON
            {
                response in
                if let result = response.result.value {
                    availableIngredients = result as! NSDictionary
                }
        }
    }
    
    public func getAvailableMixes(){
        
    }
    
    public func getOrderedMixes(){
        Alamofire.request(self.URL_ORDERED_MIXES).responseJSON
            {
                response in
                debugPrint(response)
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        let ingredients = jsonData.value(forKey: "ingredients") as! NSDictionary
                        print(ingredients)
                        
                    }else{
                        //error message in case of invalid credential
                    }
                }
        }
    }
    
    public func orderMix(){
        
    }

}
