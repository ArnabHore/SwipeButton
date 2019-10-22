//
//  ViewController.swift
//  SwipeButton
//
//  Created by Arnab Hore on 22/10/19.
//  Copyright © 2019 Arnab Hore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainSwipeButton: SwipeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainSwipeButton.swipeButtonDelegate = self
    }
}

extension ViewController: SwipeButtonDelegate {
    func didSwiped() {
        mainSwipeButton.reset()
    }
}
