import UIKit

class TestController : UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class AddedIngredientTableViewCell : UITableViewCell{
    
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var drinkPercentage: UILabel!
    
    @IBAction func PercentageSlider(_ sender: Any) {
    }
    
    @IBAction func RemoveButton(_ sender: Any) {
    }
}

class AvailableIngredientTableViewCell : UITableViewCell{
    
    @IBOutlet weak var drinkLabel: UILabel!
    
    @IBAction func AddButton(_ sender: Any) {
    }
}
