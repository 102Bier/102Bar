import UIKit
import Alamofire

class Service: NSObject {

    static let shared = Service()
    var customDrinkModel : CustomDrinkModel = CustomDrinkModel()
    
    let BASE_URL: String
    let URL_USER_LOGIN: String
    let URL_USER_REGISTER: String
    let URL_AVAILABLE_INGREDIENTS_TYPE: String
    let URL_AVAILABLE_INGREDIENTS_DRINK: String
    let URL_AVAILABLE_MIXES_ROOT: String
    let URL_AVAILABLE_MIXES_ING: String
    let URL_AVAILABLE_DRINK_GROUPS: String
    let URL_AVAILABLE_DRINK_TYPES: String
    let URL_ORDER_MIX: String
    let URL_ORDERED_MIXES_ING: String
    let URL_ORDERED_MIXES_ROOT: String
    let URL_GET_CUSTOM_MIXES_ROOT: String
    let URL_GET_CUSTOM_MIXES_ING: String
    let URL_CUSTOM_MIX: String
    let URL_USER_INFO: String
    
    let defaultValues = UserDefaults.standard
    
    var availableDrinkGroups = [DrinkGroup]()
    var availableDrinkTypes = [DrinkType]()
    var availableIngredients = [Drink]()
    var availableMixes = [Mix]()
    var orderedMixes = [Mix]()
    public var testI: [Drink]!
    
    
    
    override init() {
        BASE_URL = "http://102bier.de/102bar/"
        URL_USER_LOGIN = BASE_URL + "login.php"
        URL_USER_REGISTER = BASE_URL + "register.php"
        URL_USER_INFO = BASE_URL + "user.php"
        URL_AVAILABLE_INGREDIENTS_TYPE = BASE_URL + "availableIngredientsType.php"
        URL_AVAILABLE_INGREDIENTS_DRINK = BASE_URL + "availableIngredientsDrink.php"
        URL_AVAILABLE_MIXES_ROOT = BASE_URL + "availableMixesRoot.php"
        URL_AVAILABLE_MIXES_ING = BASE_URL + "availableMixesIng.php"
        URL_ORDERED_MIXES_ROOT = BASE_URL + "orderedMixesRoot.php"
        URL_ORDERED_MIXES_ING = BASE_URL + "orderedMixesIng.php"
        URL_ORDER_MIX = BASE_URL + "orderMix.php"
        URL_AVAILABLE_DRINK_TYPES = BASE_URL + "availableDrinkTypes.php"
        URL_AVAILABLE_DRINK_GROUPS = BASE_URL + "availableDrinkGroups.php"
        URL_GET_CUSTOM_MIXES_ROOT = BASE_URL + "getCustomMixesRoot.php"
        URL_GET_CUSTOM_MIXES_ING = BASE_URL + "getCustomMixesIng.php"
        URL_CUSTOM_MIX = BASE_URL + "customMix.php"
        super.init()
        getAvailableDrinkGroups
            {
                success in
                self.getAvailableDrinkTypes{
                    success1 in
                }
        }
    }
    
    private func nextStep1(ding: Bool){
        
    }
    
    public func login(loginController: LoginController, username:String, password:String){
        
        /*** Create test availableDrinks Array*///
        let drink1 = Drink(drink: "", drinkType: availableDrinkTypes.first(where: {$0.drinkTypeDescription == "Süßer Sprudel"})!, drinkDescription: "Fanta")
        let drink2 = Drink(drink: "", drinkType: availableDrinkTypes.first(where: {$0.drinkTypeDescription == "Vodka"})!, drinkDescription: "Skyy")
        let drink3 = Drink(drink: "", drinkType: availableDrinkTypes.first(where: {$0.drinkTypeDescription == "Tequila"})!, drinkDescription: "Sierra Silver")
        let drink4 = Drink(drink: "", drinkType: availableDrinkTypes.first(where: {$0.drinkTypeDescription == "Cola"})!, drinkDescription: "Coca Cola")
        let drink5 = Drink(drink: "", drinkType: availableDrinkTypes.first(where: {$0.drinkTypeDescription == "Berentzen"})!, drinkDescription: "Berentzen Saurer Apfel")
        let drink6 = Drink(drink: "", drinkType: availableDrinkTypes.first(where: {$0.drinkTypeDescription == "Energy"})!, drinkDescription: "Red Bull")
        
        Service.shared.testI = [drink1, drink2, drink3, drink4, drink5, drink6]
        /***END***/
        
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
                        let userId = user.value(forKey: "id") as! String
                        let userName = user.value(forKey: "username") as! String
                        let userFirstname = user.value(forKey: "firstname") as! String
                        let userLastname = user.value(forKey: "lastname") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        let userRights = user.value(forKey: "rights") as! Int
                        
                        //saving user values to defaults
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userFirstname, forKey: "userfirstname")
                        self.defaultValues.set(userLastname, forKey: "userlastname")
                        self.defaultValues.set(userRights, forKey: "userrights")
                        
                        loginController.changeView()
                    }else{
                        //error message in case of invalid credential
                        loginController.labelMessage.text = "Invalid username or password"
                    }
                    
                }
        }
    }
    
    public func loginAsGuest(loginController: LoginController){
        self.defaultValues.set("-1", forKey: "userid")
        self.defaultValues.set("Guest", forKey: "username")
        self.defaultValues.set("Guest", forKey: "useremail")
        self.defaultValues.set("Guest", forKey: "userfirstname")
        self.defaultValues.set("", forKey: "userlastname")
        self.defaultValues.set(1, forKey: "userrights")
        loginController.changeView()
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
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    registerController.labelMessage.text = jsonData.value(forKey: "message") as? String
                }
        }
    }
    
    public func getAvailableDrinkGroups(callback: @escaping (_ success: Bool?) -> Void){
        Alamofire.request(self.URL_AVAILABLE_DRINK_GROUPS).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.availableDrinkGroups = Array()
                    let tmpArray = result as! NSArray
                    for tmp in tmpArray{
                        let tmpDictionary = tmp as! NSDictionary
                        let tmpDrinkGroup: String = tmpDictionary.object(forKey: "DrinkGroup") as! String
                        let tmpDescription: String = tmpDictionary.object(forKey: "Description") as! String
                        let tmpAlcoholic: Bool = (tmpDictionary.object(forKey: "Alcoholic") as! String) == "1" ? true : false
                        let drinkGroup = DrinkGroup(drinkGroup: tmpDrinkGroup, drinkGroupDescription: tmpDescription, alcoholic: tmpAlcoholic)
                        self.availableDrinkGroups.append(drinkGroup)
                    }
                    callback(true)
                }else{
                    callback(false)
                }
        }
    }
    
    public func getAvailableDrinkTypes(callback: @escaping (_ success: Bool?) -> Void){
        Alamofire.request(self.URL_AVAILABLE_DRINK_TYPES).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.availableDrinkTypes = Array()
                    let tmpArray = result as! NSArray
                    for tmp in tmpArray{
                        let tmpDictionary = tmp as! NSDictionary
                        let tmpDrinkType: String = tmpDictionary.object(forKey: "DrinkType") as! String
                        let tmpDrinkGroup = self.availableDrinkGroups.first(where: {$0.drinkGroup == tmpDictionary.object(forKey: "DrinkGroup") as! String})!
                        let tmpDescription: String = tmpDictionary.object(forKey: "Description") as! String
                        let drinkType = DrinkType(drinkType: tmpDrinkType, drinkGroup: tmpDrinkGroup, drinkTypeDescription: tmpDescription)
                        self.availableDrinkTypes.append(drinkType)
                    }
                    callback(true)
                }else{
                    callback(false)
                }
        }
    }
    
    public func getAvailableIngredients(callback: @escaping (_ success: Bool?) -> Void){
        Alamofire.request(self.URL_AVAILABLE_INGREDIENTS_TYPE).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.availableIngredients = Array()
                    let typeArray = result as! NSArray
                    for tmp in typeArray{
                        let tmpDictionary = tmp as! NSDictionary
                        let tmpDrink = tmpDictionary.object(forKey: "DrinkType") as! String
                        let tmpDrinkType = self.availableDrinkTypes.first(where: {$0.drinkType == tmpDrink})
                        let tmpDescription = tmpDictionary.object(forKey: "DrinkTypeDesc") as! String
                        let drink = Drink(drink: tmpDrink, drinkType: tmpDrinkType!, drinkDescription: tmpDescription)
                        self.availableIngredients.append(drink)
                    }
                    Alamofire.request(self.URL_AVAILABLE_INGREDIENTS_DRINK).responseJSON{
                        response1 in
                        if let result1 = response1.result.value{
                            let drinkArray = result1 as! NSArray
                            for tmp in drinkArray{
                                let tmpDictionary = tmp as! NSDictionary
                                let tmpDrink = tmpDictionary.object(forKey: "Drink") as! String
                                let tmpDrinkType = self.availableDrinkTypes.first(where: {$0.drinkType == tmpDictionary.object(forKey: "DrinkType") as! String})!
                                let tmpDescription = tmpDictionary.object(forKey: "DrinkDesc") as! String
                                let drink = Drink(drink: tmpDrink, drinkType: tmpDrinkType, drinkDescription: tmpDescription)
                                self.availableIngredients.append(drink)
                            }
                            callback(true)
                        }else{
                            callback(false)
                        }
                    }
                }
        }
    }
    
    public func getAvailableMixes(callback: @escaping (_ success: Bool?) -> Void){
        Alamofire.request(self.URL_AVAILABLE_MIXES_ROOT).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.availableMixes = Array()
                    let rootArray = result as! NSArray
                    for root in rootArray{
                        let mixDictionary = root as! NSDictionary
                        let tmpMix = mixDictionary.object(forKey: "AvailableMix") as! String
                        let tmpDescription = mixDictionary.object(forKey: "Description") as! String
                        let tmpIngredients = [Drink]()
                        let mix = Mix(mix: tmpMix, mixDescription: tmpDescription, ingredients: tmpIngredients)
                        self.availableMixes.append(mix)
                    }
                    Alamofire.request(self.URL_AVAILABLE_MIXES_ING).responseJSON{
                        response1 in
                        if let result1 = response1.result.value{
                            let ingArray = result1 as! NSArray
                            for ing in ingArray{
                                let ingDic = ing as! NSDictionary
                                let ingRoot = ingDic.object(forKey: "Root") as! String
                                let ingGUID = ingDic.object(forKey: "Reference") as! String
                                let ingPercentage = Int(ingDic.object(forKey: "Percentage") as! String)
                                let ingAFO = Int(ingDic.object(forKey: "AFO") as! String)
                                for rootToFill in self.availableMixes where rootToFill.mix == ingRoot{
                                    let ingToAdd: Drink = (self.availableIngredients.first(where: {$0.drink == ingGUID})?.clone())!
                                    ingToAdd.percentage = ingPercentage!
                                    ingToAdd.AFO = ingAFO!
                                    rootToFill.ingredients.append(ingToAdd)
                                }
                            }
                            callback(true)
                        }else{
                            callback(false)
                        }
                    }
                }
        }
    }
    
    public func getOrderedMixes(callback: @escaping (_ success: Bool?) -> Void){
        //Do not empty array check if exists
        Alamofire.request(self.URL_ORDERED_MIXES_ROOT).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.orderedMixes = Array()
                    let rootArray = result as! NSArray
                    for root in rootArray{
                        let mixDictionary = root as! NSDictionary
                        let tmpMix = mixDictionary.object(forKey: "OrderedMix") as! String
                        let orderedMix = self.availableMixes.first(where: {$0.mix == tmpMix})
                        let orderedMixToSave = orderedMix?.clone()
                        orderedMixToSave?.orderedByUser = mixDictionary.object(forKey: "User") as! String
                        self.orderedMixes.append(orderedMixToSave!)
                    }
                    Alamofire.request(self.URL_ORDERED_MIXES_ING).responseJSON{
                        response1 in
                        if let result1 = response1.result.value{
                            let ingArray = result1 as! NSArray
                            for ing in ingArray{
                                let ingDic = ing as! NSDictionary
                                let ingRoot = ingDic.object(forKey: "Root") as! String
                                let ingGUID = ingDic.object(forKey: "Reference") as! String
                                let ingPercentage = Int(ingDic.object(forKey: "Percentage") as! String)
                                for rootToFill in self.orderedMixes where rootToFill.mix == ingRoot{
                                    let ingToChange = rootToFill.ingredients.first(where: {$0.drink == ingGUID})
                                    ingToChange?.percentage = ingPercentage!
                                }
                            }
                            callback(true)
                        }else{
                            callback(false)
                        }
                    }
                }
        }
    }
    
    public func orderMix(mixToOrder: Mix, add: Bool, callback: @escaping (_ success: String?) -> Void){
        //NOT TESTED AND NO PHP
        let ingredientsJSON: String = JSONSerializer.toJson(mixToOrder.ingredients)
        let index = ingredientsJSON.index(ingredientsJSON.startIndex, offsetBy: 8)
        let ingredients = ingredientsJSON[index...]
        
        let parameters: Parameters=[
            "Mix": mixToOrder.mix,
            "Description": mixToOrder.mixDescription,
            "Ingredients": ingredients,
            "User": defaultValues.object(forKey: "userid") as! String,
            "Add": add ? "1" : "0"
        ]
        
        Alamofire.request(URL_CUSTOM_MIX, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    callback(jsonData.value(forKey: "message") as? String)
                }
        }
    }
    
    public func getCustomMixes(callback: @escaping (_ success: Bool?) -> Void){
        //TODO
        let parameters: Parameters=[
            "user":"22"
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
                        let userId = user.value(forKey: "id") as! String
                        let userName = user.value(forKey: "username") as! String
                        let userFirstname = user.value(forKey: "firstname") as! String
                        let userLastname = user.value(forKey: "lastname") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        let userRights = user.value(forKey: "rights") as! Int
                        
                        //saving user values to defaults
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userFirstname, forKey: "userfirstname")
                        self.defaultValues.set(userLastname, forKey: "userlastname")
                        self.defaultValues.set(userRights, forKey: "userrights")
                        
                    }else{
                        //error message in case of invalid credential
                    }
                    
                }
        }
    }
    
    public func customMix(mixToAdd: Mix, add: Bool, callback: @escaping (_ success: String?) -> Void){
        let ingredientsJSON: String = JSONSerializer.toJson(mixToAdd.ingredients)
        let index = ingredientsJSON.index(ingredientsJSON.startIndex, offsetBy: 8)
        let ingredients = ingredientsJSON[index...]

        let parameters: Parameters=[
            "Mix": mixToAdd.mix,
            "Description": mixToAdd.mixDescription,
            "Ingredients": ingredients,
            "User": defaultValues.object(forKey: "userid") as! String,
            "Add": add ? "1" : "0"
        ]
        
        Alamofire.request(URL_CUSTOM_MIX, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    callback(jsonData.value(forKey: "message") as? String)
                }
        }
    }
    
    public func getNewGUID() -> String{
        return UUID.init().uuidString.lowercased()
    }

}
