//
//  ingredCell.swift
//  102Bar
//
//  Created by Justin Busse on 10.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit
class ingredCell : UITableViewCell {
    @IBOutlet var mixTitle: UILabel!
    
    func addLabel(ingredient: String, yPos : Int)
    {
        let safeAreaWidth = safeAreaLayoutGuide.layoutFrame.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 30 + (25 * (yPos+1)), width: Int(safeAreaWidth - 25), height: 25))
        label.text = ingredient
        self.addSubview(label)
    }
}
