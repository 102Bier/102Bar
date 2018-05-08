import UIKit

class MainTabBarController: UITabBarController{
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!Service.shared.hasUserRight(right: Service.Rights.canOmit.rawValue)){
            viewControllers?.remove(at: 1)
        }
    }
}
