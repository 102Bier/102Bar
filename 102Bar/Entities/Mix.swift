import Foundation

class Mix: NSObject, NSCoding {
    
    // MARK: - Variables
    
    var groupId: String = ""
    var mix: String = ""
    var mixDescription: String = ""
    var ingredients: [Drink]!
    var orderedByUser: String = ""
    var glassSize: Int = 0
    
    // MARK: - Encode Function
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mix, forKey: "mix")
        aCoder.encode(mixDescription, forKey: "mixDescription")
        aCoder.encode(ingredients, forKey: "ingredients")
        aCoder.encode(orderedByUser, forKey: "orderedByUser")
    }
    
    // MARK: - Initializer Function

    required init?(coder aDecoder: NSCoder) {
        mix = aDecoder.decodeObject(forKey: "mix") as! String
        mixDescription = aDecoder.decodeObject(forKey: "mixDescription") as! String
        ingredients = aDecoder.decodeObject(forKey: "ingredients") as! [Drink]?
        orderedByUser = aDecoder.decodeObject(forKey: "orderedByUser") as! String
    }
    
    init(mix: String, mixDescription: String, ingredients: [Drink]){
        self.mix = mix
        self.mixDescription = mixDescription
        self.ingredients = ingredients
    }
    
    init(mix: String, mixDescription: String)
    {
        self.mix = mix
        self.mixDescription = mixDescription
        self.ingredients = Array()
    }
    
    init(mix: String, mixDescription: String, ingredients: [Drink], orderedByUser: String){
        self.mix = mix
        self.mixDescription = mixDescription
        self.ingredients = ingredients
        self.orderedByUser = orderedByUser
    }
    
    init(mix: String, mixDescription: String, ingredients: [Drink], orderedByUser: String, glassSize: Int, groupId: String){
        self.mix = mix
        self.mixDescription = mixDescription
        self.ingredients = ingredients
        self.orderedByUser = orderedByUser
        self.glassSize = glassSize
        self.groupId = groupId
    }
    
    // MARK: - Clone Functions
    
    func clone() -> Mix{
        return Mix(mix: self.mix, mixDescription: self.mixDescription, ingredients: self.cloneIngArray(), orderedByUser: self.orderedByUser, glassSize: self.glassSize, groupId: self.groupId)
    }
    
    func cloneIngArray() -> [Drink]{
        var ret: [Drink] = []
        for ing in self.ingredients{
            ret.append(ing.clone())
        }
        return ret
    }
}
