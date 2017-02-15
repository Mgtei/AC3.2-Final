//
//  UploadCollectionViewCell.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class UploadCollectionViewCell: UICollectionViewCell {
    
    var uploadImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(uploadImage)
        uploadImage.snp.makeConstraints({ (view) in
            view.width.height.equalTo(contentView)
            view.center.equalTo(contentView.snp.center)
            uploadImage.clipsToBounds = true
            uploadImage.contentMode = UIViewContentMode.scaleAspectFill
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
