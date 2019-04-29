//
//  SliderGalleryController
//  DW_Eat
//
//  Created by fileice on 2019/4/28.
//  Copyright © 2019 fileice. All rights reserved.
//

import UIKit

//圖片輪播組件代理協定
protocol SliderGalleryControllerDelegate{
    //取得數據源
    func galleryDataSource()->[String]
    //func galleryDataSource()->[UIImage]

    //取得內部scrollerView的尺寸
    func galleryScrollerViewSize()->CGSize
}

//圖片輪播組件控制器
class SliderGalleryController: UIViewController,UIScrollViewDelegate{
    //代理對象
    var delegate : SliderGalleryControllerDelegate!
    
    //屏幕寬度
    let kScreenWidth = UIScreen.main.bounds.size.width
    
    //當前展示圖片索引
    var currentIndex : Int = 0
    
    //數據源
    var dataSource : [String]?
    //var dataSource : [UIImage]?
    
    //用於輪播的左中右三個image(不管圖片有幾張都是這三過imageView交替使用)
    var leftImageView , middleImageView , rightImageView : UIImageView?
    
    //放置imageView的滾動視窗
    var scrollerView : UIScrollView?
    
    //scrollView的寬和高
    var scrollerViewWidth : CGFloat?
    var scrollerViewHeight : CGFloat?
    
    //頁面控制器(小圓點)
    var pageControl : UIPageControl?
    
    //加載指示圖（用来當iamgeView還沒將圖片顯示出來時，顯示的圖片）
    var placeholderImage:UIImage!
    
    //自動滾動計時器
    var autoScrollTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取得並設置scrollView尺寸
        let size : CGSize = self.delegate.galleryScrollerViewSize()
        self.scrollerViewWidth = size.width
        self.scrollerViewHeight = size.height
        
        //取得數據
        self.dataSource =  self.delegate.galleryDataSource()
        //設置scrollerView
        self.configureScrollerView()
        //設置加載指示圖ㄆ片
        self.configurePlaceholder()
        //設置imageView
        self.configureImageView()
        //設置頁面控制器
        self.configurePageController()
        //設置自動滾動計時器
        self.configureAutoScrollTimer()
        
        self.view.backgroundColor = UIColor.black
    }
    
    //設置scrollerView
    func configureScrollerView(){
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0,
                                    width: self.scrollerViewWidth!,
                                    height: self.scrollerViewHeight!))
        self.scrollerView?.backgroundColor = UIColor.red
        self.scrollerView?.delegate = self
        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3,
                                                height: self.scrollerViewHeight!)
        //滾動視圖內容區域向左橫移一個view的寬度
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        self.view.addSubview(self.scrollerView!)
        
    }
    
    //設置加載指示圖片
    func configurePlaceholder(){
        //這裡有使用 ImageHelper 將文字转换成圖片，作為加載指示符
        let font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium)
        let size = CGSize(width: self.scrollerViewWidth!, height: self.scrollerViewHeight!)
        placeholderImage = UIImage(text: "圖片加載中...", font:font,
                                   color:UIColor.white, size:size)!
    }
    
    //設置imageView
    func configureImageView(){
        self.leftImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                       width: self.scrollerViewWidth!,
                                                       height: self.scrollerViewHeight!))
        self.middleImageView = UIImageView(frame: CGRect(x: self.scrollerViewWidth!, y: 0,
                                                         width: self.scrollerViewWidth!,
                                                         height: self.scrollerViewHeight! ))
        self.rightImageView = UIImageView(frame: CGRect(x: 2*self.scrollerViewWidth!, y: 0,
                                                        width: self.scrollerViewWidth!,
                                                        height: self.scrollerViewHeight!))
        self.scrollerView?.showsHorizontalScrollIndicator = false
        
        //設置初始時左中右三個imageView的圖片 (分别時數據源中最後一張，第一張，第二張圖片）
        if(self.dataSource?.count != 0){
            resetImageViewSource()
        }
        
        self.scrollerView?.addSubview(self.leftImageView!)
        self.scrollerView?.addSubview(self.middleImageView!)
        self.scrollerView?.addSubview(self.rightImageView!)
    }
    
    //設置頁面控制器
    func configurePageController() {
        self.pageControl = UIPageControl(frame: CGRect(x: kScreenWidth/2-60,
                        y: self.scrollerViewHeight! - 20, width: 120, height: 20))
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl!)
    }
    
    //設置自動輪播計時器
    func configureAutoScrollTimer() {
        //設置一個定時，每三秒滾動一次
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
                selector: #selector(SliderGalleryController.letItScroll),
                userInfo: nil, repeats: true)
    }
    
    //計時器時間到，滾動一張圖片
    @objc func letItScroll(){
        let offset = CGPoint(x: 2*scrollerViewWidth!, y: 0)
        self.scrollerView?.setContentOffset(offset, animated: true)
    }
    
    //每當滾動後重新設置各個imageView 圖片
    func resetImageViewSource() {
        //當前顯示的是第一張圖片
        if self.currentIndex == 0 {
            
            self.leftImageView?.imageFromURL(self.dataSource!.last!,
                                             placeholder: placeholderImage)
            self.middleImageView?.imageFromURL(self.dataSource!.first!,
                                               placeholder: placeholderImage)
            let rightImageIndex = (self.dataSource?.count)!>1 ? 1 : 0 //保護
            self.rightImageView?.imageFromURL(self.dataSource![rightImageIndex],
                                              placeholder: placeholderImage)
        }
            //當前顯示的是最好一張＝圖片
        else if self.currentIndex == (self.dataSource?.count)! - 1 {
            self.leftImageView?.imageFromURL(self.dataSource![self.currentIndex-1],
                                             placeholder: placeholderImage)
            self.middleImageView?.imageFromURL(self.dataSource!.last!,
                                               placeholder: placeholderImage)
            self.rightImageView?.imageFromURL(self.dataSource!.first!,
                                              placeholder: placeholderImage)
        }
            //其他情况
        else{
            self.leftImageView?.imageFromURL(self.dataSource![self.currentIndex-1],
                                             placeholder: placeholderImage)
            self.middleImageView?.imageFromURL(self.dataSource![self.currentIndex],
                                               placeholder: placeholderImage)
            self.rightImageView?.imageFromURL(self.dataSource![self.currentIndex+1],
                                              placeholder: placeholderImage)
        }
    }
    
    //scrollView滾動完畢觸
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //取得當前位移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSource?.count != 0){
            
            //如果向左滑動（顯示下一張）
            if(offset >= self.scrollerViewWidth!*2){
                //還原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //視圖索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑動（顯示上一張）
            if(offset <= 0){
                //還原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //視圖索-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            
            //重新設置各个imageView的圖片
            resetImageViewSource()
            //設置頁面控制器當前頁碼
            self.pageControl?.currentPage = self.currentIndex
        }
    }
    
    //手動拖曳滾動開始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //使自動滾動計時器失效（防止用户手動移動圖片的时候這邊也在自動滚動）
        autoScrollTimer?.invalidate()
    }
    
    //手動拖曳滾動结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        //重新啟動計時器
        configureAutoScrollTimer()
    }
    
    //重新加载數據
    func reloadData() {
        //索引重置
        self.currentIndex = 0
        //重新獲取数据
        self.dataSource =  self.delegate.galleryDataSource()
        //頁面控制器更新
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.currentPage = 0
        //重新設置各個imageView的圖片
        resetImageViewSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

