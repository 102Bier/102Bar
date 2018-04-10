import Foundation

class Drink: NSObject {
    
    var drink: String = ""
    var drinkType: DrinkType!
    var drinkDescription: String = ""
    var percentage: Int = 0
    var AFO: Int = 0
    var connection: Int = 0
    
    init(description: String, percentage: Int)
    {
        self.drinkDescription = description
        self.percentage = percentage
        //todo: get DrinkType and stuff 
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
