import UIKit

class OrderedMixTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MixDescriptionLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    var orderedMix: Mix?
    
    @IBAction func AcceptButton(_ sender: Any) {
        /*Service.shared.orderMix(mixToOrder: orderedMix!, add: false){
            message in
        }*/
    }
    
    @IBAction func DeclineButton(_ sender: Any) {
        /*Service.shared.orderMix(mixToOrder: orderedMix!, add: false){
            message in
        }*/
    }
}
