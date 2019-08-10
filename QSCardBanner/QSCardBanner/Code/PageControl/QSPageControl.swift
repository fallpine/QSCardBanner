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
            self.qs_createPointView()
        }
    }
    
    /// 点的个数
    public var numberOfPages: Int = 0 {
        didSet {
            self.qs_createPointView()
        }
    }
    
    /// pageControl数据模型
    public var pageControlModel: QSPageControlModel = QSPageControlModel() {
        didSet {
            self.qs_createPointView()
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
    convenience init(frame: CGRect, unmberOf pages: Int, currentPage: Int = 0, model: QSPageControlModel?) {
        self.init(frame: frame)
        
        if model != nil {
            self.pageControlModel = model!
        } else {
            self.pageControlModel = QSPageControlModel()
        }
        self.currentPage = currentPage
        self.numberOfPages = pages
    }
    
    // MARK: - System Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.qs_createPointView()
    }
    
    // MARK: - Func
    /// 创建视图
    public func qs_createPointView() {
        // 如果不是椭圆的点，则不必每次都重新创建点视图
        if self.pageImgViewArray.count > 0 && !self.pageControlModel.isEllipse && self.pageImgViewArray.count == self.numberOfPages {
            for imgView in self.pageImgViewArray {
                if self.pageControlModel.otherPointImage != nil {
                    imgView.image = UIImage.init(named: (self.pageControlModel.otherPointImage)!)
                } else {
                    imgView.backgroundColor = self.pageControlModel.otherPointColor
                }
            }
            
            // 当前点
            let currentImgView = self.pageImgViewArray[self.currentPage]
            if self.pageControlModel.currentPointImage != nil {
                currentImgView.image = UIImage.init(named: (self.pageControlModel.currentPointImage)!)
            } else {
                currentImgView.backgroundColor = self.pageControlModel.currentPointColor
            }
        }
        
        // 清除视图
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        if self.numberOfPages <= 0 {
            return
        }
        
        // PageControl位置
        // X
        var startX: CGFloat = 0.0
        let mainWidth = CGFloat(self.numberOfPages) * (self.pageControlModel.pointWidth + self.pageControlModel.pointSpace) - self.pageControlModel.pointSpace + self.pageControlModel.pointWidth * (self.pageControlModel.pointScale - 1.0)
        
        switch self.pageControlModel.pageControlLocation {
        case .right:
            startX = self.frame.size.width - mainWidth - 30.0
        case .middle:
            startX = (self.frame.size.width - mainWidth) / 2.0
        case .left:
            startX = 30.0
        }
        
        // Y
        let centerY: CGFloat = self.frame.size.height / 2.0
        
        // 动态创建点
        for page in 0 ..< self.numberOfPages {
            if page == self.currentPage {    // 当前点
                var pointWidth: CGFloat = 0.0
                var pointHeight: CGFloat = 0.0
                if self.pageControlModel.isEllipse {
                    pointWidth = self.pageControlModel.pointWidth * self.pageControlModel.pointScale
                    pointHeight = self.pageControlModel.pointHeight
                } else {
                    pointWidth = self.pageControlModel.pointWidth * self.pageControlModel.pointScale
                    pointHeight = self.pageControlModel.pointHeight * self.pageControlModel.pointScale
                }
                
                let currPointView = UIImageView.init(frame: CGRect.init(x: startX, y: 0.0, width: pointWidth, height: pointHeight))
                self.addSubview(currPointView)
                
                // 中点位置
                var pointCenter = currPointView.center
                pointCenter.y = centerY
                currPointView.center = pointCenter
                
                if self.pageControlModel.currentPointImage != nil {
                    currPointView.backgroundColor = UIColor.clear
                    currPointView.image = UIImage.init(named: self.pageControlModel.currentPointImage!)
                } else {
                    currPointView.layer.cornerRadius = pointHeight / 2.0
                    currPointView.layer.masksToBounds = true
                    currPointView.backgroundColor = self.pageControlModel.currentPointColor
                }
                
                // 设置startX的值
                startX = currPointView.frame.maxX + self.pageControlModel.pointSpace
            } else {    // 未选中的点
                var pointWidth: CGFloat = 0.0
                var pointHeight: CGFloat = 0.0
                if self.pageControlModel.isEllipse {
                    pointWidth = self.pageControlModel.pointWidth
                    pointHeight = self.pageControlModel.pointHeight
                } else {
                    pointWidth = self.pageControlModel.pointWidth * self.pageControlModel.pointScale
                    pointHeight = self.pageControlModel.pointHeight * self.pageControlModel.pointScale
                }
                
                let otherPointView = UIImageView.init(frame: CGRect.init(x: startX, y: 0.0, width: pointWidth, height: pointHeight))
                self.addSubview(otherPointView)
                
                // 中点位置
                var pointCenter = otherPointView.center
                pointCenter.y = centerY
                otherPointView.center = pointCenter
                
                if self.pageControlModel.otherPointImage != nil {
                    otherPointView.backgroundColor = UIColor.clear
                    otherPointView.image = UIImage.init(named: self.pageControlModel.otherPointImage!)
                } else {
                    otherPointView.layer.cornerRadius = pointHeight / 2.0
                    otherPointView.layer.masksToBounds = true
                    otherPointView.backgroundColor = self.pageControlModel.otherPointColor
                }
                
                // 设置startX的值
                startX = otherPointView.frame.maxX + self.pageControlModel.pointSpace
            }
        }
    }
}
