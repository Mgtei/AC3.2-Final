//
//  CategoryCollectionViewCell.swift
//  
//
//  Created by Margaret Ikeda on 2/15/17.
//
//

import UIKit

class CatergoryCollectionViewCell: UICollectionViewCell {
    var something = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(something)
        something.snp.makeConstraints({ (view) in
            view.width.height.equalTo(contentView)
            view.center.equalTo(contentView.snp.center)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
