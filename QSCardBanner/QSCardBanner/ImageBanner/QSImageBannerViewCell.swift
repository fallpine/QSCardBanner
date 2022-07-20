//
//  QSImageBannerViewCell.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSImageBannerViewCell: UICollectionViewCell {
    // MARK: - 子控件
    var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgView = UIImageView.init(frame: self.contentView.bounds)
        self.contentView.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    /// 设置图片
    ///
    /// - Parameters:
    ///   - imgName: 图片名
    ///   - placeholder: 占位图
    func qs_setImage(imgName: String, placeholder: String?) {
        imgView.qs_setImage(imgName, placeholder: placeholder)
    }
}
