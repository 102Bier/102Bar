import UIKit

class OrderMixController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    // MARK: - Variables
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var glassSizeSlider: UISlider!
    @IBOutlet var glassSizeField: UITextField!
    @IBOutlet var totalPercentageLabel: UILabel!
    
    var mixToOrder: Mix = Mix(mix: "", mixDescription: "", ingredients: Array())
    var orderMode = true
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        drinkNameLabel.text = mixToOrder.mixDescription
        if(!orderMode)
        {
            glassSizeField.isEnabled = false
            glassSizeSlider.isHidden = true
            view.constraints.first(where: { $0.identifier == "tableViewTop" })?.constant -= (glassSizeSlider.frame.height) //adjust the top constraint of the tableView to the missing slider
        }
        super.viewDidLoad()
    }
    
    // MARK: - Action Event Functions
    
    @IBAction func tableViewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func glassSizeSliderChanged(_ sender: UISlider) {
       glassSizeField.text = String(Int((480 * sender.value) + 20))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if(string.count < 1) {
            var totalPercentage : Int = Int(NSString(string: totalPercentageLabel.text!).intValue)
            if(newString == "")
            {
                newString = "0"
            }
            if var oldString = textField.text
            {
                if oldString == ""
                {
                    oldString = "0"
                }
                totalPercentage -= Int(oldString)!
                totalPercentage += Int(newString)!
                totalPercentageLabel.text = String(totalPercentage) + "%"
                return true
            }
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        var validCharacterCount : Int = 0
        if let rangeOfCharactersAllowed = string.rangeOfCharacter(from: allowedCharacters) { // if replacementText contains just valid characters
            validCharacterCount = string.distance(from: rangeOfCharactersAllowed.lowerBound, to: rangeOfCharactersAllowed.upperBound)
        }
        
        if validCharacterCount != string.count
        {
            return false
        }
        
        if(textField.tag == 0) //glassSize
        {
            if (Int(newString))! > 500 || ((Int(newString))! < 20 && newString.count > 1)
            {
                return false
            }
            else
            {
                return true
            }
        }
        else if(textField.tag == 1) //percentage
        {
            var percentageSum: Int = 0
            let topSectionPercCount = mixToOrder.ingredients.count
            if topSectionPercCount > 0
            {
                let cells = tableView.visibleCells
                var currentRow : Int?
                for i in 0..<cells.count
                {
                    if (cells[i] as! DrinkCell).percentageTextField.isFirstResponder == true
                    {
                        currentRow = i
                        break
                    }
                }
                for i in 0..<topSectionPercCount
                {
                    percentageSum += Int(mixToOrder.ingredients[i].percentage)
                }
                
                percentageSum -= Int(mixToOrder.ingredients[currentRow!].percentage)
                percentageSum += Int(newString)!
                
                if(percentageSum > 100 || percentageSum < 0)
                {
                    return false
                }
                else
                {
                    totalPercentageLabel.text = String(percentageSum) + "%"
                    return true
                }
            }
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 //glassSize
        {
            if let text = textField.text
            {
                let value = (Float(text)! / 480) - (20 / 480)
                glassSizeSlider.setValue(value,  animated: true)
            }
        }
        else if textField.tag == 1 //percentage
        {
            if textField.text != nil
            {
                //totalPercentageLabel.text = text + "%"
            }
        }
    }
    
    func orderTapped() -> Void
    {
        var txtFieldText = totalPercentageLabel.text
        txtFieldText?.removeLast()
        if Int(txtFieldText!)! != 100
        {
            let alert = UIAlertController(title: "Invalid percentage", message: "To order, the total percentage must be 100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else{
            Service.shared.orderMix(mixToOrder: mixToOrder, glasssize: Int(glassSizeField.text!)!) {_ in }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixToOrder.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderIngred") as! DrinkCell
        cell.drinkLabel.text = mixToOrder.ingredients[indexPath.row].drinkDescription
        cell.percentageTextField.text = String( mixToOrder.ingredients[indexPath.row].percentage)
        cell.percentageTextField.isEnabled = orderMode
        return cell
    }
}
