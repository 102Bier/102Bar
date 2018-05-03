import Foundation

class DrinkType : NSObject, NSCoding {
    
    var drinkType: String = ""
    var drinkGroup: DrinkGroup!
    var drinkTypeDescription: String = ""
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drinkType, forKey: "drinkType")
        aCoder.encode(drinkGroup, forKey: "drinkGroup")
        aCoder.encode(drinkTypeDescription, forKey: "drinkTypeDescription")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        drinkType = aDecoder.decodeObject(forKey: "drinkType") as! String
        drinkGroup = aDecoder.decodeObject(forKey: "drinkGroup") as! DrinkGroup?
        //drinkTypeDescription = aDecoder.decodeObject(forKey: "drinkDescription") as! String
        drinkTypeDescription = "hallo"
    }
    
    init(drinkType: String, drinkGroup: DrinkGroup, drinkTypeDescription: String) {
        self.drinkType = drinkType
        self.drinkGroup = drinkGroup
        self.drinkTypeDescription = drinkTypeDescription
    }
}
