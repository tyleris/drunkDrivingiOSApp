////
////  WmOnboardingViewController.swift
////  HolesTest
////
////  Created by Tyler Ibbotson-Sindelar on 4/26/17.
////
////
//
//import UIKit
//
//class WmOnboardingViewController: UIPageViewController {
//
//    //Mark: Properties
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        dataSource = self
//        
//    }
//
//    
//    // MARK: UIPageViewControllerDataSource
//}
//
//extension WmOnboardingViewController: UIPageViewControllerDataSource {
//    
//    func pageViewController(_ pageViewController: UIPageViewController,
//                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController,
//                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
//
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [self.newViewController("Green"),
//                self.newViewController("Red"),
//                self.newViewController("Blue")]
//    }()
//    
//    private func newColoredViewController(color: String) -> UIViewController {
//        return UIStoryboard(name: "Main", bundle: nil) .
//            instantiateViewControllerWithIdentifier("\(color)ViewController")
//    }
//    
//}
