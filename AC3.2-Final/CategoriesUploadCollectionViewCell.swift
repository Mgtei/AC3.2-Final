//
//  CategoriesUploadCollectionViewCell.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class CategoriesUploadCollectionViewCell: UICollectionViewCell {
    
    var categoriesLabel = UILabel()
    override var isSelected: Bool {
        didSet {
            categoriesLabel.backgroundColor = isSelected ? UIColor.darkGray : UIColor.lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoriesLabel.numberOfLines = 0
        categoriesLabel.backgroundColor = UIColor.white
        
        
        contentView.addSubview(categoriesLabel)
        categoriesLabel.snp.makeConstraints({ (view) in
            view.width.height.equalTo(contentView)
            
            //view.width.height.equalTo(contentView)
            view.center.equalTo(contentView.snp.center)
        })
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
