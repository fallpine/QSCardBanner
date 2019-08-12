# QSCardBanner
这是一个轮播器的基类，其中QSBaseBannerView不能直接使用，使用方法下面会详细说明；但里面的QSPageControl可以单独拿出来使用
- #### 集成方法：直接用Pod导入，pod 'QSCardBanner'

先看下效果：录屏后转为gif有点模糊，可以直接下载demo，运行查看效果，demo中演示的图片来自百度图片，如有版权问题，请联系我删除

<img src="https://github.com/fallpine/QSCardBanner/blob/master/Screenshots/screen_record.gif" width="200"/>


- #### 使用方法：继承QSBaseBannerView，实现自己的子类
在子类中重写两个方法，类似下方的例子：
```
class QSImageBannerView: QSBaseBannerView {
      override func layoutSubviews() {
            super.layoutSubviews()
      
            // 注册collectionViewCell
            self.collectionView.register(QSImageBannerViewCell.self, forCellWithReuseIdentifier: "QSImageBannerViewCell")
      }
    
      // MARK: - override
      override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSImageBannerViewCell", for: indexPath) as!   QSImageBannerViewCell
      
            // cell的内容
            let row = indexPath.item % self.itemCount;
            let model = self.dataArray[row]     // Any类型
        
            return cell
      }
}
```

- #### 接着创建banner，QSBaseBannerModel中的属性注释写的挺清楚的，这里就不赘述了
```
private lazy var imagesCycleView: QSImageBannerView = {
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
```

- #### 使用banner
```
imagesCycleView.dataArray = 轮播器内容数组<Any>

// 选中cell响应事件
imagesCycleView.selectedBlock = { (index) in
      print("imagesCycleView --- ", index)
}
```

- #### 单独使用QSPageControl，QSPageControlModel中的属性注释写的挺清楚的，这里就不赘述了
```
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
```
