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
        var lableCount = -1 //to ignore the Mix Title Lable
        for i in 0..<self.subviews.count
        {
            if self.subviews[i] is UILabel
            {
                lableCount += 1
            }
        }
        if(lableCount <= yPos && self.subviews[yPos] is UILabel)
        {
            (self.subviews[yPos] as! UILabel).text = ingredient
        }
        else
        {
            let safeAreaWidth = safeAreaLayoutGuide.layoutFrame.size.width
            let label = UILabel(frame: CGRect(x: 15, y: 30 + (25 * (yPos+1)), width: Int(safeAreaWidth - 25), height: 25))
            label.text = ingredient
            self.addSubview(label)
        }
    }
}
