//
//  QSTextBannerView.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSTextBannerView: QSBaseBannerView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.register(QSTextBannerViewCell.self, forCellWithReuseIdentifier: "QSTextBannerViewCell")
    }
    
    // MARK: - override
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSTextBannerViewCell", for: indexPath) as! QSTextBannerViewCell
        
        let row = indexPath.item % self.itemCount;
        let title = self.dataArray[row]
        cell.text = (title as? String) ?? ""
        
        return cell
    }
}
