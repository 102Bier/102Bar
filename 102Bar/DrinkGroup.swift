import Foundation

class DrinkGroup: NSObject, NSCoding {
    
    var drinkGroup: String = ""
    var drinkGroupDescription: String = ""
    var alcoholic: Bool = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drinkGroup, forKey: "drinkGroup")
        aCoder.encode(drinkGroupDescription, forKey: "drinkGroupDescription")
        aCoder.encode(alcoholic, forKey: "alcoholic")
    }
    
    required init?(coder aDecoder: NSCoder) {
        drinkGroup = aDecoder.decodeObject(forKey: "drinkGroup") as! String
        drinkGroupDescription = aDecoder.decodeObject(forKey: "drinkGroupDescription") as! String
        alcoholic = aDecoder.decodeObject(forKey: "alcoholic") as! Bool
    }
    
    init(drinkGroup: String, drinkGroupDescription: String, alcoholic: Bool){
        self.drinkGroup = drinkGroup
        self.drinkGroupDescription = drinkGroupDescription
        self.alcoholic = alcoholic
    }
}
