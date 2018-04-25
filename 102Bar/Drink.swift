import Foundation

class Drink: NSObject, NSCoding {
    
    var drink: String = ""
    var drinkType: DrinkType!
    var drinkDescription: String = ""
    var percentage: Int = 0
    var AFO: Int = 0
    var connection: Int = 0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drink, forKey: "drink")
        aCoder.encode(drinkType, forKey: "drinkType")
        aCoder.encode(drinkDescription, forKey: "drinkDescription")
        aCoder.encode(percentage, forKey: "percentage")
        aCoder.encode(AFO, forKey: "AFO")
        aCoder.encode(connection, forKey: "connection")
    }
    
    required init?(coder aDecoder: NSCoder) {
        drink = aDecoder.decodeObject(forKey: "drink") as! String
        drinkType = aDecoder.decodeObject(forKey: "drinkType") as! DrinkType?
        drinkDescription = aDecoder.decodeObject(forKey: "drinkDescription") as! String
        percentage = aDecoder.decodeObject(forKey: "percentage") as! Int
        AFO = aDecoder.decodeObject(forKey: "AFO") as! Int
        connection = aDecoder.decodeObject(forKey: "connection") as! Int
    }
    
    init(drink: String, drinkType: DrinkType, drinkDescription: String){
        self.drink = drink
        self.drinkType = drinkType
        self.drinkDescription = drinkDescription
    }
    
    init(drink: String, drinkType: DrinkType, drinkDescription: String, percentage: Int, AFO: Int, connection: Int){
        self.drink = drink
        self.drinkType = drinkType
        self.drinkDescription = drinkDescription
        self.percentage = percentage
        self.AFO = AFO
    }
    
    func addPercentage (percentage: Int)
    {
        self.percentage = percentage
    }
    
    func clone() -> Drink {
        return Drink(drink: self.drink, drinkType: self.drinkType, drinkDescription: self.drinkDescription, percentage: self.percentage, AFO: self.AFO, connection: self.connection)
    }
    
    func toString() -> String {
        return drinkDescription == drinkType.drinkTypeDescription ? drinkDescription : "\(drinkType.drinkTypeDescription) (\(drinkDescription))"
    }
    
}
