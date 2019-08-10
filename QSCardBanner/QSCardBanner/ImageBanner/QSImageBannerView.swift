//
//  QSImageBannerView.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSImageBannerView: QSBaseBannerView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.register(QSImageBannerViewCell.self, forCellWithReuseIdentifier: "QSImageBannerViewCell")
    }
    
    // MARK: - override
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSImageBannerViewCell", for: indexPath) as! QSImageBannerViewCell

        let row = indexPath.item % self.itemCount;
        let imageName = self.dataArray[row]
        cell.qs_setImage(imgName: (imageName as? String) ?? "", placeholder: "")
        
        return cell
    }
}
