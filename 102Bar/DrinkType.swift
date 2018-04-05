import Foundation

class DrinkType: NSObject {
    
    var drinkType: String = ""
    var drinkGroup: DrinkGroup!
    var drinkTypeDescription: String = ""
    
    init(drinkType: String, drinkGroup: DrinkGroup, drinkTypeDescription: String) {
        self.drinkType = drinkType
        self.drinkGroup = drinkGroup
        self.drinkTypeDescription = drinkTypeDescription
    }
}
