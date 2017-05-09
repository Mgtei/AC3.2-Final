//
//  GalleryTableViewCell.swift
//  AC3.2-Final
//
//  Created by C4Q on 4/21/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class GalleryTableViewCell: UITableViewCell {
    
    var commentLabel = UILabel()
    var postImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(postImageView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupConstraints() {
        postImageView.snp.makeConstraints { (view) in
            view.width.equalTo(contentView.snp.width)
            view.height.equalTo(contentView.snp.width)
            view.leading.equalTo(contentView.snp.leading)
            view.top.equalTo(contentView.snp.top)
        }
        commentLabel.snp.makeConstraints { (view) in
            view.width.equalTo(postImageView.snp.width)
            view.centerX.equalTo(postImageView.snp.centerX)
            view.top.equalTo(postImageView.snp.bottom)
            view.bottom.equalTo(contentView.snp.bottom)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
