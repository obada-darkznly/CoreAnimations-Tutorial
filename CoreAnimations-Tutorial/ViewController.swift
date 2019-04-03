//
//  ViewController.swift
//  CoreAnimations-Tutorial
//
//  Created by obada darkznly on 4/3/19.
//  Copyright © 2019 obada darkznly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var backgroundGradientView: GradientView!
  @IBOutlet weak var countdownView: CountDownProgressBar!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    countdownView.startCountdown(duration: 10, showPulse: true)
  }
  
  @IBAction func didPressTimer(_ sender: UIButton) {
    self.countdownView.startCountdown(duration: 10, showPulse: true)
  }

}

