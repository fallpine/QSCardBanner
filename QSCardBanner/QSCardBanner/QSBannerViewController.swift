//
//  QSBannerViewController.swift
//  CardBanner
//
//  Created by Song on 2019/2/23.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

class QSBannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Banner"
        
        view.addSubview(scrView)
        scrView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrView.addSubview(imagesCycleView1)
        imagesCycleView1.snp.makeConstraints { (make) in
            make.top.equalTo(30.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(200.0)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        imagesCycleView1.dataArray = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900621459&di=a284dcb615570c39251c16d82c10321c&imgtype=0&src=http%3A%2F%2Fwww.pptbz.com%2Fpptpic%2FUploadFiles_6909%2F201306%2F2013062320262198.jpg"]
        imagesCycleView1.selectedBlock = { (index) in
            print("imagesCycleView1 --- ", index)
        }
        
        scrView.addSubview(imagesCycleView2)
        imagesCycleView2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imagesCycleView1.snp.bottom).offset(30.0)
            make.height.equalTo(200.0)
        }
        imagesCycleView2.dataArray = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900621459&di=a284dcb615570c39251c16d82c10321c&imgtype=0&src=http%3A%2F%2Fwww.pptbz.com%2Fpptpic%2FUploadFiles_6909%2F201306%2F2013062320262198.jpg",
                                     "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900653396&di=16da218d8d8b0eb1d1fd73a5dc2637bb&imgtype=0&src=http%3A%2F%2Fwww.pptok.com%2Fwp-content%2Fuploads%2F2012%2F08%2Fxunguang-4.jpg",
                                     "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900670112&di=2a4c19d6a1b8cab6566ef29725f6303d&imgtype=0&src=http%3A%2F%2Fimg.bimg.126.net%2Fphoto%2FZZ5EGyuUCp9hBPk6_s4Ehg%3D%3D%2F5727171351132208489.jpg"]
        imagesCycleView2.selectedBlock = { (index) in
            print("imagesCycleView2 --- ", index)
        }
        
        scrView.addSubview(imagesCycleView3)
        imagesCycleView3.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imagesCycleView2.snp.bottom).offset(30.0)
            make.height.equalTo(200.0)
        }
        imagesCycleView3.dataArray = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900621459&di=a284dcb615570c39251c16d82c10321c&imgtype=0&src=http%3A%2F%2Fwww.pptbz.com%2Fpptpic%2FUploadFiles_6909%2F201306%2F2013062320262198.jpg",
                                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900653396&di=16da218d8d8b0eb1d1fd73a5dc2637bb&imgtype=0&src=http%3A%2F%2Fwww.pptok.com%2Fwp-content%2Fuploads%2F2012%2F08%2Fxunguang-4.jpg",
                                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550900670112&di=2a4c19d6a1b8cab6566ef29725f6303d&imgtype=0&src=http%3A%2F%2Fimg.bimg.126.net%2Fphoto%2FZZ5EGyuUCp9hBPk6_s4Ehg%3D%3D%2F5727171351132208489.jpg"]
        imagesCycleView3.selectedBlock = { (index) in
            print("imagesCycleView3 --- ", index)
        }
        
        scrView.addSubview(textCycleView)
        textCycleView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imagesCycleView3.snp.bottom).offset(30.0)
            make.height.equalTo(50.0)
            make.bottom.equalTo(-30.0)
        }
        textCycleView.dataArray = ["1111111111",
                                   "2222222222",
                                   "3333333"]
        textCycleView.selectedBlock = { (index) in
            print("textCycleView --- ", index)
        }
    }
    
    // MARK: - Widget
    private lazy var scrView: UIScrollView = {
        let view = UIScrollView.init()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imagesCycleView1: QSImageBannerView = {
        let model = QSBaseBannerModel.init()
        model.timeInterval = 3.0
        model.isAutoRun = true
        
        model.isNeedPageControl = true
        model.pageControlBottomMargin = 0.0
        model.pageControlHeight = 30.0
        model.pointWidth = 6.0
        model.pointHeight = 6.0
        model.pointSpace = 8.0
        model.otherPointColor = .blue
        model.currentPointColor = .red
        model.currentPointImage = nil
        model.otherPointImage = nil
        model.pageControlLocation = .left
        model.pointScale = 1.0
        model.isEllipse = false
        
        model.itemSize = CGSize.init(width: UIScreen.main.bounds.width, height: 200.0)
        model.itemWidthMargin = 0.0
        model.itemHeigtMargin = 0.0
        model.isCardStytle = false
        model.visibleCount = 3
        model.scrollDirection = .horizontal
        model.collectionViewBgColor = .gray
        
        let imagesCycleView = QSImageBannerView.init(frame: .zero)
        imagesCycleView.stytleModel = model
        return imagesCycleView
    }()
    
    private lazy var imagesCycleView2: QSImageBannerView = {
        let model = QSBaseBannerModel.init()
        model.timeInterval = 3.0
        model.isAutoRun = true
        
        model.isNeedPageControl = true
        model.pageControlBottomMargin = 0.0
        model.pageControlHeight = 30.0
        model.pointWidth = 6.0
        model.pointHeight = 6.0
        model.pointSpace = 8.0
        model.otherPointColor = .orange
        model.currentPointColor = .yellow
        model.currentPointImage = nil
        model.otherPointImage = nil
        model.pageControlLocation = .right
        model.pointScale = 2.0
        model.isEllipse = true
        
        model.itemSize = CGSize.init(width: UIScreen.main.bounds.width - 45.0, height: 200.0)
        model.itemWidthMargin = 10.0
        model.itemHeigtMargin = 10.0
        model.isCardStytle = false
        model.visibleCount = 3
        model.scrollDirection = .horizontal
        model.collectionViewBgColor = .gray
        model.isPagingEnabled = false
        
        let imagesCycleView = QSImageBannerView.init(frame: .zero)
        imagesCycleView.stytleModel = model
        return imagesCycleView
    }()
    
    private lazy var imagesCycleView3: QSImageBannerView = {
        let model = QSBaseBannerModel.init()
        model.timeInterval = 3.0
        model.isAutoRun = true
        
        model.isNeedPageControl = true
        model.pageControlBottomMargin = 0.0
        model.pageControlHeight = 30.0
        model.pointWidth = 12.0
        model.pointHeight = 12.0
        model.pointSpace = 8.0
        model.otherPointColor = .green
        model.currentPointColor = .purple
        model.currentPointImage = "star1"
        model.otherPointImage = "star"
        model.pageControlLocation = .middle
        model.pointScale = 1.0
        model.isEllipse = false
        
        model.itemSize = CGSize.init(width: UIScreen.main.bounds.width - 60.0, height: 200.0)
        model.itemWidthMargin = 0.0
        model.itemHeigtMargin = 0.0
        model.isCardStytle = true
        model.visibleCount = 3
        model.scrollDirection = .horizontal
        model.collectionViewBgColor = .gray
        model.isPagingEnabled = true
        
        let imagesCycleView = QSImageBannerView.init(frame: .zero)
        imagesCycleView.stytleModel = model
        return imagesCycleView
    }()
    
    private lazy var textCycleView: QSTextBannerView = {
        let model = QSBaseBannerModel.init()
        model.timeInterval = 3.0
        model.isAutoRun = true
        
        model.isNeedPageControl = false
        
        model.itemSize = CGSize.init(width: UIScreen.main.bounds.width, height: 50.0)
        
        model.isCardStytle = false
        model.visibleCount = 3
        model.collectionViewBgColor = .gray
        model.scrollDirection = .vertical
        
        let textCycleView = QSTextBannerView.init(frame: .zero)
        textCycleView.stytleModel = model
        return textCycleView
    }()
}
