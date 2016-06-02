//
//  CenteringRoundedCell.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/13/16.
//  
//

import UIKit

public class CenteringRoundedCell: UICollectionViewCell {

    private var separatorLayer = CAShapeLayer().then {
        $0.strokeColor = UIColor.lightGrayColor().CGColor
        $0.lineWidth = 0.5
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.then {
            $0.masksToBounds = true
            $0.mask = CAShapeLayer()
            $0.addSublayer(separatorLayer)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        separatorLayer.then {
            let y = self.bounds.maxY - $0.lineWidth / 2
            let points = [self.bounds.minX, self.bounds.maxX].map { CGPointMake($0, y) }

            $0.zPosition = 100
            $0.path = UIBezierPath(points: points).CGPath
        }
    }

    public override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)

        (layoutAttributes as? CenteringGroupedLayout.Attributes)?.then {
            separatorLayer.hidden = !$0.showsSeparator
            (self.layer.mask as? CAShapeLayer)?.path = $0.maskPath.CGPath
        }
    }
}