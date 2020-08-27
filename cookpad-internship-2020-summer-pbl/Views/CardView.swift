//
//  CardView.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit

@IBDesignable
public class CardView: UIView {
    private var shadowLayer: CAShapeLayer!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }

    func configure() {
        layer.cornerRadius = 8
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: 8).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .zero
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 8
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
