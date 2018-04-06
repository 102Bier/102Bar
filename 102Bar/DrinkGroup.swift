import Foundation

class DrinkGroup: NSObject {
    
    var drinkGroup: String = ""
    var drinkGroupDescription: String = ""
    var alcoholic: Bool = false
    
    init(drinkGroup: String, drinkGroupDescription: String, alcoholic: Bool){
        self.drinkGroup = drinkGroup
        self.drinkGroupDescription = drinkGroupDescription
        self.alcoholic = alcoholic
    }
}
