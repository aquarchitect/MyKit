//
//  NetworkButton.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/23/16.
//  
//

public class NetworkButton<T: UIView where T: IndicateActivity>: UIButton {

    private let activityIndicator = T()

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.addSubview(activityIndicator)

        [.CenterX, .CenterY].forEach { self.addConstraint(item: activityIndicator, attribute: $0, relatedBy: .Equal, toItem: self, attribute: $0, multiplier: 1, constant: 0) }
    }

    public func startIndicatorAnimation() {
        self.titleLabel?.then {
            $0.alpha = 1
            $0.hidden = false
        }

        activityIndicator.then {
            $0.hidden = false
            $0.startAnimating()
            $0.transform = CGAffineTransformMakeScale(0, 0)
        }

        self.enabled = false

        UIView.animateWithDuration(0.25, animations: {
            self.titleLabel?.alpha = 0
            self.activityIndicator.transform = CGAffineTransformIdentity
            }, completion: { _ in
                self.titleLabel?.hidden = true
        })
    }

    public func stopIndicatorAnimation() {
        self.enabled = true

        self.titleLabel?.then {
            $0.alpha = 0
            $0.hidden = false
        }

        activityIndicator.then {
            $0.hidden = false
            $0.transform = CGAffineTransformIdentity
        }

        UIView.animateWithDuration(0.25, animations: {
            self.titleLabel?.alpha = 1
            self.activityIndicator.transform = CGAffineTransformMakeScale(0, 0)
            }, completion: { _ in
                self.activityIndicator.then {
                    $0.stopAnimating()
                    $0.transform = CGAffineTransformIdentity
                }
        })
    }
}
