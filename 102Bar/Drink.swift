import Foundation

class Drink: NSObject {
    
    var drink: String = ""
    var drinkType: DrinkType!
    var drinkDescription: String = ""
<<<<<<< HEAD
    //var percentage = 0
=======
    var percentage: Int = 0
    var AFO: Int = 0
>>>>>>> 5b7d5ab9d13d8aca61830664f7377cab77925035
    
    init(description: String, percentage: Int)
    {
        self.drinkDescription = description
        self.percentage = percentage
    }
    
    init(drink: String, drinkType: DrinkType, drinkDescription: String, percentage: Int, AFO: Int){
        self.drink = drink
        self.drinkType = drinkType
        self.drinkDescription = drinkDescription
        self.percentage = percentage
        self.AFO = AFO
    }
    
    func clone() -> Drink {
        return Drink(drink: self.drink, drinkType: self.drinkType, drinkDescription: self.drinkDescription, percentage: self.percentage, AFO: self.AFO)
    }
    
}
