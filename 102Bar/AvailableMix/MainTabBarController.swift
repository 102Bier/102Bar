import UIKit

class MainTabBarController: UITabBarController{
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!Service.shared.hasUserRight(right: Service.Rights.canOmit.rawValue)){
            viewControllers?.remove(at: 2) //guest user has no statistic so tab will not show
            viewControllers?.remove(at: 1) //if user isn't allowed (no barkeeper rights) to see the ordered drinks
        }
    }
}
