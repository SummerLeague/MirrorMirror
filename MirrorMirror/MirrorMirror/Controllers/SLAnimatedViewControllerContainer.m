//
//  SLAnimatedViewControllerContainer.m
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/1/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

#import "SLAnimatedViewControllerContainer.h"

@interface SLAnimatedViewControllerContainer ()

@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation SLAnimatedViewControllerContainer

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super init];
	if (self) {
		self.rootViewController = rootViewController;
	}
	return self;
}

- (void)addController:(UIViewController *)viewController
{
	[viewController willMoveToParentViewController:self];
	[self addChildViewController:viewController];
}

- (UIViewController *)topMostViewController
{
	return [self.childViewControllers lastObject];
}

- (UIViewController *)previousViewController
{
	if ([self.childViewControllers count] == 1) {
		return nil;
	}
	int index = [self.childViewControllers count] - 2;
	return self.childViewControllers[index];
}


// Note:
//   Subclassers should define how the both the currently displayed view controller, and the view controller to be displayed,
//   should begin and end their respective animations using the animationStart and animationEnd blocks.
- (void)pushViewController:(UIViewController *)viewController withDuration:(NSTimeInterval)duration animatioStart:(void (^)(void))animationStart animationEnd:(void (^)(void))animationEnd completion:(void (^)(void))completion
{
	[self addController:viewController];
	viewController.view.transform = CGAffineTransformIdentity;
	[self.view addSubview:viewController.view];
	
	animationStart();
	
	[UIView animateWithDuration:duration animations:^{
		animationEnd();
	} completion:^(BOOL finished) {
		[viewController didMoveToParentViewController:self];
		if (completion) {
			completion();
		}
	}];
}

// Note:
//   Subclassers should define how the both the currently displayed view controller, and the view controller to be displayed,
//   should begin and end their respective animations using the animationStart and animationEnd blocks.
- (void)popViewControllerWithDuration:(NSTimeInterval)duration animatioStart:(void (^)(void))animationStart animationEnd:(void (^)(void))animationEnd completion:(void (^)(void))completion
{
	if ([self.childViewControllers count] == 1) {
		return;
	}
	
	UIViewController *topVC = [self topMostViewController];
	
	[topVC willMoveToParentViewController:nil];
	
	UIViewController *targetVC = [self previousViewController];
	CGAffineTransform previousTransform = targetVC.view.transform;
	targetVC.view.transform = CGAffineTransformIdentity;
	targetVC.view.frame = self.view.bounds;
	targetVC.view.transform = previousTransform;
	
	animationStart();
	
	[UIView animateWithDuration:duration animations:^{
		animationEnd();
	} completion:^(BOOL finished) {
		[topVC.view removeFromSuperview];
		[topVC removeFromParentViewController];
		if (completion) {
			completion();
		}
	}];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	
	if ([self.childViewControllers count] == 0) {
		[self addController:self.rootViewController];
		UIView *rootView = self.rootViewController.view;
		rootView.frame = self.view.bounds;
		[self.view addSubview:rootView];
		[self.rootViewController didMoveToParentViewController:self];
	}
}

@end


@implementation UIViewController (AnimatedContainer)

- (SLAnimatedViewControllerContainer *)animatedContainer {
	return (SLAnimatedViewControllerContainer *)self.parentViewController;
}

@end