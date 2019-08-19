//
//  QSImageBannerView.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSImageBannerView: QSBaseBannerView {
}

extension QSImageBannerView: QSBannerViewInterface {
    func qs_bannerViewRegisterCell(_ bannerView: QSBaseBannerView, collectionView: UICollectionView) {
        collectionView.register(QSImageBannerViewCell.self, forCellWithReuseIdentifier: "QSImageBannerViewCell")
    }
    
    func qs_bannerView(_ bannerView: QSBaseBannerView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSImageBannerViewCell", for: indexPath) as! QSImageBannerViewCell
        
        let imageName = self.dataArray[itemIndex]
        cell.qs_setImage(imgName: (imageName as? String) ?? "", placeholder: "")
        
        return cell
    }
}
