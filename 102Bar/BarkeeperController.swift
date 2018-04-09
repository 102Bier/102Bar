import UIKit


class BarkeeperController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(Service.shared.availableDrinkGroups)
        debugPrint(Service.shared.availableDrinkTypes)
        Service.shared.getAvailableIngredients{
            success in
            debugPrint(Service.shared.availableIngredients)
            Service.shared.getAvailableMixes{
                success in
                debugPrint(Service.shared.availableMixes)
            }
        }
        
    }
}
