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
    
    func addOrReplaceLabel(ingredient: String, yPos: Int)
    {
        var labels : [UILabel] = Array()
        for i in 0..<self.subviews.count
        {
            if self.subviews[i] is UILabel
            {
                labels.append(self.subviews[i] as! UILabel)
            }
        }
        
        let safeAreaWidth = safeAreaLayoutGuide.layoutFrame.size.width
        let labelRect = CGRect(x: 15, y: 30 + (25 * (yPos+1)), width: Int(safeAreaWidth - 25), height: 25)
        
        for i in 0..<labels.count
        {
            if labels[i].frame.origin == labelRect.origin
            {
                labels[i].text = ingredient
                return
            }
        }
        
        let label = UILabel(frame: labelRect)
        label.text = ingredient
        self.addSubview(label)
    }
}
