import UIKit
import Alamofire

class BarkeeperController : UIViewController{
    
    let URL_ORDERED_MIXES = "http://102bier.de/102bar/orderedMixes.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(self.URL_ORDERED_MIXES).responseJSON
            {
                response in
                print(response)
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        
                    }else{
                        //error message in case of invalid credential
                    }
                }
        }
    }
}
