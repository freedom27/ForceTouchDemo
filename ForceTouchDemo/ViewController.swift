//
//  ViewController.swift
//  ForceTouchDemo
//
//  Created by Stefano Vettor on 03/11/15.
//  Copyright © 2015 Stefano Vettor. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    func drawCircleAtLocation(location: CGPoint, withForce force: CGFloat, andBaseRadius baseRadius: CGFloat) {
        let finalRadius = baseRadius*1.2 + (force * 70)
        
        let hue = (1.0-force) / 3.0
        let baseColor = UIColor(hue: hue, saturation:1.0, brightness:1.0, alpha:1.0)
        fillColor = baseColor.CGColor
        
        let origin = CGPoint(x: location.x - finalRadius, y: location.y - finalRadius)
        path = UIBezierPath(
            ovalInRect: CGRect(
                origin: origin,
                size: CGSize(width: finalRadius * 2, height: finalRadius * 2))).CGPath
    }
    
}

class ViewController: UIViewController {
    
    var circles = [UITouch: CAShapeLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.multipleTouchEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let circle = CAShapeLayer()
            
            let radius = touch.majorRadius + touch.majorRadiusTolerance
            let forcePercentage = touch.force / touch.maximumPossibleForce
            circle.drawCircleAtLocation(touch.locationInView(view),withForce: forcePercentage, andBaseRadius: radius)
            circles[touch] = circle
            view.layer.addSublayer(circle)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches where circles[touch] != .None
        {
            let circle = circles[touch]!
            let radius = touch.majorRadius + touch.majorRadiusTolerance
            let forcePercentage = touch.force / touch.maximumPossibleForce
            circle.drawCircleAtLocation(touch.locationInView(view),withForce: forcePercentage, andBaseRadius: radius)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let circle = circles[touch];
            circle?.removeFromSuperlayer();
            circles.removeValueForKey(touch)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        guard let touches = touches else { return }
        
        for touch in touches where circles[touch] != .None {
            let circle = circles[touch]!
            circle.removeFromSuperlayer()
            circles.removeValueForKey(touch)
        }
    }
    
}

