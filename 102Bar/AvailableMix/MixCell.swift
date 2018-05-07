//
//  ingredCell.swift
//  102Bar
//
//  Created by Justin Busse on 10.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit
class MixCell : UITableViewCell {
    @IBOutlet var mixTitle: UILabel!
    
    func addOrReplaceLabel(ingredient: String, yPos: Int)
    {
        var labels : [UILabel] = Array()
        for i in 0..<self.subviews.count
        {
            if self.subviews[i] is UILabel // get all UILabel
            {
                labels.append(self.subviews[i] as! UILabel)
            }
        }
        
        let safeAreaWidth = safeAreaLayoutGuide.layoutFrame.size.width
        let labelRect = CGRect(x: 15, y: 30 + (25 * (yPos+1)), width: Int(safeAreaWidth - 25), height: 25)
        
        for i in 0..<labels.count
        {
            if labels[i].frame.origin == labelRect.origin //look if at this point already exists a UILabel
            {
                labels[i].text = ingredient //if yes, just update its text
                return
            }
        }
        
        let label = UILabel(frame: labelRect) //if not, put a UILabel there
        label.text = ingredient
        self.addSubview(label)
    }
}
