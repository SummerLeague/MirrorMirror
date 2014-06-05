//
//  SLRootNavigationContainerViewController.swift
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/3/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

import UIKit

class SLRootNavigationContainerViewController: UIViewController {
	
	var slideInController: SLSlideInContainerViewController! = nil
	var cameraViewController: SLCameraViewController!
	var feedViewController: SLFeedViewController!
	@IBOutlet var rootContainerView: UIView!
	
	init(coder aDecoder: NSCoder!) {
		super.init(coder:aDecoder)
		
		self.cameraViewController = SLCameraViewController()
		self.feedViewController = SLFeedViewController()
	}
	
	override func viewDidLoad() {
		self.setupSlideInController()
		self.slideInController.pushViewController(self.feedViewController)
	}
	
	func setupSlideInController() {
		self.slideInController = SLSlideInContainerViewController(rootViewController: self.cameraViewController)
		
		self.slideInController.willMoveToParentViewController(self)
		self.addChildViewController(self.slideInController)
		
		self.slideInController.view.frame = self.rootContainerView.bounds
		
		self.rootContainerView.addSubview(self.slideInController.view)
		self.slideInController.didMoveToParentViewController(self)
	}
	
	@IBAction func showCamera(AnyObject) {
		self.slideInController.popViewController()
		
		let hideCameraButton: UIBarButtonItem = UIBarButtonItem(title: "x", style: .Plain, target: self, action: "hideCamera:")
		self.navigationItem.leftBarButtonItem = hideCameraButton;
		
		//self.navigationController.navigationBar.barTintColor = UIColor.redColor()
	}
	
	func hideCamera(AnyObject) {
		self.slideInController.pushViewController(self.feedViewController)
		
		self.navigationItem.leftBarButtonItem = nil;
	}

}
