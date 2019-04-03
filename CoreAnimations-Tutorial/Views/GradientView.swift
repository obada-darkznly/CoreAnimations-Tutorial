//
//  GradientView.swift
//  CoreAnimations-Tutorial
//
//  Created by obada darkznly on 4/3/19.
//  Copyright © 2019 obada darkznly. All rights reserved.
//

import UIKit



class GradientView: UIView {
  
  // MARK: Assets
  let gradientLayer = CAGradientLayer()
  var gradientSet = [[CGColor]]()
  var currentGradient: Int = 0
  
  let firstColor = UIColor.blue.cgColor
  let secondColor = UIColor.red.cgColor
  let thirdColor = UIColor.yellow.cgColor
  
  // View's life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    createGradientView()
  }
  
  
  //Creats the gradientView
  func createGradientView() {
    // Creating 3 different layers of color
    gradientSet.append([firstColor, secondColor])
    gradientSet.append([secondColor, thirdColor])
    gradientSet.append([thirdColor, firstColor])
    
    // Setting the gradient over the entire screen
    gradientLayer.frame = self.layer.frame
    gradientLayer.colors = gradientSet[currentGradient]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.drawsAsynchronously = true
    
    self.layer.insertSublayer(gradientLayer, at: 0)
    animateGradient()
  }
  
  func animateGradient() {
    // Cycle through all the colors in the gradient set
    if currentGradient < gradientSet.count - 1 {
      currentGradient += 1
    } else {
      currentGradient = 0
    }
    
    // animate for 3 seconds
    let gradientChangeAnimation = CABasicAnimation(keyPath: "color")
    gradientChangeAnimation.duration = 1
    gradientChangeAnimation.toValue = gradientSet[currentGradient]
    gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
    gradientChangeAnimation.isRemovedOnCompletion = false
    gradientChangeAnimation.delegate = self
    gradientLayer.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
  }
}

extension GradientView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      gradientLayer.colors = gradientSet[currentGradient]
      animateGradient()
    }
  }
}
