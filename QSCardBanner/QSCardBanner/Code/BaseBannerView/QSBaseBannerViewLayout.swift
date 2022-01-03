//
//  QSBaseBannerViewLayout.swift
//  CardBanner
//
//  Created by Song on 2018/4/27.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

public class QSBaseBannerViewLayout: UICollectionViewFlowLayout {
    // MARK: - Property
    /// cell的大小
    var qs_itemSize: CGSize = CGSize.zero
    /// 是否是卡片式显示
    var qs_isCardStytle: Bool = true
    /// 可视区域内显示的图片个数
    var qs_visibleCount: UInt = 1
    /// 滚动方向
    var qs_scrollDirection: UICollectionView.ScrollDirection = .horizontal
    /// 拖拽的item下标
    var qs_dragItemIndex: Int = 0
    /// 分页
    var qs_isPagingEnabled: Bool = true
    
    private var collectionViewWidth: CGFloat = 0.0
    private var collectionViewHeight: CGFloat = 0.0
    private var itemWidth: CGFloat = 0.0
    private var itemHeight: CGFloat = 0.0
    private var itemWidthMargin: CGFloat = 0.0
    private var itemHeightMargin: CGFloat = 0.0
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - itemSize: 图片cell的大小
    ///   - itemWidthMargin: 宽度间距
    ///   - itemHeightMargin: 高度间距
    ///   - isCardStytle: 是否是卡片式显示，默认 true
    ///   - visibleCount: 可视范围内的cell个数，默认 3
    ///   - leftRightMargin: 左右边距，默认 10.0
    ///   - topBottomMargin: 上下边距，默认 10.0
    ///   - isPagingEnabled: 分页
    convenience init(itemSize: CGSize, itemWidthMargin: CGFloat = 0.0, itemHeightMargin: CGFloat = 0.0, isCardStytle: Bool = true, visibleCount:UInt = 3, scrollDirection: UICollectionView.ScrollDirection = .horizontal, isPagingEnabled: Bool = true) {
        self.init()
        
        self.qs_itemSize = itemSize
        self.itemWidthMargin = itemWidthMargin
        self.itemHeightMargin = itemHeightMargin
        self.qs_isCardStytle = isCardStytle
        self.qs_visibleCount = visibleCount
        self.qs_scrollDirection = scrollDirection
        self.qs_isPagingEnabled = isPagingEnabled
    }
    
    // MARK: - UICollectionViewLayout
    /// 布局刷新时, 会调用此方法
    override public func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // 设置ContentInset
        collectionViewWidth = collectionView.frame.width
        collectionViewHeight = collectionView.frame.height
        itemWidth = qs_itemSize.width
        itemHeight = qs_itemSize.height
        scrollDirection = qs_scrollDirection
        if qs_scrollDirection == .horizontal {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: (collectionViewWidth - itemWidth) / 2.0, bottom: 0, right: (collectionViewWidth - itemWidth) / 2.0)
        } else {
            collectionView.contentInset = UIEdgeInsets(top: (collectionViewHeight - itemHeight) / 2.0, left: 0, bottom: (collectionViewHeight - itemHeight) / 2.0, right: 0)
        }
    }
    
    /// 获取所有cell的属性设置
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        let cellCount = collectionView.numberOfItems(inSection: 0)
        var attArray: Array<UICollectionViewLayoutAttributes> = Array.init()
        
        if qs_scrollDirection == .horizontal {
            // 中间图片的x
            let centerItemX = collectionView.contentOffset.x + collectionViewWidth / 2.0
            // 获取可视区域中的最小、最大下标
            let index: Int = Int(centerItemX / itemWidth)
            let count: Int = Int((qs_visibleCount - 1) / 2)
            let minIndex: Int = max(0, index - count)
            let maxIndex: Int = min(cellCount - 1, index + count)
            
            // cell属性数组
            if maxIndex >= minIndex {
                for i in minIndex ... maxIndex {
                    let indexPath = IndexPath.init(item: i, section: 0)
                    let attributes = qs_setCellAttributes(indexPath: indexPath)
                    
                    attArray.append(attributes)
                }
            }
        } else {
            // 中间图片的y
            let centerItemY = collectionView.contentOffset.y + collectionViewHeight / 2.0
            // 获取可视区域中的最小、最大下标
            let index: Int = Int(centerItemY / itemHeight)
            let count: Int = Int((qs_visibleCount - 1) / 2)
            let minIndex: Int = max(0, index - count)
            let maxIndex: Int = min(cellCount - 1, index + count)
            
            // cell属性数组
            if maxIndex >= minIndex {
                for i in minIndex ... maxIndex {
                    let indexPath = IndexPath.init(item: i, section: 0)
                    let attributes = qs_setCellAttributes(indexPath: indexPath)
                    
                    attArray.append(attributes)
                }
            }
        }
        
        return attArray
    }
    
    /// 设置ContentSize
    override public var collectionViewContentSize: CGSize {
        get {
            guard let collectionView = collectionView else { return .zero }
            
            let cellCount = collectionView.numberOfItems(inSection: 0)
            if qs_scrollDirection == .horizontal {
                let size = CGSize.init(width: CGFloat(cellCount) * itemWidth, height: collectionView.frame.height)
                
                return size
            } else {
                let size = CGSize.init(width: collectionView.frame.width, height: CGFloat(cellCount) * itemHeight)
                
                return size
            }
        }
    }
    
    // MARK: - Private Methods
    /// 设置item的属性
    func qs_setCellAttributes(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        guard let collectionView = collectionView else { return attributes }
        
        // item大小
        attributes.size = CGSize.init(width: itemWidth - itemWidthMargin, height: itemHeight - itemHeightMargin)
        
        if qs_isCardStytle {
            // 利用zIndex属性实现立体效果
            let centerItemX = collectionView.contentOffset.x + collectionViewWidth / 2.0
            let attributesX = itemWidth * (CGFloat(indexPath.item) + 0.5)
            attributes.zIndex = -Int(abs(attributesX - centerItemX))
            
            // 设置放大倍数
            let delta = centerItemX - attributesX;
            let ratio =  -delta / (itemWidth * 2);
            // 根据需要计算放大系数
            let leftRightScale = 1.0 - Double(abs(delta) / (itemWidth * 12.0)) * cos(Double(ratio) * Double.pi / 4.0);
            let topBottomScale = 1.0 - Double(abs(delta) / (qs_itemSize.height * 12.0)) * cos(Double(ratio) * Double.pi / 4.0);
            
            if qs_isCardStytle {
                attributes.transform = CGAffineTransform.init(scaleX: CGFloat(leftRightScale), y: CGFloat(topBottomScale))
            }
        }
        
        // 设置中点的坐标
        if qs_scrollDirection == .horizontal {
            let centerX = itemWidth * (CGFloat(indexPath.item) + 0.5)
            attributes.center = CGPoint.init(x: centerX, y: collectionView.frame.height / 2.0)
        } else {
            let centerY = itemHeight * (CGFloat(indexPath.item) + 0.5)
            attributes.center = CGPoint.init(x: collectionView.frame.width / 2.0, y: centerY)
        }
        
        return attributes;
    }
    
    /// 当手指离开collectionView的时候调用
    ///
    /// - Parameters:
    ///   - targetContentOffset: 最终停留的位置 (进行干预后停留的位置)
    ///   - proposedContentOffset: 本应该停留的位置
    ///   - velocity: velocity  力度, 速度
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if qs_isPagingEnabled {
            if qs_scrollDirection == .horizontal {
                // 最后要停留的位置
                let offsetX = (proposedContentOffset.x + collectionViewWidth / 2.0 - itemWidth / 2.0) / itemWidth
                let index1: Int = Int(round(offsetX))
                
                var index = qs_dragItemIndex
                if index1 != qs_dragItemIndex {
                    index = index1 > qs_dragItemIndex ? (qs_dragItemIndex + 1) : (qs_dragItemIndex - 1)
                }
                
                let proposedOffsetX = itemWidth * CGFloat(index) + itemWidth / 2.0 - collectionViewWidth / 2.0
                let offset = CGPoint.init(x: proposedOffsetX, y: proposedContentOffset.y)
                
                return offset
            } else {
                let offsetY = (proposedContentOffset.y + collectionViewHeight / 2.0 - itemHeight / 2.0) / itemHeight
                let index1: Int = Int(round(offsetY))
                
                var index = qs_dragItemIndex
                if index1 != qs_dragItemIndex {
                    index = index1 > qs_dragItemIndex ? (qs_dragItemIndex + 1) : (qs_dragItemIndex - 1)
                }
                
                let proposedOffsetY = itemHeight * CGFloat(index) + itemHeight / 2.0 - collectionViewHeight / 2.0
                let offset = CGPoint.init(x: proposedContentOffset.x, y: proposedOffsetY)
                
                return offset
            }
        } else {
            if qs_scrollDirection == .horizontal {
                let offsetX = (proposedContentOffset.x + collectionViewWidth / 2.0 - itemWidth / 2.0) / itemWidth
                let index = round(offsetX)
                
                let proposedOffsetX = itemWidth * index + itemWidth / 2.0 - collectionViewWidth / 2.0
                let offset = CGPoint.init(x: proposedOffsetX, y: proposedContentOffset.y)
                
                return offset
            } else {
                let offsetY = (proposedContentOffset.y + collectionViewHeight / 2.0 - itemHeight / 2.0) / itemHeight
                let index = round(offsetY)
                
                let proposedOffsetY = itemHeight * index + itemHeight / 2.0 - collectionViewHeight / 2.0
                let offset = CGPoint.init(x: proposedContentOffset.x, y: proposedOffsetY)
                
                return offset
            }
        }
    }
    
    /// 当屏幕的可见范围发生变化的时候, 要重新刷新布局
    override public func shouldInvalidateLayout(forBoundsChange : CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        
        return !forBoundsChange.equalTo(collectionView.bounds)
    }
}
