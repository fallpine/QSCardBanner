//
//  QSPageControl.swift
//  CardBanner
//
//  Created by Song on 2018/4/26.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

public class QSPageControl: UIView {
    // MARK: - Property
    /// 点视图数组
    public var pageImgViewArray: Array<UIImageView> = Array.init()
    
    /// 当前点
    public var currentPage: Int = 0 {
        didSet {
            qs_createPointView()
        }
    }
    
    /// 点的个数
    public var numberOfPages: Int = 0 {
        didSet {
            qs_createPointView()
        }
    }
    
    /// pageControl数据模型
    public var pageControlModel: QSPageControlModel = QSPageControlModel() {
        didSet {
            qs_createPointView()
        }
    }
    
    // MARK: - Private Methods
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 大小
    ///   - pages: 页数
    ///   - currentPage: 当前页
    ///   - model: 样式模型
    convenience public init(frame: CGRect, numberOf pages: Int, currentPage: Int = 0, model: QSPageControlModel?) {
        self.init(frame: frame)
        
        if let model = model {
            self.pageControlModel = model
        } else {
            self.pageControlModel = QSPageControlModel()
        }
        self.currentPage = currentPage
        self.numberOfPages = pages
    }
    
    // MARK: - System Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        qs_createPointView()
    }
    
    // MARK: - Func
    /// 创建视图
    public func qs_createPointView() {
        // 如果不是椭圆的点，则不必每次都重新创建点视图
        if pageImgViewArray.count > 0 && !pageControlModel.isEllipse && pageImgViewArray.count == numberOfPages {
            for imgView in pageImgViewArray {
                if let otherPointImage = pageControlModel.otherPointImage {
                    imgView.image = UIImage.init(named: otherPointImage)
                } else {
                    imgView.backgroundColor = pageControlModel.otherPointColor
                }
            }
            
            // 当前点
            let currentImgView = pageImgViewArray[currentPage]
            if let currentPointImage = pageControlModel.currentPointImage {
                currentImgView.image = UIImage.init(named: currentPointImage)
            } else {
                currentImgView.backgroundColor = pageControlModel.currentPointColor
            }
        }
        
        // 清除视图
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        if numberOfPages <= 0 {
            return
        }
        
        // PageControl位置
        // X
        var startX: CGFloat = 0.0
        let mainWidth = CGFloat(numberOfPages) * (pageControlModel.pointWidth + pageControlModel.pointSpace) - pageControlModel.pointSpace + pageControlModel.pointWidth * (pageControlModel.pointScale - 1.0)
        
        switch pageControlModel.pageControlLocation {
        case .right:
            startX = frame.size.width - mainWidth - 30.0
        case .middle:
            startX = (frame.size.width - mainWidth) / 2.0
        case .left:
            startX = 30.0
        }
        
        // Y
        let centerY: CGFloat = frame.size.height / 2.0
        
        // 动态创建点
        for page in 0 ..< numberOfPages {
            if page == currentPage {    // 当前点
                var pointWidth: CGFloat = 0.0
                var pointHeight: CGFloat = 0.0
                if self.pageControlModel.isEllipse {
                    pointWidth = pageControlModel.pointWidth * pageControlModel.pointScale
                    pointHeight = pageControlModel.pointHeight
                } else {
                    pointWidth = pageControlModel.pointWidth * pageControlModel.pointScale
                    pointHeight = pageControlModel.pointHeight * pageControlModel.pointScale
                }
                
                let currPointView = UIImageView.init(frame: CGRect.init(x: startX, y: 0.0, width: pointWidth, height: pointHeight))
                self.addSubview(currPointView)
                
                // 中点位置
                var pointCenter = currPointView.center
                pointCenter.y = centerY
                currPointView.center = pointCenter
                
                if pageControlModel.currentPointImage != nil {
                    currPointView.backgroundColor = UIColor.clear
                    currPointView.image = UIImage.init(named: pageControlModel.currentPointImage!)
                } else {
                    currPointView.layer.cornerRadius = pointHeight / 2.0
                    currPointView.layer.masksToBounds = true
                    currPointView.backgroundColor = pageControlModel.currentPointColor
                }
                
                // 设置startX的值
                startX = currPointView.frame.maxX + pageControlModel.pointSpace
            } else {    // 未选中的点
                var pointWidth: CGFloat = 0.0
                var pointHeight: CGFloat = 0.0
                if pageControlModel.isEllipse {
                    pointWidth = pageControlModel.pointWidth
                    pointHeight = pageControlModel.pointHeight
                } else {
                    pointWidth = pageControlModel.pointWidth * pageControlModel.pointScale
                    pointHeight = pageControlModel.pointHeight * pageControlModel.pointScale
                }
                
                let otherPointView = UIImageView.init(frame: CGRect.init(x: startX, y: 0.0, width: pointWidth, height: pointHeight))
                self.addSubview(otherPointView)
                
                // 中点位置
                var pointCenter = otherPointView.center
                pointCenter.y = centerY
                otherPointView.center = pointCenter
                
                if pageControlModel.otherPointImage != nil {
                    otherPointView.backgroundColor = UIColor.clear
                    otherPointView.image = UIImage.init(named: pageControlModel.otherPointImage!)
                } else {
                    otherPointView.layer.cornerRadius = pointHeight / 2.0
                    otherPointView.layer.masksToBounds = true
                    otherPointView.backgroundColor = pageControlModel.otherPointColor
                }
                
                // 设置startX的值
                startX = otherPointView.frame.maxX + pageControlModel.pointSpace
            }
        }
    }
}
