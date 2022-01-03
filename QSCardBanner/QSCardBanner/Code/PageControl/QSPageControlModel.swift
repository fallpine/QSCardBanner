//
//  QSPageControlModel.swift
//  QSCardBanner
//
//  Created by Song on 2019/8/10.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

/// PageControl显示的位置
public enum QSPageControlLocation {
    case right      // 居右
    case middle     // 居中
    case left       // 居左
}

public class QSPageControlModel: NSObject {
    /// 点的宽度，默认6.0
    public var pointWidth: CGFloat = 6.0
    /// 点的高度，默认6.0
    public var pointHeight:CGFloat = 6.0
    /// 点的间距，默认8.0
    public var pointSpace: CGFloat = 8.0
    /// 其他点颜色，默认红色
    public var otherPointColor: UIColor = UIColor.red
    /// 当前点颜色，默认蓝色
    public var currentPointColor: UIColor = UIColor.blue
    /// 当前点的图片，图片设置为nil会直接使用颜色
    public var currentPointImage: String?
    /// 其他点的图片，图片设置为nil会直接使用颜色
    public var otherPointImage: String?
    /// PageControl的位置, 默认居中
    public var pageControlLocation: QSPageControlLocation = .middle
    
    // MARK: - 如果是使用图片的话，不要设置这两个参数
    /// 当前点的放大倍数，默认1.0
    public var pointScale: CGFloat = 1.0
    /// 是否仅对当前点的宽度放大(即椭圆)，默认NO
    public var isEllipse: Bool = false
}
