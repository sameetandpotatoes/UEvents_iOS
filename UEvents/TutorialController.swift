//
//  TutorialController.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/22/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class TutorialController:GAITrackedViewController, UIPageViewControllerDataSource, UINavigationControllerDelegate{
    var pageViewController:UIPageViewController = UIPageViewController()
    var appearanceController:AppearanceController = AppearanceController()
    var pageTitles:NSArray = []
    var pageImages:NSArray = []
    var user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        //For use in PageContentViewController
        pageTitles = ["1", "2"]
        pageImages = ["Slideshow - 4", "Slideshow - 5"]
        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageViewController.dataSource = self
        var startingViewController:TutorialPageContent = self.viewControllerAtIndex(0)!
        var viewControllers:NSArray = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, appearanceController.width, appearanceController.height + 40)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //Hide everything
        self.navigationController.navigationBarHidden = true
        self.navigationController.toolbarHidden = true
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
        var pcvc:TutorialPageContent = viewController as TutorialPageContent
        var index:Int = Int(pcvc.pageIndex)
        if (index == 0) || (index == Foundation.NSNotFound){
            return nil;
        }
        index--;
        return self.viewControllerAtIndex(Int(index))
    }
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController!{
        var pcvc:TutorialPageContent = viewController as TutorialPageContent
        var index:Int = Int(pcvc.pageIndex)
        if index == Foundation.NSNotFound{
            return nil
        }
        index++;
        if (index == self.pageTitles.count){
            return nil
        }
        return self.viewControllerAtIndex(Int(index))
    }
    func viewControllerAtIndex(var index:NSInteger) -> TutorialPageContent?{
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)){
            return nil
        }
        var pageContentViewController:TutorialPageContent = self.storyboard.instantiateViewControllerWithIdentifier("TutorialPageContent") as TutorialPageContent
        //Gets appropriate image and title associated with page
        pageContentViewController.imageFile = pageImages[index] as NSString
        pageContentViewController.pageIndex = index
        pageContentViewController.user = user
        return pageContentViewController
    }
}