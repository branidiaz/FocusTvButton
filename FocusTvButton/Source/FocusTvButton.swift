//
//  FocusTvButton.swift
//  FocusTvButton
//
//  Created by David Cordero on 01/09/16.
//  Copyright © 2016 David Cordero, Inc. All rights reserved.
//

import UIKit


public class FocusTvButton: UIButton {
    
    @IBInspectable public var focusedBackgroundColor: UIColor = .red
    @IBInspectable public var focusedBackgroundEndColor: UIColor?
    @IBInspectable public var normalBackgroundColor: UIColor = .white {
        didSet {
            gradientView.colors = normalGradientBackgroundColors
        }
    }
    @IBInspectable public var normalBackgroundEndColor: UIColor? {
        didSet {
            gradientView.colors = normalGradientBackgroundColors
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 5.0
    @IBInspectable public var focusedScaleFactor: CGFloat = 1.2
    @IBInspectable public var focusedShadowRadius: CGFloat = 10
    @IBInspectable public var focusedShadowOpacity: Float = 0.25
    @IBInspectable public var shadowColor: CGColor = UIColor.black.cgColor
    @IBInspectable public var shadowOffSetFocused: CGSize = CGSize(width: 0, height: 27)
    @IBInspectable public var animationDuration: TimeInterval = 0.2
    @IBInspectable public var focusedTitleColor: UIColor = .white {
        didSet {
            setTitleColor(focusedTitleColor, for: .focused)
        }
    }
    @IBInspectable public var normalTitleColor: UIColor = .white {
        didSet {
            setTitleColor(normalTitleColor, for: .normal)
        }
    }
    @IBInspectable public var gradientStartPoint: CGPoint = .zero
    @IBInspectable public var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 1)
    
    private var focusedGradientBackgroundColors: [CGColor] {
        let endColor = focusedBackgroundEndColor ?? focusedBackgroundColor
        return [focusedBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private var normalGradientBackgroundColors: [CGColor] {
        let endColor = normalBackgroundEndColor ?? normalBackgroundColor
        return [normalBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private let gradientView = GradientView()
    
    public override var buttonType: UIButtonType {
        return .custom
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override public func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            self.isFocused ? self.applyFocusedStyle() : self.applyUnfocusedStyle()
        }, completion: nil)
    }
    
    override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform.identity
                self.layer.shadowOffset = CGSize(width: 0, height: 10)
        })
    }
    
    override public func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard isFocused else { return }
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    override public func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard isFocused else { return }
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    // MARK: - Private
    
    private func setUpView() {
        setUpGradientView()
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(focusedTitleColor, for: .focused)
        layer.shadowOpacity = focusedShadowOpacity
        layer.shadowRadius = focusedShadowRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffSetFocused
    }
    
    private func setUpGradientView() {
        gradientView.frame = bounds
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView.layer.cornerRadius = cornerRadius
        gradientView.startPoint = gradientStartPoint
        gradientView.endPoint = gradientEndPoint
        gradientView.colors = normalGradientBackgroundColors
        addSubview(gradientView)
    }
    
    private func applyFocusedStyle() {
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.clipsToBounds = false
                self.gradientView.colors = self.focusedGradientBackgroundColors
            },
            completion: nil)
    }
    
    private func applyUnfocusedStyle() {
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.clipsToBounds = true
                self.transform = CGAffineTransform.identity
                self.gradientView.colors = self.normalGradientBackgroundColors
            },
            completion: nil)
    }
}

final private class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var colors: [Any]? {
        set {
            gradientLayer.colors = newValue
        }
        
        get {
            return gradientLayer.colors
        }
    }
    
    var startPoint: CGPoint {
        set {
            gradientLayer.startPoint = newValue
        }
        
        get {
            return gradientLayer.startPoint
        }
    }
    
    var endPoint: CGPoint {
        set {
            gradientLayer.endPoint = newValue
        }
        
        get {
            return gradientLayer.endPoint
        }
    }
    
    // MARK: - Private
    
    private lazy var gradientLayer: CAGradientLayer = {
        return self.layer as! CAGradientLayer
    }()
}
