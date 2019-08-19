//
//  QSTextBannerView.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSTextBannerView: QSBaseBannerView {
}

extension QSTextBannerView: QSBannerViewInterface {
    func qs_bannerViewRegisterCell(_ bannerView: QSBaseBannerView, collectionView: UICollectionView) {
        collectionView.register(QSTextBannerViewCell.self, forCellWithReuseIdentifier: "QSTextBannerViewCell")
    }
    
    func qs_bannerView(_ bannerView: QSBaseBannerView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSTextBannerViewCell", for: indexPath) as! QSTextBannerViewCell
        
        let title = self.dataArray[itemIndex]
        cell.text = (title as? String) ?? ""
        
        return cell
    }
}
