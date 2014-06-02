//
//  SLSlideInContainerViewController.m
//  MirrorMirror
//
//  Created by Bradley Griffith on 5/31/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

#import "SLSlideInContainerViewController.h"

#define ANIMATION_DURATION 0.9

@interface SLSlideInContainerViewController ()

@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation SLSlideInContainerViewController


- (void)pushViewController:(UIViewController *)viewController {
	UIViewController *topVC = [self topMostViewController];

	[self pushViewController:viewController withDuration:ANIMATION_DURATION animatioStart:^{
		viewController.view.frame = self.view.bounds;
		viewController.view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
	} animationEnd:^{
		topVC.view.alpha = 0.5;
		topVC.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
		viewController.view.transform = CGAffineTransformIdentity;
	} completion:nil];
}

- (void)popViewController {
	UIViewController *targetVC = [self previousViewController];
	UIViewController *topVC = [self topMostViewController];

	if (targetVC) {
		[self popViewControllerWithDuration:ANIMATION_DURATION animatioStart:^{
			
		} animationEnd:^{
			targetVC.view.alpha = 1.0;
			targetVC.view.transform = CGAffineTransformIdentity;
			topVC.view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
		} completion:nil];
	}
}

@end
