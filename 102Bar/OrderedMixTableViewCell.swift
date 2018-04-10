import UIKit

class OrderedMixTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MixDescriptionLabel: UILabel!
    @IBOutlet weak var IngredientsLabel: UILabel!
    
    var orderedMix: Mix?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        orderedMix = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func AcceptButton(_ sender: Any) {
        
    }
    
    @IBAction func DeclineButton(_ sender: Any) {
        
    }
}
