//
//  UIViewController+Qs.swift
//  QSExtensions
//
//  Created by Song on 2018/10/31.
//  Copyright © 2018 Song. All rights reserved.
//

import UIKit
import ETNavBarTransparent

extension UIViewController: UIGestureRecognizerDelegate {
    /// 设置导航栏的shadowImage，默认隐藏
    ///
    /// - Parameters:
    ///   - isHidden: 是否隐藏
    ///   - color: 颜色，隐藏时，设置颜色无效
    public func qs_setNavBarShadowImage(isHidden: Bool = true, color: UIColor? = nil) {
        guard let nav = navigationController else { return }
        
        if !isHidden {
            if let c = color {
                if #available(iOS 13.0, *) {
                    nav.navigationBar.standardAppearance.shadowImage = UIImage.qs_image(with: c, size: CGSize.init(width: UIScreen.main.bounds.size.width, height: 1.0))
                    nav.navigationBar.standardAppearance.shadowColor = c
                    nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
                } else {
                    nav.navigationBar.shadowImage = UIImage.qs_image(with: c, size: CGSize.init(width: UIScreen.main.bounds.size.width, height: 1.0))
                }
            }
        } else {
            if #available(iOS 13.0, *) {
                nav.navigationBar.standardAppearance.shadowImage = UIImage()
                nav.navigationBar.standardAppearance.shadowColor = nil
                nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
            } else {
                nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
                nav.navigationBar.shadowImage = UIImage.init()
            }
        }
    }
    
    /// 设置TabBar的shadowImage是否隐藏
    ///
    /// - Parameter isHidden: 是否隐藏
    public func qs_setTabBarShadowImage(isHidden: Bool = true) {
        guard let tabVc = tabBarController else { return }
        
        if let tabBarSubView = tabVc.tabBar.subviews.first {
            if let subView = tabBarSubView.subviews.first {
                subView.isHidden = isHidden
            }
        }
    }
    
    /// 设置穿透导航栏
    ///
    /// - Parameters:
    ///   - isExtend: 是否穿透导航栏
    public func qs_setExtendNavBar(isExtend: Bool = false) {
        guard let nav = navigationController else { return }
        
        if isExtend {
            nav.navigationBar.isTranslucent = true
            navBarBgAlpha = 0.0
            edgesForExtendedLayout = UIRectEdge.top
        } else {
            nav.navigationBar.isTranslucent = false
            navBarBgAlpha = 1.0
            edgesForExtendedLayout = UIRectEdge()
        }
    }
    
    /// 设置穿透tabBar
    ///
    /// - Parameters:
    ///   - isExtend: 是否需要穿透tabBar
    public func qs_setExtendTabBar(isExtend: Bool = false) {
        if isExtend {
            edgesForExtendedLayout = UIRectEdge.bottom
        } else {
            edgesForExtendedLayout = UIRectEdge()
        }
    }
    
    /// 设置导航栏的背景颜色
    ///
    /// - Parameter color: 背景颜色
    public func qs_setNavBarBgColor(_ color: UIColor) {
        guard let nav = navigationController else { return }
        nav.navigationBar.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            nav.navigationBar.standardAppearance.backgroundColor = color
            nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        } else {
            nav.navigationBar.barTintColor = color
        }
    }
    
    /// 设置导航栏的背景图片
    ///
    /// - Parameter imgName: 背景图片名
    public func qs_setNavBarBgImg(_ imgName: String) {
        guard let nav = navigationController else { return }
        
        nav.navigationBar.setBackgroundImage(UIImage.init(named: imgName), for: UIBarMetrics.default)
    }
    
    /// 导航栏是否使用大标题
    ///
    /// - Parameter isUse: 是否使用
    public func qs_useLargeTitleNav(_ isUse: Bool) {
        guard let nav = navigationController else { return }
        
        nav.navigationBar.prefersLargeTitles = isUse
    }
    
    /// 设置导航栏title的字体大小和颜色
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - color: 字体颜色
    public func qs_setNavTitle(font: UIFont = UIFont.systemFont(ofSize: 17.0), color: UIColor = .black) {
        guard let nav = navigationController else { return }
        
        let navBar = nav.navigationBar
        // 去除透明
        navBar.isTranslucent = false
        
        var attDict = Dictionary<NSAttributedString.Key, Any>.init()
        attDict[NSAttributedString.Key.foregroundColor] = color
        attDict[NSAttributedString.Key.font] = font
        
        if #available(iOS 13.0, *) {
            nav.navigationBar.standardAppearance.titleTextAttributes = attDict
            nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        } else {
            navBar.titleTextAttributes = attDict
        }
    }
    
    /// 设置导航栏largeTitle的字体大小和颜色
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - color: 字体颜色
    public func qs_setNavLargeTitle(font: UIFont = UIFont.systemFont(ofSize: 17.0), color: UIColor = .black) {
        guard let nav = navigationController else { return }
        
        let navBar = nav.navigationBar
        // 去除透明
        navBar.isTranslucent = false
        
        if navBar.prefersLargeTitles {
            var attDict = Dictionary<NSAttributedString.Key, Any>.init()
            attDict[NSAttributedString.Key.foregroundColor] = color
            attDict[NSAttributedString.Key.font] = font
            
            if #available(iOS 13.0, *) {
                nav.navigationBar.standardAppearance.largeTitleTextAttributes = attDict
                nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
            } else {
                navBar.largeTitleTextAttributes = attDict
            }
        }
    }
    
    /// 是否隐藏导航栏
    ///
    /// - Parameters:
    ///   - hidden: 是否隐藏
    ///   - animated: 动画
    public func qs_hideNavBar(_ hidden: Bool, animated: Bool = true) {
        guard let nav = navigationController else { return }
        
        nav.setNavigationBarHidden(hidden, animated: animated)
    }
}
