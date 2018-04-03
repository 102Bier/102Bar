import Foundation

class Drink: NSObject {
    
    var drinkId: Int = 0
    var drinkTypeId: Int = 0
    var drinkDescription: String = ""
    var percentage : Float = 0.0
    
    init(description: String, percentage: Float)
    {
        self.drinkDescription = description
        self.percentage = percentage
    }
    
}
