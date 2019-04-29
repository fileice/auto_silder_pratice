//
//  ViewController.swift
//  DW_Eat
//
//  Created by fileice on 2019/4/28.
//  Copyright © 2019 fileice. All rights reserved.
//

import UIKit

let pageNum = 3

class ViewController: UIViewController , UIScrollViewDelegate{
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var fullSize: CGSize!
    var index: Int!
    
    var imgList: [UIImage] = [
        UIImage(named: "bann1.jpg")!,
        UIImage(named: "bann2.jpg")!,
        UIImage(named: "bann3.jpg")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DW EAT"

        fullSize = UIScreen.main.bounds.size
        self.view.backgroundColor = UIColor.white
        
        // Scroll View
        scrollView = UIScrollView()
        
        scrollView.frame = CGRect(x: 0, y: 22, width: fullSize.width, height: fullSize.height - 20)

        //scrollView.frame = CGRect(x: 0, y: 22, width: self.view.frame.size.width, height:  self.view.frame.size.width/16 * 9)
        // 實際視圖範圍,有幾張圖就為幾倍
        scrollView.contentSize = CGSize(width: fullSize.width * CGFloat(imgList.count),
                                        height: fullSize.height)
        
        // 是否顯示滑動條
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // 滑動超過範圍時是否使用彈回效果
        scrollView.bounces = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        // Page controller
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: fullSize.width * 0.85,
                                                  height: 50))
        pageControl.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.9)
        pageControl.numberOfPages = imgList.count
        pageControl.currentPage = 0 // starting page
        pageControl.currentPageIndicatorTintColor = UIColor.black // 目前所在頁數的點點顏色
        pageControl.pageIndicatorTintColor = UIColor.lightGray // 其餘頁數的點點顏色
        
        pageControl.addTarget(self,
                              action: #selector(ViewController.pageChange),
                              for: .valueChanged)
        
        self.view.addSubview(pageControl)
        
        for index in 0...imgList.count - 1 {
            let imgView = UIImageView(image: imgList[index])
            imgView.frame = CGRect(x: 0, y: 0, width: fullSize.width, height: 500)
            imgView.center = CGPoint(x: fullSize.width * (0.5 + CGFloat(index)),
                                     y: fullSize.height * 0.5)
            
            scrollView.addSubview(imgView)            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    @IBAction func pageChange(_ sender: UIPageControl){
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}









