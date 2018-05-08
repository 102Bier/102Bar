import Foundation

class Drink: NSObject, NSCoding {
    
    // MARK: - Variables
    
    var drink: String = ""
    var drinkType: DrinkType!
    var drinkDescription: String = ""
    var percentage: Int = 0
    var AFO: Int = 0
    var connection: Int = 0
    
    // MARK: - Encode Function
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drink, forKey: "drink")
        aCoder.encode(drinkType, forKey: "drinkType")
        aCoder.encode(drinkDescription, forKey: "drinkDescription")
        aCoder.encode(percentage, forKey: "percentage")
        aCoder.encode(AFO, forKey: "AFO")
        aCoder.encode(connection, forKey: "connection")
    }
    
    // MARK: - Initializer Functions
    
    required init?(coder aDecoder: NSCoder) {
        drink = aDecoder.decodeObject(forKey: "drink") as! String
        drinkType = aDecoder.decodeObject(forKey: "drinkType") as! DrinkType?
        drinkDescription = aDecoder.decodeObject(forKey: "drinkDescription") as! String
        //percentage = aDecoder.decodeObject(forKey: "percentage") as! Int
        percentage = 100
        //AFO = aDecoder.decodeObject(forKey: "AFO") as! Int
        AFO = 1
        //connection = aDecoder.decodeObject(forKey: "connection") as! Int
        connection = 0
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
    
    // MARK: - Clone Function
    
    func clone() -> Drink {
        return Drink(drink: self.drink, drinkType: self.drinkType, drinkDescription: self.drinkDescription, percentage: self.percentage, AFO: self.AFO, connection: self.connection)
    }
    
    // MARK: - ToString Function
    
    func toString() -> String {
        return drinkDescription == drinkType.drinkTypeDescription ? drinkDescription : "\(drinkType.drinkTypeDescription) (\(drinkDescription))"
    }
    
}
