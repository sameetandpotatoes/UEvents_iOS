//
//  ViewController.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/29/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit

class ViewController: GAITrackedViewController, UIPageViewControllerDataSource, UINavigationControllerDelegate {
    
    var pageViewController : UIPageViewController = UIPageViewController()
    var appearanceController:AppearanceController = AppearanceController()
    var pageTitles:NSArray = []
    var pageImages:NSArray = []
    @IBOutlet var pageControl:UIPageControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitles = ["", ""]
        pageImages = ["Home1.png", "Home2.png"]
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageViewController.dataSource = self
//        self.navigationController.delegate = self
        var startingViewController:PageContentViewController = self.viewControllerAtIndex(0)!
        var viewControllers:NSArray = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, appearanceController.width, appearanceController.height + 40)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        var colors:Dictionary<String, Dictionary<String, String>> = appearanceController.getColors()
//        self.navigationController.navigationBar.barTintColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
//        self.navigationController.navigationBar.tintColor = appearanceController.colorWithHexString(colors["Default"]!["Secondary"]!)
//        self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        var navBarSize:CGSize = self.navigationController.navigationBar.bounds.size
//        var origin:CGPoint = CGPointMake( navBarSize.width/2, navBarSize.height/2 )
//        self.navigationController.navigationBarHidden = true
//        pageControl!.numberOfPages = 3
//        pageControl!.pageIndicatorTintColor = UIColor.lightGrayColor()
//        pageControl!.currentPageIndicatorTintColor = UIColor.whiteColor()
//        pageControl!.backgroundColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
//        pageControl!.frame = CGRectMake(0,0, pageControl!.bounds.size.width, pageControl!.bounds.size.height)
//        self.navigationController.delegate = self
        fixAnimation()
    }
    func fixAnimation(){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //make calculations
            dispatch_async(dispatch_get_main_queue(),{
                UIView.setAnimationsEnabled(true)
            })
        })
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Login"
    }
    override func shouldAutorotate() -> Bool {
        return appearanceController.isIPAD()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController!{
        var pcvc:PageContentViewController = viewController as PageContentViewController
        var index:Int = Int(pcvc.pageIndex)
        var uIndex:UInt = UInt(index)
        self.pageControl!.currentPage = Int(index)
        if (uIndex == 0) || (uIndex == Foundation.NSNotFound){
            return nil;
        }
        index--;
        return self.viewControllerAtIndex(Int(index))
    }
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController!{
        var pcvc:PageContentViewController = viewController as PageContentViewController
        var index:Int = Int(pcvc.pageIndex)
        self.pageControl!.currentPage = Int(index)
        if UInt(index) == Foundation.NSNotFound{
            return nil
        }
        index++;
        if (Int(index) == self.pageTitles.count){
            return nil
        }
        return self.viewControllerAtIndex(Int(index))
    }
    func viewControllerAtIndex(var index:NSInteger) -> PageContentViewController?{
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)){
            return nil
        }
        var pageContentViewController:PageContentViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageContentViewController") as PageContentViewController
        pageContentViewController.imageFile = pageImages[index] as NSString
        pageContentViewController.titleText = pageTitles[index] as NSString
        pageContentViewController.pageIndex = UInt(index)
        return pageContentViewController
    }
}