//
//  CenteringFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/13/16.
//  
//

public class CenteringFlowLayout: UICollectionViewFlowLayout {

    public override func prepareLayout() {
        let screen: UIScreen = .mainScreen()
        let padding: CGFloat = 15
        let width = screen.propotionalWidth - 2 * padding
        let margin = (screen.bounds.width - width) / 2
        let inset = self.sectionInset

        self.sectionInset = UIEdgeInsetsMake(inset.top, margin, inset.bottom, margin)
        self.itemSize = CGSizeMake(width, self.itemSize.height)
        self.scrollDirection = .Vertical
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0

        super.prepareLayout()
    }
}