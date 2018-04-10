import Foundation

class Mix: NSObject {
    var mix: String = ""
    var mixDescription: String = ""
    var ingredients: [Drink]!
    var orderedByUser: String = ""
    
    init(mix: String, mixDescription: String, ingredients: [Drink]){
        self.mix = mix
        self.mixDescription = mixDescription
        self.ingredients = ingredients
    }
    
    init(mix: String, mixDescription: String, ingredients: [Drink], orderedByUser: String){
        self.mix = mix
        self.mixDescription = mixDescription
        self.ingredients = ingredients
        self.orderedByUser = orderedByUser
    }
    
    func clone() -> Mix{
        return Mix(mix: self.mix, mixDescription: self.mixDescription, ingredients: self.cloneIngArray(), orderedByUser: self.orderedByUser)
    }
    
    func cloneIngArray() -> [Drink]{
        var ret: [Drink] = []
        for ing in self.ingredients{
            ret.append(ing.clone())
        }
        return ret
    }
}
