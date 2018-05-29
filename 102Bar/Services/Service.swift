import UIKit
import Alamofire
import UserNotifications
import CoreData
import WatchConnectivity

class Service: NSObject, UNUserNotificationCenterDelegate, WCSessionDelegate {
    
    // MARK: - Variables
    
    static let shared = Service()
    let session : WCSession
    
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
    let URL_REMOVE_ORDERED_MIX: String
    let URL_ORDERED_MIXES_ING: String
    let URL_ORDERED_MIXES_ROOT: String
    let URL_GET_CUSTOM_MIXES_ROOT: String
    let URL_GET_CUSTOM_MIXES_ING: String
    let URL_CUSTOM_MIX: String
    let URL_USER_INFO: String
    let URL_CHECK_NOTIFICATIONS: String
    
    let defaultValues = UserDefaults.standard
    var timer = Timer()
    var alamoFireManager : SessionManager = SessionManager.default
    
    let availableMixesArchiveUrl = { () -> URL in
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("availableMixes.archive")
    }
    
    let customUserMixesArchiveUrl = { () -> URL in
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("customUserMixes.archive")
    }
    
    var availableDrinkGroups = [DrinkGroup]()
    var availableDrinkTypes = [DrinkType]()
    var availableIngredients = [Drink]()
    var availableMixes = [Mix]()
    var orderedMixes = [Mix]()
    var customMixes = [Mix]()
    var customUserMixes = [Mix]()
    var users = [User]()
    
    // MARK: - Rights Enum
    
    public enum Rights : Int{
        case canLogin = 1       //darf sich anmelden
        case canOrder = 2       //darf bestellen
        case canCreateOwn = 4   //darf eigenes Getränk erstellen
        case canOmit = 8        //darf Getränk auslassen
    }
    
    // MARK: - WCSession Functions
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sendMixes(custom : Bool)
    {
        if(custom)
        {
            NSKeyedArchiver.archiveRootObject(self.customUserMixes, toFile: self.customUserMixesArchiveUrl().path) //save to file
            let data = NSKeyedArchiver.archivedData(withRootObject: self.customUserMixes)
            do { try self.session.updateApplicationContext(["custom" : data]) }
            catch {
                print("didn't work quite well")
            }
        }
        else {
            NSKeyedArchiver.archiveRootObject(self.availableMixes, toFile: self.availableMixesArchiveUrl().path) //save to file
            let data = NSKeyedArchiver.archivedData(withRootObject: self.availableMixes)
            do { try self.session.updateApplicationContext(["default" : data]) }
            catch {
                print("didn't work quite well")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let who = message["alcoholic"] as? String
        {
            var alc = [Bool]()
            if who == "custom"
            {
                for i in 0..<customUserMixes.count{
                    alc.append(customUserMixes[i].ingredients.contains(where: {$0.drinkType.drinkGroup.alcoholic})) //if one ingredient is alcoholic, the whole mix is as well
                }
                session.sendMessage(["customAlc":alc], replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})
            }
            else if who == "default"
            {
                for i in 0..<availableMixes.count{
                    alc.append(availableMixes[i].ingredients.contains(where: {$0.drinkType.drinkGroup.alcoholic})) //if one ingredient is alcoholic, the whole mix is as well
                }
                session.sendMessage(["defaultAlc":alc], replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})
            }
        }
        else if let drinkInfo = message["percentage"] as? String
        {
            var percentages = [Int]()
            /*search customuserMixes and availableMixes for the mix matching the submitted mixId*/
            let mix1 = availableMixes.first(where: {mix in
                mix.mix == drinkInfo
            })
            
            let mix2 = customUserMixes.first(where: {mix in
                mix.mix == drinkInfo
            })
            if let mix = mix1
            {
                for i in 0..<mix.ingredients.count
                {
                    percentages.append(mix.ingredients[i].percentage)
                }
            }
            else if let mix = mix2
            {
                for i in 0..<mix.ingredients.count
                {
                    percentages.append(mix.ingredients[i].percentage)
                }
            }
            else
            {
                fatalError()
            }
            session.sendMessage(["percentage": percentages], replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})
        }
        else if let order = message["order"] as? String {
            let mixToOrder1 = availableMixes.first(where: {mix in
                mix.mix == order
            })
            
            let mixToOrder2 = customUserMixes.first(where: {mix in
                mix.mix == order
            })
            if let mixToOrder = mixToOrder1
            {
                orderMix(mixToOrder: mixToOrder, glasssize: 330, callback: {success in
                    if let orderStatus = success
                    {
                        session.sendMessage(["orderStatus" : orderStatus], replyHandler: nil, errorHandler: {
                            error in
                            print(error.localizedDescription)
                        })
                    }
                })
            }
            else if let mixToOrder = mixToOrder2
            {
                orderMix(mixToOrder: mixToOrder, glasssize: 330, callback: {success in
                    if let orderStatus = success
                    {
                        session.sendMessage(["orderStatus" : orderStatus], replyHandler: nil, errorHandler: {
                            error in
                            print(error.localizedDescription)
                        })
                    }
                })
            }
            else if let send = message["mixes"] as? String
            {
                if send == "custom"
                {
                    sendMixes(custom: true)
                }
                else if send == "default"
                {
                    sendMixes(custom: false)
                }
            }
        }
    }
    
    // MARK: - Initializer Function
    
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
        URL_ORDER_MIX = BASE_URL + "orderedMix.php"
        URL_AVAILABLE_DRINK_TYPES = BASE_URL + "availableDrinkTypes.php"
        URL_AVAILABLE_DRINK_GROUPS = BASE_URL + "availableDrinkGroups.php"
        URL_GET_CUSTOM_MIXES_ROOT = BASE_URL + "getCustomMixesRoot.php"
        URL_GET_CUSTOM_MIXES_ING = BASE_URL + "getCustomMixesIng.php"
        URL_CUSTOM_MIX = BASE_URL + "customMix.php"
        URL_CHECK_NOTIFICATIONS = BASE_URL + "checkNoifications.php"
        URL_REMOVE_ORDERED_MIX = BASE_URL + "removeOrderedMix.php"
        
        /*watch connectivity stuff*/
        session = .default
        super.init()
        session.delegate = self
        session.activate()
        
        /*core data stuff*/
        NSKeyedArchiver.setClassName("Mix", for: Mix.self)
        NSKeyedArchiver.setClassName("Drink", for: Drink.self)
        NSKeyedArchiver.setClassName("DrinkType", for: DrinkType.self)
        NSKeyedArchiver.setClassName("DrinkGroup", for: DrinkGroup.self)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4
        configuration.timeoutIntervalForResource = 4
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        getAvailableDrinkGroups
            {
                success in
                self.getAvailableDrinkTypes{
                    success1 in
                }
        }
    }
    
    deinit {
        self.stopTimer()
    }
    
    // MARK: - Timer Functions
    
    public func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkNotifications), userInfo: nil, repeats: true)
    }
    
    public func stopTimer(){
        timer.invalidate()
    }
    
    // MARK: - Notification Functions
    
    @objc public func checkNotifications(){
        let parameters: Parameters=[
            "User": defaultValues.object(forKey: "userid") as! String
        ]
        
        alamoFireManager.request(URL_CHECK_NOTIFICATIONS, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSArray
                    
                    for notifictaion in jsonData{
                        let notificationInfo = notifictaion as! NSDictionary
                        let pushNotification = UNMutableNotificationContent()
                        pushNotification.title = notificationInfo.object(forKey: "Title") as! String
                        pushNotification.body = notificationInfo.object(forKey: "Message") as! String
                        pushNotification.sound = UNNotificationSound.default()
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: self.getNewUUID(), content: pushNotification, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                            if let error = error {
                                print(error)
                            }
                        })
                    }
                }
        }
    }
    
    // MARK: - User Rights Functions
    
    public func hasUserRight(right: Int) -> Bool{
        return (UserDefaults.standard.integer(forKey: "userrights") & right) > 0
    }
    
    // MARK: - Account Functions
    
    public func login(username:String, password:String, callback: @escaping (_ response: String?) -> Void){
        let parameters: Parameters=[
            "username": username,
            "password": password
        ]
        alamoFireManager.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        
                        let userId = user.value(forKey: "id") as! String
                        let userName = user.value(forKey: "username") as! String
                        let userFirstname = user.value(forKey: "firstname") as! String
                        let userLastname = user.value(forKey: "lastname") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        let userRights = user.value(forKey: "rights") as! Int
                        
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userFirstname, forKey: "userfirstname")
                        self.defaultValues.set(userLastname, forKey: "userlastname")
                        self.defaultValues.set(userRights, forKey: "userrights")
                        
                        if((userRights & Rights.canLogin.rawValue) <= 0){
                            callback("You are not allowed to Login!")
                        }
                        
                        self.checkNotifications()
                        self.initTimer()
                        
                        UserDefaults.standard.set(false, forKey: "loggedOut" )
                        
                        callback("A")
                    }else{
                        callback("Wrong username or password")
                    }
                }
        }
    }
    
    public func loginAsGuest(callback: @escaping (_ success: Bool?) -> Void){
        self.defaultValues.set("00000000-0000-0000-0000-000000000000", forKey: "userid")
        self.defaultValues.set("Guest", forKey: "username")
        self.defaultValues.set("", forKey: "useremail")
        self.defaultValues.set("Guest", forKey: "userfirstname")
        self.defaultValues.set("Guest", forKey: "userlastname")
        self.defaultValues.set(1, forKey: "userrights")
        self.initTimer()
        UserDefaults.standard.set(false, forKey: "loggedOut" )
        callback(true)
    }
    
    public func register(username:String, firstname:String, lastname:String, email:String, password:String, callback: @escaping (_ success: String?) -> Void){
        
        let parameters: Parameters=[
            "username": username,
            "password": password,
            "firstname": firstname,
            "lastname": lastname,
            "email": email
        ]
        
        alamoFireManager.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let retMessage = jsonData.value(forKey: "message") as? String
                    callback(retMessage)
                }else{
                    callback("ERROR")
                }
        }
    }
    
    /* saves user data, stops timer and sends logout message to watch*/
    public func logout()
    {
        let username = UserDefaults.standard.string(forKey: "username")
        let hasData = UserDefaults.standard.bool(forKey: "hasData")
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        if username != "Guest"
        {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(hasData, forKey: "hasData")
        }
        UserDefaults.standard.set(true, forKey: "loggedOut" )
        
        stopTimer()
        
        //TODO send logout message to watch
    }
    
    // MARK: - Available Ingredient and Mixes Functions
    
    public func getAvailableDrinkGroups(callback: @escaping (_ success: Bool?) -> Void){
        alamoFireManager.request(self.URL_AVAILABLE_DRINK_GROUPS).responseJSON
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
        alamoFireManager.request(self.URL_AVAILABLE_DRINK_TYPES).responseJSON
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
        alamoFireManager.request(self.URL_AVAILABLE_INGREDIENTS_TYPE).responseJSON
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
                    self.alamoFireManager.request(self.URL_AVAILABLE_INGREDIENTS_DRINK).responseJSON{
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
        alamoFireManager.request(self.URL_AVAILABLE_MIXES_ROOT).responseJSON
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
                    self.alamoFireManager.request(self.URL_AVAILABLE_MIXES_ING).responseJSON{
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
                            self.sendMixes(custom: true)
                            callback(true)
                        }else{
                            callback(false)
                        }
                    }
                }
        }
    }
    
    // MARK: - Custom Mixes Functions
    
    public func getCustomMixes(callback: @escaping (_ success: Bool?) -> Void){
        
        alamoFireManager.request(self.URL_GET_CUSTOM_MIXES_ROOT).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.customMixes = Array()
                    let rootArray = result as! NSArray
                    for root in rootArray{
                        let mixDictionary = root as! NSDictionary
                        let tmpMix = mixDictionary.object(forKey: "CustomMix") as! String
                        let tmpMixDescription = mixDictionary.object(forKey: "Description") as! String
                        let tmpOrderedByUser = mixDictionary.object(forKey: "User") as! String
                        let tmpCustomMix = Mix(mix: tmpMix, mixDescription: tmpMixDescription, ingredients: [Drink](), orderedByUser: tmpOrderedByUser)
                        self.customMixes.append(tmpCustomMix)
                    }
                    self.alamoFireManager.request(self.URL_GET_CUSTOM_MIXES_ING).responseJSON{
                        response1 in
                        if let result1 = response1.result.value{
                            let ingArray = result1 as! NSArray
                            for ing in ingArray{
                                let ingDic = ing as! NSDictionary
                                let ingRoot = ingDic.object(forKey: "Root") as! String
                                let ingGUID = ingDic.object(forKey: "Reference") as! String
                                let ingPercentage = Int(ingDic.object(forKey: "Percentage") as! String)
                                let ingAFO = Int(ingDic.object(forKey: "AFO") as! String)
                                for rootToFill in self.customMixes where rootToFill.mix == ingRoot{
                                    let ingToChange = self.availableIngredients.first(where: {$0.drink == ingGUID})?.clone()
                                    ingToChange?.percentage = ingPercentage!
                                    ingToChange?.AFO = ingAFO!
                                    rootToFill.ingredients.append(ingToChange!)
                                }
                            }
                            self.customUserMixes = Array()
                            for mix in self.customMixes{
                                if(mix.orderedByUser == UserDefaults.standard.object(forKey: "userid") as! String){
                                    self.customUserMixes.append(mix.clone())
                                }
                            }
                            /*send customUserMixes to Watch*/
                            self.sendMixes(custom: false)
                            
                            callback(true)
                        }else{
                            callback(false)
                        }
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
        
        alamoFireManager.request(URL_CUSTOM_MIX, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    callback(jsonData.value(forKey: "message") as? String)
                }
        }
    }
    
    // MARK: - Ordered Mixes Functions
    
    public func getOrderedMixes(callback: @escaping (_ success: Bool?) -> Void){
        alamoFireManager.request(self.URL_ORDERED_MIXES_ROOT).responseJSON
            {
                response in
                if let result = response.result.value {
                    self.orderedMixes = Array()
                    let rootArray = result as! NSArray
                    for root in rootArray{
                        let mixDictionary = root as! NSDictionary
                        let tmpMix = mixDictionary.object(forKey: "Mix") as! String
                        let tmpOrderedByUser = mixDictionary.object(forKey: "User") as! String
                        if let orderedMix = self.availableMixes.first(where: {$0.mix == tmpMix}){
                            let orderedMixToSave = orderedMix.clone()
                            orderedMixToSave.orderedByUser = tmpOrderedByUser
                            self.orderedMixes.append(orderedMixToSave)
                        }else{
                            if let orderedCustomMix = self.customMixes.first(where: {$0.mix == tmpMix}){
                                let orderedCustomMixToSave = orderedCustomMix.clone()
                                orderedCustomMixToSave.orderedByUser = tmpOrderedByUser
                                self.orderedMixes.append(orderedCustomMixToSave)
                            }
                        }
                    }
                    self.alamoFireManager.request(self.URL_ORDERED_MIXES_ING).responseJSON{
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
    
    public func orderMix(mixToOrder: Mix, glasssize: Int, callback: @escaping (_ success: String?) -> Void){
        let ingredientsJSON: String = JSONSerializer.toJson(mixToOrder.ingredients)
        let index = ingredientsJSON.index(ingredientsJSON.startIndex, offsetBy: 8)
        let ingredients = ingredientsJSON[index...]
        
        let parameters: Parameters=[
            "Mix": mixToOrder.mix,
            "Description": mixToOrder.mixDescription,
            "Ingredients": ingredients,
            "User": defaultValues.object(forKey: "userid") as! String,
            "Add": 1,
            "GlassSize": glasssize
        ]
        
        Alamofire.request(URL_ORDER_MIX, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    print(jsonData.value(forKey: "message") as? String ?? "as")
                    callback(jsonData.value(forKey: "message") as? String)
                }
        }
    }
    
    public func removeOrderedMix(mixToRemove: Mix, title: String, reason: String, callback: @escaping (_ success: String?) -> Void){
        
        let parameters: Parameters=[
            "Mix": mixToRemove.mix,
            "Title": title,
            "Reason": reason,
            "Add":0,
            "OrderedByUser": mixToRemove.orderedByUser,
            ]
        
        Alamofire.request(URL_REMOVE_ORDERED_MIX, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    print(jsonData.value(forKey: "message") as? String ?? "as")
                    callback(jsonData.value(forKey: "message") as? String)
                }
        }
    }
    
    // MARK: - User Functions
    
    public func getUseres(callback: @escaping (_ success: Bool?) -> Void){
        alamoFireManager.request(URL_USER_INFO).responseJSON{
            response in
            if let result = response.result.value{
                self.users = Array()
                let jsonData = result as! NSArray
                for user in jsonData{
                    let userDic = user as! NSDictionary
                    let tmpUser = userDic.object(forKey: "User") as! String
                    let tmpUsername = userDic.object(forKey: "Username") as! String
                    let tmpFirstname = userDic.object(forKey: "Firstname") as! String
                    let tmpLastname = userDic.object(forKey: "Lastname") as! String
                    let tmpEmail = userDic.object(forKey: "Email") as! String
                    let tmpRights = Int(userDic.object(forKey: "Rights") as! String)
                    self.users.append(User(user: tmpUser, username: tmpUsername, firstname: tmpFirstname, lastname: tmpLastname, email: tmpEmail, rights: tmpRights!))
                }
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
    // MARK: - Generate UUID
    
    public func getNewUUID() -> String{
        return UUID.init().uuidString.lowercased()
    }
}
