//
//  QSBaseBannerView.swift
//  CardBanner
//
//  Created by Song on 2018/4/27.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit
import QSExtensions

public class QSBaseBannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var cellOffsetX: CGFloat = 0.0
    private var cellOffsetY: CGFloat = 0.0
    private var isInit: Bool = true
    
    //// 样式模型数据
    var stytleModel: QSBaseBannerModel = QSBaseBannerModel() {
        didSet {
            // 设置定时器
            if self.stytleModel.isAutoRun {
                self.qs_createTimer()
            }
        }
    }
    /// 图片数组
    var dataArray: Array<Any> = Array.init() {
        didSet {
            self.itemCount = dataArray.count
            
            if let collectionV = self.collectionView {
                collectionV.reloadData()
                // 跳转到中间显示
                self.qs_collectionViewJumpToCenter()
            }
            
            if let pageC = self.pageControl {
                pageC.numberOfPages = self.itemCount
            }
        }
    }
    
    // MARK: - 子控件
    var collectionView: UICollectionView!
    var pageControl: QSPageControl?
    var itemCount: Int = 0
    var timer: Timer?
    var selectedBlock: ((Int) -> ())?
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 大小
    ///   - imageArray: 图片数组
    ///   - stytleModel: 样式模型
    ///   - selectBlock: 选中的回调
    convenience init(frame: CGRect, imageArray: Array<String>, stytleModel: QSBaseBannerModel, selectBlock: @escaping ((Int) -> ())) {
        self.init(frame: frame)
        
        self.setValue(stytleModel, forKey: "qs_stytleModel")
        self.setValue(imageArray, forKey: "qs_dataArray")
        self.selectedBlock = selectBlock
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isInit = true
    }
    
    deinit {
        timer?.qs_invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.cellOffsetX = (self.frame.size.width - self.stytleModel.itemSize.width) / 2.0
        self.cellOffsetY = (self.frame.size.height - self.stytleModel.itemSize.height) / 2.0
        
        if let _ = self.collectionView {
        } else {
            // 创建CollectionView
            self.qs_createCollectionView()
        }
        
        if let _ = self.pageControl {
        } else {
            self.qs_createPageControl()
            self.pageControl?.isHidden = !self.stytleModel.isNeedPageControl
        }
    }
    
    // 使用kvc，undefine方法
    override public func setValue(_ value: Any?, forUndefinedKey key: String) {
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
        return self.itemCount == 1 ? 1 : self.itemCount * 50
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("必须使用子类创建视图，再layoutSubviews方法中注册cell，并重写collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)方法")
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item % self.itemCount;
        if self.selectedBlock != nil {
            self.selectedBlock!(index)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 暂停定时器
        if self.timer != nil {
            self.timer?.qs_pause()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 重新开启定时器
        if self.timer != nil {
            self.timer?.qs_restart(timeInterval: TimeInterval(self.stytleModel.timeInterval))
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 重新开启定时器
        if self.timer != nil {
            self.timer?.qs_restart(timeInterval: TimeInterval(self.stytleModel.timeInterval))
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 暂停定时器
        if self.timer != nil && !isInit {
            self.timer?.qs_pause()
        }
        
        // 判断是否是第一个或最后一个item
        if self.stytleModel.scrollDirection == .horizontal {
            var index = Int((scrollView.contentOffset.x + cellOffsetX) / self.stytleModel.itemSize.width)
            if index == self.itemCount * 50 || index == 0 {
                index = Int(CGFloat(self.itemCount) * 50.0 * 0.5)
                let offset = self.stytleModel.itemSize.width * CGFloat(self.itemCount) * 50 * 0.5 - cellOffsetX
                self.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: false)
            }
            
            // 设置PageControl
            if (self.itemCount > 0 && self.stytleModel.isNeedPageControl) {
                let x = scrollView.contentOffset.x + cellOffsetX + self.stytleModel.itemSize.width / 2.0
                let cellIndex = Int(x / self.stytleModel.itemSize.width)
                let imgIndex = cellIndex % self.itemCount
                self.pageControl?.currentPage = imgIndex
            }
        } else {
            var index = Int((scrollView.contentOffset.y + cellOffsetY) / self.stytleModel.itemSize.height)
            if index == self.itemCount * 50 || index == 0 {
                index = Int(CGFloat(self.itemCount) * 50.0 * 0.5)
                let offset = self.stytleModel.itemSize.height * CGFloat(self.itemCount) * 50 * 0.5 - cellOffsetY
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: false)
            }
            
            // 设置PageControl
            if (self.stytleModel.isNeedPageControl) {
                let y = scrollView.contentOffset.y + cellOffsetY + self.stytleModel.itemSize.height / 2.0
                let cellIndex = Int(y / self.stytleModel.itemSize.height)
                let imgIndex = cellIndex % self.itemCount
                self.pageControl?.currentPage = imgIndex
            }
        }
    }
    
    // MARK: - Private Methods
    /// 创建CollectionView
    private func qs_createCollectionView() {
        let layout = QSBaseBannerViewLayout.init(itemSize: self.stytleModel.itemSize, itemWidthMargin: self.stytleModel.itemWidthMargin, itemHeightMargin: self.stytleModel.itemHeigtMargin, isCardStytle: self.stytleModel.isCardStytle, visibleCount: self.stytleModel.visibleCount, scrollDirection: self.stytleModel.scrollDirection)
        
        // collectionView
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(collectionView)
        
        collectionView.backgroundColor = self.stytleModel.collectionViewBgColor
        // 分页
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    /// 创建PageControl
    private func qs_createPageControl() {
        let pageControlModel = QSageControlModel()
        pageControlModel.pointWidth = self.stytleModel.pointWidth
        pageControlModel.pointHeight = self.stytleModel.pointHeight
        pageControlModel.pointSpace = self.stytleModel.pointSpace
        pageControlModel.otherPointColor = self.stytleModel.otherPointColor
        pageControlModel.currentPointColor = self.stytleModel.currentPointColor
        pageControlModel.currentPointImage = self.stytleModel.currentPointImage
        pageControlModel.otherPointImage = self.stytleModel.otherPointImage
        pageControlModel.pageControlLocation = self.stytleModel.pageControlLocation
        pageControlModel.pointScale = self.stytleModel.pointScale
        pageControlModel.isEllipse = self.stytleModel.isEllipse
        
        let pageControl = QSPageControl.init(frame: CGRect.init(x: 0, y: self.frame.size.height - self.stytleModel.pageControlHeight - self.stytleModel.pageControlBottomMargin, width: self.frame.size.width, height: self.stytleModel.pageControlHeight), unmberOf: self.itemCount, currentPage: 0, model: pageControlModel)
        pageControl.numberOfPages = self.itemCount
        
        self.addSubview(pageControl)
        self.pageControl = pageControl
    }
    
    /// 设置定时器
    private func qs_createTimer() {
        timer = Timer.qs_init(timeInterval: TimeInterval(self.stytleModel.timeInterval)) { [unowned self] (timer) in
            self.isInit = false
            
            // 判断是否是第一个或最后一个item
            if self.stytleModel.scrollDirection == .horizontal {
                var index = Int((self.collectionView.contentOffset.x + self.cellOffsetX) / self.stytleModel.itemSize.width)
                if index == self.itemCount * 50 || index == 0 {
                    index = Int(CGFloat(self.itemCount) * 50.0 * 0.5)
                    let offset = self.stytleModel.itemSize.width * CGFloat(self.itemCount) * 50 * 0.5 - self.cellOffsetX
                    self.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: false)
                }
                
                // 调整偏移量
                let result = (self.collectionView.contentOffset.x + self.cellOffsetX).truncatingRemainder(dividingBy: self.stytleModel.itemSize.width)   // 取余
                
                var offset = self.collectionView.contentOffset.x + self.stytleModel.itemSize.width
                if abs(result - self.stytleModel.itemSize.width) < 1.0 {
                } else {
                    offset -= result
                }
                self.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: true)
            } else {
                var index = Int((self.collectionView.contentOffset.y + self.cellOffsetY) / self.stytleModel.itemSize.height)
                if index == self.itemCount * 50 || index == 0 {
                    index = Int(CGFloat(self.itemCount) * 50.0 * 0.5)
                    let offset = self.stytleModel.itemSize.height * CGFloat(self.itemCount) * 50 * 0.5 - self.cellOffsetY
                    self.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: false)
                }
                
                // 调整偏移量
                let result = (self.collectionView.contentOffset.y + self.cellOffsetY).truncatingRemainder(dividingBy: self.stytleModel.itemSize.height)   // 取余
                var offset = self.collectionView.contentOffset.y + self.stytleModel.itemSize.height
                if abs(result - self.stytleModel.itemSize.width) < 1.0 {
                } else {
                    offset -= result
                }
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: true)
            }
        }
    }
    
    /// collectionView跳转到中间那个cell显示
    func qs_collectionViewJumpToCenter() {
        if self.itemCount == 1 {
            return
        }
        
        self.collectionView.superview?.layoutIfNeeded()
        if self.stytleModel.scrollDirection == .horizontal {
            let offset = self.stytleModel.itemSize.width * CGFloat(self.itemCount) * 50.0 * 0.5 - cellOffsetX
            self.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: false)
        } else {
            let offset = self.stytleModel.itemSize.height * CGFloat(self.itemCount) * 50.0 * 0.5 - cellOffsetY
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset), animated: false)
        }
    }
}
