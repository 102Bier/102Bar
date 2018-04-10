//
//  TestViewController.swift
//  102Bar
//
//  Created by Christof Metzger on 10.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Service.shared.getAvailableIngredients{
            su in
            Service.shared.getAvailableMixes{
                te in
                for root in Service.shared.availableMixes{
                    debugPrint(root.mix)
                    debugPrint(root.mixDescription)
                    for ing in root.ingredients{
                        debugPrint(ing.toString())
                        debugPrint(ing.AFO)
                        debugPrint(ing.percentage)
                    }
                }
            }
        }
    }
}
