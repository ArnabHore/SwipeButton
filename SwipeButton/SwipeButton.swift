//
//  SwipeButton.swift
//  SwipeButton
//
//  Created by Arnab Hore on 22/10/19.
//  Copyright © 2019 Arnab Hore. All rights reserved.
//

import UIKit

protocol SwipeButtonDelegate {
    func didSwiped()
}
class SwipeButton: UIView {
    
    private let swipeButtonMainView = UIView()
    private let swipeWhiteButton = UIButton()
    private let swipeTextLabel = UILabel()
    private var swipeWhiteButtonWidth: NSLayoutConstraint!
    private var swipeWhiteButtonLeading: NSLayoutConstraint!
    var swipeButtonDelegate: SwipeButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func didLoad() {
        self.addSubview(swipeButtonMainView)
        swipeButtonMainView.addSubview(swipeWhiteButton)
        swipeButtonMainView.addSubview(swipeTextLabel)
        
        swipeButtonMainView.backgroundColor = UIColor.red
        swipeWhiteButton.backgroundColor = UIColor.white
        swipeTextLabel.textColor = UIColor.white
        swipeTextLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        swipeTextLabel.text = "SWIPE TO CONFIRM >>"
        swipeButtonMainView.layer.cornerRadius = 25
        
        swipeWhiteButton.addTarget(self, action: #selector(wasDragged(button:with:)), for: .touchDragInside)
        swipeWhiteButton.addTarget(self, action: #selector(wasDragEnd(button:with:)), for: .touchUpInside)
        
        self.swipeButtonMainView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeWhiteButton.translatesAutoresizingMaskIntoConstraints = false
        self.swipeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.setNeedsUpdateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        swipeWhiteButton.layer.cornerRadius = swipeWhiteButton.frame.size.height/2.0
    }
    
    override func updateConstraints() {
        super.updateConstraints()
                
        let leadingMainView = NSLayoutConstraint(item: swipeButtonMainView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingMainView = NSLayoutConstraint(item: swipeButtonMainView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topMainView = NSLayoutConstraint(item: swipeButtonMainView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomMainView = NSLayoutConstraint(item: swipeButtonMainView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([leadingMainView, trailingMainView, topMainView, bottomMainView])
        
        let leadingWhiteButton = NSLayoutConstraint(item: swipeWhiteButton, attribute: .leading, relatedBy: .equal, toItem: swipeButtonMainView, attribute: .leading, multiplier: 1.0, constant: 10.0)
        let bottomWhiteButton = NSLayoutConstraint(item: swipeWhiteButton, attribute: .bottom, relatedBy: .equal, toItem: swipeButtonMainView, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        let topWhiteButton = NSLayoutConstraint(item: swipeWhiteButton, attribute: .top, relatedBy: .equal, toItem: swipeButtonMainView, attribute: .top, multiplier: 1.0, constant: 10.0)
        let widthWhiteButton = NSLayoutConstraint(item: swipeWhiteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        self.swipeButtonMainView.addConstraints([leadingWhiteButton, bottomWhiteButton, topWhiteButton, widthWhiteButton])
        swipeWhiteButtonWidth = widthWhiteButton
        swipeWhiteButtonLeading = leadingWhiteButton
        
        let trailingTextLabel = NSLayoutConstraint(item: swipeTextLabel, attribute: .trailing, relatedBy: .equal, toItem: swipeButtonMainView, attribute: .trailing, multiplier: 1.0, constant: -10.0)
        let centerYTextLabel = NSLayoutConstraint(item: swipeTextLabel, attribute: .centerY, relatedBy: .equal, toItem: swipeButtonMainView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.swipeButtonMainView.addConstraints([trailingTextLabel, centerYTextLabel])
        
        self.layoutIfNeeded()
    }
    
    @objc func wasDragged(button: UIButton, with event: UIEvent) {
        if let touch = event.touches(for: button),
            let prevLoc = touch.first?.previousLocation(in: button),
            let loc = touch.first?.location(in: button) {
            
            let increaseX = loc.x - prevLoc.x
            
            if swipeWhiteButtonLeading.constant >= swipeButtonMainView.frame.size.width - (swipeWhiteButtonWidth.constant + 10) {
                //perform button action
                self.swipeButtonAction()
            } else {
                swipeWhiteButtonLeading.constant += increaseX
                swipeTextLabel.alpha = ((swipeButtonMainView.frame.size.width - swipeWhiteButton.center.x)/swipeButtonMainView.frame.size.width)
            }
        }
    }
    
    @objc func wasDragEnd(button: UIButton, with event: UIEvent) {
        if swipeWhiteButtonLeading.constant < swipeButtonMainView.frame.size.width - (swipeWhiteButtonWidth.constant + 10) {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.swipeWhiteButtonLeading.constant = 10
                self.swipeTextLabel.alpha = 1
            }, completion: nil)
        } else if swipeWhiteButtonLeading.constant >= swipeButtonMainView.frame.size.width - (swipeWhiteButtonWidth.constant + 10) {
            self.swipeButtonAction()
        }
    }
    
    func swipeButtonAction() {
        swipeWhiteButton.removeTarget(self, action: #selector(wasDragEnd(button:with:)), for: .touchDragInside)
        self.swipeButtonDelegate?.didSwiped()
    }
    
    public func reset() {
        self.swipeWhiteButtonLeading.constant = 10
        self.swipeTextLabel.alpha = 1
        self.swipeWhiteButton.removeTarget(self, action: #selector(self.wasDragged(button:with:)), for: .touchDragInside)
        self.swipeWhiteButton.removeTarget(self, action: #selector(self.wasDragEnd(button:with:)), for: .touchUpInside)
        self.swipeWhiteButton.addTarget(self, action: #selector(self.wasDragged(button:with:)), for: .touchDragInside)
        self.swipeWhiteButton.addTarget(self, action: #selector(self.wasDragEnd(button:with:)), for: .touchUpInside)
    }
}
