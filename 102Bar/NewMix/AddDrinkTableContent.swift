import Foundation

class AddDrinkTableContent {
    
    // MARK: - Variables
    
    var percentages : [String]
    struct SectionAndObjects {
        var sectionName : String!
        var sectionObjects : [String]!
        var sectionPercentage : [String]!
    }
    var mixName: String!
    var ingredArray = [SectionAndObjects]()
    let helpText = "Drag here to add"
    let noMoreIngredientsText = "You greedy little bitch"
    
    // MARK: - Initializing Function
    
    init()
    {
        /****** When object <--> DB works*/
         var availableIngredients : [String]! = Array()
        Service.shared.availableIngredients.forEach({availableIngredients.append($0.drinkDescription)})

        let selectedIngredients : [String] = [helpText]
        percentages = ["0", "0", "0", "0", "0", "0", "0", "0"]
        let initialPercentages : [String] = ["0"]
        
        ingredArray = [SectionAndObjects(sectionName: "Selected ingredients", sectionObjects: selectedIngredients, sectionPercentage : initialPercentages), SectionAndObjects(sectionName: "Available ingredients", sectionObjects: availableIngredients, sectionPercentage : percentages)]
        mixName = "someName"
    }
}
