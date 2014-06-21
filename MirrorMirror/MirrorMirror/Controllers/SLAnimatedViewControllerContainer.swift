//
//  SLAnimatedViewController.swift
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/4/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

import UIKit

class SLAnimatedViewControllerContainer: UIViewController {
	
	var rootViewController: UIViewController!
	
	
	/* Lifecycle
	------------------------------------------*/
	
	init(rootViewController: UIViewController) {
		
		self.rootViewController = rootViewController
		super.init(coder: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.autoresizesSubviews = true
		
		if self.childViewControllers.count == 0 {
			self.addViewController(self.rootViewController)
			var rootView: UIView = self.rootViewController.view
			rootView.frame = self.view.bounds
			self.view.addSubview(rootView)
			self.rootViewController.didMoveToParentViewController(self)
		}
	}
	
	
	/* Instance Methods
	------------------------------------------*/
	
	func addViewController(viewController: UIViewController) {
		viewController.willMoveToParentViewController(self)
		self.addChildViewController(viewController)
		//self.childViewControllers
	}
	
	func topMostViewController() -> UIViewController {
		return self.childViewControllers[self.childViewControllers.endIndex - 1] as UIViewController
	}
	
	func previousViewController() -> UIViewController? {
		if self.childViewControllers.count == 1 {
			return nil
		}
		
		var index = self.childViewControllers.count - 2
		return self.childViewControllers[index] as? UIViewController
	}
	
	func pushViewController(viewController: UIViewController, duration: NSTimeInterval, animationStart: (() -> Void), animationEnd: (() -> Void), completion: (() -> Void)) {
		self.addViewController(viewController)
		viewController.view.transform = CGAffineTransformIdentity
		
		self.view.addSubview(viewController.view)
		
		animationStart()
		
		UIView.animateWithDuration(duration, animations: {
				animationEnd()
			}, completion: {
				_ in
				viewController.didMoveToParentViewController(self)
				
				completion()
			})
		
	}
	
	func popViewControllerWithDuration(duration: NSTimeInterval, animationStart: (() -> Void), animationEnd: (() -> Void), completion: (() -> Void)) {
		
		if self.childViewControllers.count == 1 {
			return
		}
		
		var topVC: UIViewController = self.topMostViewController()
		
		topVC.willMoveToParentViewController(nil)
		
		var targetVC: UIViewController = self.previousViewController()!
		var previousTransform: CGAffineTransform = targetVC.view.transform
		targetVC.view.transform = CGAffineTransformIdentity
		targetVC.view.frame = self.view.bounds
		targetVC.view.transform = previousTransform
		
		animationStart()
		
		UIView.animateWithDuration(duration, animations: {
				animationEnd()
			}, completion: {
				_ in
				topVC.view.removeFromSuperview()
				topVC.removeFromParentViewController()
				
				completion()
			})
	}
	
}
