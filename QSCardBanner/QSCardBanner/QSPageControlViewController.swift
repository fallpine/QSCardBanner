//
//  QSPageControlViewController.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSPageControlViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "PageControl"
        
        view.addSubview(normalPageC)
        normalPageC.frame = CGRect.init(x: 0, y: 100.0, width: UIScreen.main.bounds.width, height: 30.0)
        
        view.addSubview(ovalPageC)
        ovalPageC.frame = CGRect.init(x: 0, y: 150.0, width: UIScreen.main.bounds.width, height: 30.0)
        
        view.addSubview(imgPageC)
        imgPageC.frame = CGRect.init(x: 0, y: 200.0, width: UIScreen.main.bounds.width, height: 30.0)
        
        let nextBtn = UIButton.init(frame: CGRect.init(x: (UIScreen.main.bounds.width - 100.0) / 2.0, y: 260.0, width: 100.0, height: 30.0))
        view.addSubview(nextBtn)
        nextBtn.setTitle("next", for: .normal)
        nextBtn.setTitleColor(.green, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        nextBtn.layer.cornerRadius = 5.0
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.borderWidth = 1.5
        nextBtn.layer.borderColor = UIColor.green.cgColor
        
        nextBtn.addTarget(self, action: #selector(self.clickNextBtn), for: .touchUpInside)
    }
    
    @objc private func clickNextBtn() {
        normalPageC.currentPage = normalPageC.currentPage + 1 == normalPageC.numberOfPages ? 0 : normalPageC.currentPage + 1
        
        ovalPageC.currentPage = ovalPageC.currentPage + 1 == ovalPageC.numberOfPages ? 0 : ovalPageC.currentPage + 1
        
        imgPageC.currentPage = imgPageC.currentPage + 1 == imgPageC.numberOfPages ? 0 : imgPageC.currentPage + 1
    }
    
    private lazy var normalPageC: QSPageControl = {
        let pageControlModel = QSPageControlModel()
        pageControlModel.pointWidth = 8.0
        pageControlModel.pointHeight = 8.0
        pageControlModel.pointSpace = 17.0
        pageControlModel.otherPointColor = .gray
        pageControlModel.currentPointColor = .red
        
        let pageC = QSPageControl.init(frame: .zero, unmberOf: 5, currentPage: 0, model: pageControlModel)
        
        return pageC
    }()
    
    private lazy var ovalPageC: QSPageControl = {
        let pageControlModel = QSPageControlModel()
        pageControlModel.pointWidth = 8.0
        pageControlModel.pointHeight = 8.0
        pageControlModel.pointSpace = 17.0
        pageControlModel.otherPointColor = .gray
        pageControlModel.currentPointColor = .red
        pageControlModel.pageControlLocation = .left
        pageControlModel.pointScale = 1.5
        pageControlModel.isEllipse = true
        
        let pageC = QSPageControl.init(frame: .zero)
        pageC.pageControlModel = pageControlModel
        pageC.numberOfPages = 5
        pageC.currentPage = 0
        return pageC
    }()
    
    private lazy var imgPageC: QSPageControl = {
        let pageControlModel = QSPageControlModel()
        pageControlModel.pointWidth = 18.0
        pageControlModel.pointHeight = 18.0
        pageControlModel.pointSpace = 17.0
        pageControlModel.otherPointColor = .gray
        pageControlModel.currentPointColor = .red
        pageControlModel.currentPointImage = "pageControlSelected"
        pageControlModel.otherPointImage = "pageControlNormal"
        pageControlModel.pageControlLocation = .right
        
        let pageC = QSPageControl.init(frame: .zero)
        pageC.pageControlModel = pageControlModel
        pageC.numberOfPages = 5
        pageC.currentPage = 0
        return pageC
    }()
}
