//
//  SLSlideInContainerViewController.swift
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/4/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

import UIKit

class SLSlideInContainerViewController: SLAnimatedViewControllerContainer {
	
	//var rootViewController: UIViewController! = nil
	var animation_duration: NSTimeInterval = 0.9

	func pushViewController(viewController: UIViewController) {
		//var topVC: UIViewController! = self.topMostViewController()
		
		self.pushViewController(viewController, duration: self.animation_duration, animationStart: {
				viewController.view.frame = self.view.bounds
				viewController.view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
			},
			animationEnd: {
				//topVC.view.alpha = 0.5;
				//topVC.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
				viewController.view.transform = CGAffineTransformIdentity
			},
			completion: {
				
			});
	}

	func popViewController() {
		let targetVC = self.previousViewController()
		let topVC = self.topMostViewController()
		
		if (targetVC) {
			self.popViewControllerWithDuration(self.animation_duration, animationStart: {
					//
				},
				animationEnd: {
					//targetVC.view.alpha = 1.0
					//targetVC.view.transform = CGAffineTransformIdentity
					topVC.view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height)
				},
				completion: {
					
				})
		}
	}
}
