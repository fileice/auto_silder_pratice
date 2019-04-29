//
//  AutoSliderViewController.swift
//  DW_Eat
//
//  Created by fileice on 2019/4/28.
//  Copyright © 2019 fileice. All rights reserved.
//

import UIKit

class AutoSliderViewController: UIViewController, SliderGalleryControllerDelegate {
    

    @IBOutlet weak var loopScrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    //取得螢幕寬度
    let screenWidth =  UIScreen.main.bounds.size.width
    
    //圖片輪播組件
    var sliderGallery : SliderGalleryController!
    
    //圖片集合
    var images = ["http://img4q.duitang.com/uploads/item/201503/18/20150318230437_Pxnk3.jpeg",
                  "http://img4.duitang.com/uploads/item/201501/31/20150131234424_WRJGa.jpeg",
                  "http://img5.duitang.com/uploads/item/201502/11/20150211095858_nmRV8.jpeg",
                  "http://cdnq.duitang.com/uploads/item/201506/11/20150611213132_HPecm.jpeg"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DW Eat"
        
        //初始化圖片輪播組件
        sliderGallery = SliderGalleryController()
        sliderGallery.delegate = self
        sliderGallery.view.frame = CGRect(x: 10, y: 90, width: screenWidth-20,
                                          height: (screenWidth-20)/4*3);
        
        //將圖片輪播組件添加到當前視圖
        self.addChild(sliderGallery)
        self.view.addSubview(sliderGallery.view)
        
        //組件點擊事件
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(AutoSliderViewController.handleTapAction(_:)))
        sliderGallery.view.addGestureRecognizer(tap)
    }
    
    //圖片輪播組件協定實作：取得內部scrollView尺寸
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: screenWidth-20, height: (screenWidth-20)/4*3)
    }
    
    //圖片輪播組件協定實作：取得數據集合
    func galleryDataSource() -> [String] {
        return images
    }
    
    //點擊事件實作
    @objc func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
        //取得圖片索引值
        let index = sliderGallery.currentIndex
        //彈出索引視窗
        let alertController = UIAlertController(title: "點擊圖片索引值：",
                                                message: "\(index)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //刷新數據按鈕點擊
    @IBAction func reloadBtnTap(_ sender: AnyObject) {
        images = ["http://img3.duitang.com/uploads/item/201607/15/20160715160527_rSBfF.jpeg",
                  "http://d1.17xgame.com/d/wallpaper/2013/01/17/52549.jpg",
                  "http://p4.image.hiapk.com/uploads/allimg/140805/7730-140P5115S4.jpg"]
        sliderGallery.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
