import UIKit


class BarkeeperController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()
        service.getAvailableDrinkGroups
            {
                success in
                service.getAvailableDrinkTypes()
        }
    }
}
