//
//  QSBaseBannerView.swift
//  CardBanner
//
//  Created by Song on 2018/4/27.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit
import QSExtensions

public protocol QSBannerViewInterface {
    /// 注册轮播图的cell
    ///
    /// - Parameters:
    ///   - bannerView: 轮播图
    func qs_bannerViewRegisterCell(_ bannerView: QSBaseBannerView, collectionView: UICollectionView)
    
    /// 创建轮播图的cell
    ///
    /// - Parameters:
    ///   - bannerView: 轮播图
    ///   - indexPath: indexPath
    ///   - itemIndex: 第几个item
    /// - Returns: collectionViewCell
    func qs_bannerView(_ bannerView: QSBaseBannerView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell
}

open class QSBaseBannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var cellOffsetX: CGFloat = 0.0
    private var cellOffsetY: CGFloat = 0.0
    private var isInit: Bool = true
    private var child: QSBannerViewInterface!
    
    //// 样式模型数据
    public var stytleModel: QSBaseBannerModel = QSBaseBannerModel() {
        didSet {
            // 设置定时器
            if stytleModel.isAutoRun {
                qs_createTimer()
            }
        }
    }
    /// 图片数组
    public var dataArray: Array<Any> = Array.init() {
        didSet {
            itemCount = dataArray.count
            
            if dataArray.count <= 1 {
                timer?.qs_suspend()
            } else {
                timer?.qs_restart(dueTime: stytleModel.timeInterval)
            }
            
            if let collectionV = collectionView {
                collectionV.reloadData()
                // 跳转到中间显示
                qs_collectionViewJumpToCenter()
            }
            
            if let pageC = pageControl {
                pageC.numberOfPages = itemCount
            }
        }
    }
    
    // MARK: - 子控件
    private var collectionView: UICollectionView!
    public var pageControl: QSPageControl?
    public var itemCount: Int = 0
    public var timer: Timer?
    public var selectedBlock: ((Int) -> ())?
    private var collectionViewLayer: QSBaseBannerViewLayout?
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 大小
    ///   - imageArray: 图片数组
    ///   - stytleModel: 样式模型
    ///   - selectBlock: 选中的回调
    convenience public init(frame: CGRect, imageArray: Array<String>, stytleModel: QSBaseBannerModel, selectBlock: @escaping ((Int) -> ())) {
        self.init(frame: frame)
        
        self.setValue(stytleModel, forKey: "qs_stytleModel")
        self.setValue(imageArray, forKey: "qs_dataArray")
        self.selectedBlock = selectBlock
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        isInit = true
        child = self as? QSBannerViewInterface
    }
    
    deinit {
        timer?.qs_invalidate()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        cellOffsetX = (frame.size.width - stytleModel.itemSize.width) / 2.0
        cellOffsetY = (frame.size.height - stytleModel.itemSize.height) / 2.0
        
        if let _ = collectionView {
            collectionView.frame = self.bounds
        } else {
            // 创建CollectionView
            qs_createCollectionView()
        }
        
        if let _ = pageControl {
        } else {
            qs_createPageControl()
            pageControl?.isHidden = !stytleModel.isNeedPageControl
        }
        
        // 注册cell
        child.qs_bannerViewRegisterCell(self, collectionView: collectionView)
    }
    
    // 使用kvc，undefine方法
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "qs_stytleModel" { // 设置titleArray
            guard let newValue = value as? QSBaseBannerModel else {
                return
            }
            
            stytleModel = newValue
        }
        
        if key == "qs_dataArray" { // 设置titleArray
            guard let newValue = value as? Array<String> else {
                return
            }
            
            dataArray = newValue
        }
    }
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount == 1 ? 1 : itemCount * 50
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return child.qs_bannerView(self, collectionView: collectionView, cellForItemAt: indexPath, itemIndex: indexPath.item % itemCount)
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item % itemCount;
        if let block = selectedBlock {
            block(index)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if stytleModel.scrollDirection == .horizontal {
            let offsetX = (scrollView.contentOffset.x + collectionView.frame.width / 2.0 - stytleModel.itemSize.width / 2.0) / stytleModel.itemSize.width
            let index = round(offsetX)
            collectionViewLayer?.qs_dragItemIndex = Int(index)
        } else {
            let offsetY = (scrollView.contentOffset.y + collectionView.frame.height / 2.0 - stytleModel.itemSize.height / 2.0) / stytleModel.itemSize.height
            let index = round(offsetY)
            collectionViewLayer?.qs_dragItemIndex = Int(index)
        }
        
        // 暂停定时器
        if timer != nil {
            self.timer?.qs_suspend()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 重新开启定时器
        if timer != nil {
            timer?.qs_restart(dueTime: stytleModel.timeInterval)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 重新开启定时器
        if timer != nil {
            timer?.qs_restart(dueTime: stytleModel.timeInterval)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 暂停定时器
        if timer != nil && !isInit {
            timer?.qs_suspend()
        }
        
        if itemCount <= 1 {
            return
        }
        
        // 判断是否是第一个或最后一个item
        if stytleModel.scrollDirection == .horizontal {
            var index = Int((scrollView.contentOffset.x + cellOffsetX) / stytleModel.itemSize.width)
            if index == (itemCount * 50 - 1) || index == 0 {
                index = Int(CGFloat(itemCount) * 50.0 * 0.5)
                let offset = stytleModel.itemSize.width * CGFloat(itemCount) * 50 * 0.5 - cellOffsetX
                collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: false)
            }
            
            // 设置PageControl
            if (itemCount > 0 && stytleModel.isNeedPageControl) {
                let x = scrollView.contentOffset.x + cellOffsetX + stytleModel.itemSize.width / 2.0
                let cellIndex = Int(x / stytleModel.itemSize.width)
                let imgIndex = cellIndex % itemCount
                pageControl?.currentPage = imgIndex
            }
        } else {
            var index = Int((scrollView.contentOffset.y + cellOffsetY) / stytleModel.itemSize.height)
            if index == (itemCount * 50 - 1) || index == 0 {
                index = Int(CGFloat(itemCount) * 50.0 * 0.5)
                let offset = stytleModel.itemSize.height * CGFloat(itemCount) * 50 * 0.5 - cellOffsetY
                collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: false)
            }
            
            // 设置PageControl
            if (self.stytleModel.isNeedPageControl) {
                let y = scrollView.contentOffset.y + cellOffsetY + stytleModel.itemSize.height / 2.0
                let cellIndex = Int(y / stytleModel.itemSize.height)
                let imgIndex = cellIndex % itemCount
                pageControl?.currentPage = imgIndex
            }
        }
    }
    
    // MARK: - Private Methods
    /// 创建CollectionView
    private func qs_createCollectionView() {
        let layout = QSBaseBannerViewLayout.init(itemSize: stytleModel.itemSize, itemWidthMargin: stytleModel.itemWidthMargin, itemHeightMargin: stytleModel.itemHeigtMargin, isCardStytle: stytleModel.isCardStytle, visibleCount: stytleModel.visibleCount, scrollDirection: stytleModel.scrollDirection, isPagingEnabled: stytleModel.isPagingEnabled)
        collectionViewLayer = layout
        
        // collectionView
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        self.addSubview(collectionView)
        
        collectionView.backgroundColor = stytleModel.collectionViewBgColor
        // 分页
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    /// 创建PageControl
    private func qs_createPageControl() {
        let pageControlModel = QSPageControlModel()
        pageControlModel.pointWidth = stytleModel.pointWidth
        pageControlModel.pointHeight = stytleModel.pointHeight
        pageControlModel.pointSpace = stytleModel.pointSpace
        pageControlModel.otherPointColor = stytleModel.otherPointColor
        pageControlModel.currentPointColor = stytleModel.currentPointColor
        pageControlModel.currentPointImage = stytleModel.currentPointImage
        pageControlModel.otherPointImage = stytleModel.otherPointImage
        pageControlModel.pageControlLocation = stytleModel.pageControlLocation
        pageControlModel.pageControlEdgeMargin = stytleModel.pageControlEdgeMargin
        pageControlModel.pointScale = stytleModel.pointScale
        pageControlModel.isEllipse = stytleModel.isEllipse
        
        let pageControl = QSPageControl.init(frame: CGRect.init(x: 0, y: frame.size.height - stytleModel.pageControlHeight - stytleModel.pageControlBottomMargin, width: frame.size.width, height: stytleModel.pageControlHeight), numberOf: itemCount, currentPage: 0, model: pageControlModel)
        pageControl.numberOfPages = itemCount
        
        self.addSubview(pageControl)
        self.pageControl = pageControl
    }
    
    /// 设置定时器
    private func qs_createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: stytleModel.timeInterval, repeats: true) { [weak self] timer in
            guard let weakSelf = self else { return }
            weakSelf.isInit = false
            
            // 判断是否是第一个或最后一个item
            if weakSelf.stytleModel.scrollDirection == .horizontal {
                var index = Int((weakSelf.collectionView.contentOffset.x + weakSelf.cellOffsetX) / weakSelf.stytleModel.itemSize.width)
                if index == (weakSelf.itemCount * 50 - 1) || index == 0 {
                    index = Int(CGFloat(weakSelf.itemCount) * 50.0 * 0.5)
                    let offset = weakSelf.stytleModel.itemSize.width * CGFloat(weakSelf.itemCount) * 50 * 0.5 - weakSelf.cellOffsetX
                    weakSelf.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: false)
                }
                
                // 调整偏移量
                let result = (weakSelf.collectionView.contentOffset.x + weakSelf.cellOffsetX).truncatingRemainder(dividingBy: weakSelf.stytleModel.itemSize.width)   // 取余
                
                var offset = weakSelf.collectionView.contentOffset.x + weakSelf.stytleModel.itemSize.width
                if abs(result - weakSelf.stytleModel.itemSize.width) < 1.0 {
                } else {
                    offset -= result
                }
                weakSelf.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: true)
            } else {
                var index = Int((weakSelf.collectionView.contentOffset.y + weakSelf.cellOffsetY) / weakSelf.stytleModel.itemSize.height)
                if index == (weakSelf.itemCount * 50 - 1) || index == 0 {
                    index = Int(CGFloat(weakSelf.itemCount) * 50.0 * 0.5)
                    let offset = weakSelf.stytleModel.itemSize.height * CGFloat(weakSelf.itemCount) * 50 * 0.5 - weakSelf.cellOffsetY
                    weakSelf.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: false)
                }
                
                // 调整偏移量
                let result = (weakSelf.collectionView.contentOffset.y + weakSelf.cellOffsetY).truncatingRemainder(dividingBy: weakSelf.stytleModel.itemSize.height)   // 取余
                var offset = weakSelf.collectionView.contentOffset.y + weakSelf.stytleModel.itemSize.height
                if abs(result - weakSelf.stytleModel.itemSize.width) < 1.0 {
                } else {
                    offset -= result
                }
                weakSelf.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: true)
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// collectionView跳转到中间那个cell显示
    func qs_collectionViewJumpToCenter() {
        if itemCount == 1 {
            return
        }
        
        collectionView.superview?.layoutIfNeeded()
        if stytleModel.scrollDirection == .horizontal {
            let offset = stytleModel.itemSize.width * CGFloat(itemCount) * 50.0 * 0.5 - cellOffsetX
            collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: false)
        } else {
            let offset = stytleModel.itemSize.height * CGFloat(itemCount) * 50.0 * 0.5 - cellOffsetY
            collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: false)
        }
    }
}
