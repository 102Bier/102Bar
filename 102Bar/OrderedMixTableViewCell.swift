import UIKit

class OrderedMixTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MixDescriptionLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    var orderedMix: Mix?
    var controller: OrderedMixesController?
    
    @IBAction func AcceptButton(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to accept the Mix?", message: "The Mix (" + (orderedMix?.mixDescription)! + ") was ordered by " + (Service.shared.users.first(where: {$0.user == orderedMix?.orderedByUser})?.username)!, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            Service.shared.removeOrderedMix(mixToRemove: self.orderedMix!,title: "Your Mix will be served", reason: "A Barkeeper accepted your mix and will serve it to you."){
                success in
                self.controller?.refresh(nil)
            }
        }
        
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        controller?.present(alert, animated: true)
    }
    
    @IBAction func DeclineButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Do you want du decline the Mix?", message: "The Mix (" + (orderedMix?.mixDescription)! + ") was ordered by " + (Service.shared.users.first(where: {$0.user == orderedMix?.orderedByUser})?.username)! + "\nReason for decline:", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if let reason = alertController.textFields?[0].text {
                Service.shared.removeOrderedMix(mixToRemove: self.orderedMix!,title: "Your Mix was declined!", reason: reason){
                    success in
                    self.controller?.refresh(nil)
                }
            }else{
                Service.shared.removeOrderedMix(mixToRemove: self.orderedMix!, title: "Your Mix was declined!", reason: "Your Mix was declined by a barkeeper!"){
                    success in
                    self.controller?.refresh(nil)
                }
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Reason"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        controller?.present(alertController, animated: true, completion: nil)
    }
}
