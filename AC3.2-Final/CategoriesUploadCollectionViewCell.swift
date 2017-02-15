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
        
        //categoriesLabel.textColor = EyeVoteColor.textIconColor
        //categoriesLabel.layer.borderColor = EyeVoteColor.textIconColor.cgColor
        //categoriesLabel.layer.borderWidth = 0.8
        //categoriesLabel.textAlignment = .center
        //categoriesLabel.sizeToFit()
        categoriesLabel.numberOfLines = 0
        categoriesLabel.backgroundColor = UIColor.white
        //categoriesLabel.setContentHuggingPriority(0.0, for: .horizontal)
        //categoriesLabel.text = ""
        
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
