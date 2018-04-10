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
    
    func clone() -> Mix{
        return Mix(mix: self.mix, mixDescription: self.mixDescription, ingredients: self.ingredients)
    }
}
