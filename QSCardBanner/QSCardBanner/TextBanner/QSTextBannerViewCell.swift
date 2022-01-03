//
//  QSTextBannerViewCell.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSTextBannerViewCell: UICollectionViewCell {
    // MARK: - 子控件
    private var textLab: UILabel!
    
    // MARK: - 属性
    var text: String = "" {
        didSet {
            textLab.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLab = UILabel.init(frame: self.contentView.bounds)
        self.contentView.addSubview(textLab)
        textLab.textColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
