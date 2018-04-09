import UIKit


class BarkeeperController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.shared.getAvailableIngredients{
            success in
            Service.shared.getAvailableMixes{
                success in
                debugPrint(Service.shared.availableMixes)
            }
        }
        
    }
}
