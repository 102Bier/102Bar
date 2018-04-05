import Foundation

class Drink: NSObject {
    
    var drinkId: Int = 0
    var drinkTypeId: Int = 0
    var drinkDescription: String = ""
    var percentage = 0
    
    init(description: String, percentage: Int)
    {
        self.drinkDescription = description
        self.percentage = percentage
    }
    
}
