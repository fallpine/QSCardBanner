//
//  QSBaseBannerModel.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

public class QSBaseBannerModel {
    /**
     *  定时器
     */
    /// 定时器时间, 默认为 1.5s
    var timeInterval: CGFloat = 1.5
    /// 是否自动轮播, 默认 true
    var isAutoRun: Bool = true
    
    /**
     *  PageControl
     */
    /// 是否需要pageControl, 默认 需要 : true
    var isNeedPageControl: Bool = true
    /// PageControl距离底部的距离
    var pageControlBottomMargin: CGFloat = 15.0
    /// PageControl的高度
    var pageControlHeight: CGFloat = 30.0
    /// 点的宽度，默认6.0
    var pointWidth: CGFloat = 6.0
    /// 点的高度，默认6.0
    var pointHeight:CGFloat = 6.0
    /// 点的间距，默认8.0
    var pointSpace: CGFloat = 8.0
    /// 其他点颜色，默认红色
    var otherPointColor: UIColor = UIColor.red
    /// 当前点颜色，默认蓝色
    var currentPointColor: UIColor = UIColor.blue
    /// 当前点的图片
    var currentPointImage: String?
    /// 其他点的图片
    var otherPointImage: String?
    /// PageControl的位置, 默认居中
    var pageControlLocation: QSPageControlLocation = .middle
    
    /// 当前点的放大倍数，默认1.0
    var pointScale: CGFloat = 1.0
    /// 是否仅对当前点的宽度放大(即椭圆)，默认NO
    var isEllipse: Bool = false
    
    /**
     *  Layout
     */
    /// cell的大小
    var itemSize: CGSize = CGSize.zero
    /// cell的宽度间距
    var itemWidthMargin: CGFloat = 0.0
    /// cell的高度间距
    var itemHeigtMargin: CGFloat = 0.0
    /// 是否是卡片式显示
    var isCardStytle: Bool = true
    /// 可视区域内显示的图片个数
    var visibleCount: UInt = 3
    /// 滚动方向
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    /// collectionView的背景颜色
    var collectionViewBgColor: UIColor = .white
}
