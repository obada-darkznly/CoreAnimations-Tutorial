//
//  CountdownProgressBar.swift
//  CoreAnimations-Tutorial
//
//  Created by obada darkznly on 4/3/19.
//  Copyright © 2019 obada darkznly. All rights reserved.
//

import UIKit



class CountDownProgressBar: UIView {
  
  // MARK: Properties
  
  // Timer stuff
  private var timer = Timer()
  
  private var duration = 5.0
  private var remainingTime = 0.0
  private var showPulse = false
  
  // Label stuff
  private lazy var remainingTimeLabel: UILabel = {
    let _remainingTimeLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bounds.width, height: bounds.height)))
    _remainingTimeLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    _remainingTimeLabel.textAlignment = .center
    return _remainingTimeLabel
  }()
  
  // forground layer that will be animated
  private lazy var foregroundLayer: CAShapeLayer = {
    let _foregroundLayer = CAShapeLayer()
    _foregroundLayer.lineWidth = 10
    _foregroundLayer.strokeColor = UIColor.black.cgColor
    _foregroundLayer.lineCap = .round
    _foregroundLayer.fillColor = UIColor.clear.cgColor
    _foregroundLayer.strokeEnd = 0
    _foregroundLayer.frame = bounds
    return _foregroundLayer
  }()
  
  // Gradient for the forground layer
  private lazy var forgroundGradientLayer: CAGradientLayer = {
    let _forgroundGradientLayer = CAGradientLayer()
    let startColor = UIColor.red.withAlphaComponent(0.5).cgColor
    let secondColor = UIColor.yellow.withAlphaComponent(0.5).cgColor
    _forgroundGradientLayer.colors = [startColor, secondColor]
    _forgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0)
    _forgroundGradientLayer.endPoint = CGPoint(x: 1, y: 1)
    _forgroundGradientLayer.frame = bounds
    return _forgroundGradientLayer
  }()
  
  // background layer to show a gray path
  private lazy var backgroundLayer: CAShapeLayer = {
    let _backgroundLayer = CAShapeLayer()
    _backgroundLayer.lineWidth = 10
    _backgroundLayer.strokeColor = UIColor.lightGray.cgColor
    _backgroundLayer.lineCap = .round
    _backgroundLayer.fillColor = UIColor.clear.cgColor
    _backgroundLayer.frame = bounds
    return _backgroundLayer
  }()
  
  // Layer that'll handle the pulsing
  private lazy var pulseLayer: CAShapeLayer = {
    let _pulseLayer = CAShapeLayer()
    _pulseLayer.lineWidth = 10
    _pulseLayer.strokeColor = UIColor.lightGray.cgColor
    _pulseLayer.lineCap = .round
    _pulseLayer.fillColor = UIColor.lightGray.cgColor
    _pulseLayer.frame = bounds
    return _pulseLayer
  }()
  
  // Gradient layer for the pulse layer
  private lazy var pulseGradientLayer: CAGradientLayer = {
    let _pulseGradientLayer = CAGradientLayer()
    let firstColor = UIColor.red
    let secondColor = UIColor.yellow
    _pulseGradientLayer.colors = [firstColor, secondColor]
    _pulseGradientLayer.startPoint = CGPoint(x: 0, y: 0)
    _pulseGradientLayer.endPoint = CGPoint(x: 1, y: 1)
    _pulseGradientLayer.frame = bounds
    return _pulseGradientLayer
  }()
  
  private func loadLayers() {
    // Gets the center point of the view
    let centerPoint = CGPoint(x: frame.width / 2 , y: frame.height / 2)
    // Createa a circle path that is just slightly smaller than the view
    // Set the start angle to be 90 degrees and moves 360 degrees clockwise
    let circularPath = UIBezierPath(arcCenter: centerPoint, radius: bounds.width / 2 - 20, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)
    
    pulseLayer.path = circularPath.cgPath
    pulseGradientLayer.mask = pulseLayer
    layer.addSublayer(pulseLayer)
    
    backgroundLayer.path = circularPath.cgPath
    layer.addSublayer(backgroundLayer)
    
    foregroundLayer.path = circularPath.cgPath
    foregroundLayer.mask = forgroundGradientLayer
    layer.addSublayer(foregroundLayer)
    
    addSubview(remainingTimeLabel)
    print(remainingTimeLabel.frame)
  }
  
  // Mark: Animating the layers
  private func animateForgroundLayer() {
    let forgroundAnimation = CABasicAnimation(keyPath: "strokeEnd")
    forgroundAnimation.fromValue = 0
    forgroundAnimation.toValue = 1
    forgroundAnimation.duration = CFTimeInterval(duration)
    forgroundAnimation.fillMode = CAMediaTimingFillMode.forwards
    forgroundAnimation.isRemovedOnCompletion = false
    forgroundAnimation.delegate = self
    
    foregroundLayer.add(forgroundAnimation, forKey: "forgroundAnimation")
  }
  
  private func animatePulseLayer() {
    let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
    pulseAnimation.fromValue = 1.0
    pulseAnimation.toValue = 1.2
    
    let pulseOpacityAnimation = CABasicAnimation(keyPath: "opacity")
    pulseOpacityAnimation.fromValue = 0.7
    pulseOpacityAnimation.toValue = 0.0
    
    let groupedAnimation = CAAnimationGroup()
    groupedAnimation.animations = [pulseAnimation, pulseOpacityAnimation]
    groupedAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    groupedAnimation.duration = 1.0
    groupedAnimation.repeatCount = Float(CGFloat.infinity)
    
    pulseLayer.add(groupedAnimation, forKey: "pulseAnimation")
  }
  
  private func beginAnimation() {
    animateForgroundLayer()
    
    if showPulse {
      animatePulseLayer()
    }
  }
  
  // MARK: Timer stuff
  @objc private func handleTimerTick() {
    remainingTime -= 0.1
    if remainingTime > 0 {
      
    } else {
      remainingTime = 0
      timer.invalidate()
    }
    
    DispatchQueue.main.async {
      self.remainingTimeLabel.text = "\(String.init(format: "%.1f", self.remainingTime))"
    }
  }
  
  // MARK: Public functions
  
  //MARK: - Public Functions
  
  /**
   Stars the countdown with defined duration.
   
   - Parameter duration: Countdown time duration.
   - Parameter showPulse: By default false, set to true to show pulse around the countdown progress bar.
   
   - Returns: null.
   */
  func startCountdown(duration: Double, showPulse: Bool = false) {
    self.duration = duration
    self.showPulse = showPulse
    remainingTime = duration
    remainingTimeLabel.text = "\(remainingTime)"
    timer.invalidate()
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimerTick), userInfo: nil, repeats: true)
    beginAnimation()
  }
  
  // MARK: initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadLayers()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadLayers()
  }
  
  
  deinit {
    timer.invalidate()
  }
}

extension CountDownProgressBar: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    pulseLayer.removeAllAnimations()
    timer.invalidate()
  }
}
