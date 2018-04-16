import UIKit

class OrderedMixTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MixDescriptionLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    var orderedMix: Mix?
    var controller: OrderedMixesController?
    
    @IBAction func AcceptButton(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to accept the Mix?", message: "The Mix (" + (orderedMix?.mixDescription)! + ") was ordered by " + (Service.shared.users.first(where: {$0.user == orderedMix?.orderedByUser})?.username)!, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        controller?.present(alert, animated: true)
        /*Service.shared.orderMix(mixToOrder: orderedMix!, add: false){
            message in
        }*/
    }
    
    @IBAction func DeclineButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Do you want du decline the Mix?", message: "The Mix (" + (orderedMix?.mixDescription)! + ") was ordered by " + (Service.shared.users.first(where: {$0.user == orderedMix?.orderedByUser})?.username)! + "\nReason for decline:", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            
            //self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        controller?.present(alertController, animated: true, completion: nil)
        /*Service.shared.orderMix(mixToOrder: orderedMix!, add: false){
            message in
        }*/
    }
}
