//
//  ViewController.swift
//  QSCardBanner
//
//  Created by Song on 2019/8/10.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "HomePage"
        
        let pageControlBtn = UIButton.init()
        view.addSubview(pageControlBtn)
        pageControlBtn.snp.makeConstraints { (make) in
            make.top.equalTo(100.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(100.0)
            make.height.equalTo(30.0)
        }
        pageControlBtn.setTitle("pageControl", for: .normal)
        pageControlBtn.setTitleColor(.green, for: .normal)
        pageControlBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        pageControlBtn.layer.cornerRadius = 5.0
        pageControlBtn.layer.masksToBounds = true
        pageControlBtn.layer.borderWidth = 1.5
        pageControlBtn.layer.borderColor = UIColor.green.cgColor
        pageControlBtn.addTarget(self, action: #selector(self.clickPageControlBtn), for: .touchUpInside)
        
        let bannerBtn = UIButton.init()
        view.addSubview(bannerBtn)
        bannerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pageControlBtn.snp.bottom).offset(30.0)
            make.centerX.width.height.equalTo(pageControlBtn)
        }
        bannerBtn.setTitle("banner", for: .normal)
        bannerBtn.setTitleColor(.green, for: .normal)
        bannerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        bannerBtn.layer.cornerRadius = 5.0
        bannerBtn.layer.masksToBounds = true
        bannerBtn.layer.borderWidth = 1.5
        bannerBtn.layer.borderColor = UIColor.green.cgColor
        bannerBtn.addTarget(self, action: #selector(self.clickBannerBtn), for: .touchUpInside)
    }
    
    @objc private func clickPageControlBtn() {
        navigationController?.pushViewController(QSPageControlViewController(), animated: true)
    }
    
    @objc private func clickBannerBtn() {
        navigationController?.pushViewController(QSBannerViewController(), animated: true)
    }
}
