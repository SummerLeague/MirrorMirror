//
//  SLAnimatedViewControllerContainer.h
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/1/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAnimatedViewControllerContainer : UIViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController;

- (UIViewController *)topMostViewController;
- (UIViewController *)previousViewController;

- (void)pushViewController:(UIViewController *)viewController withDuration:(NSTimeInterval)duration animatioStart:(void (^)(void))animationStart animationEnd:(void (^)(void))animationEnd completion:(void (^)(void))completion;
- (void)popViewControllerWithDuration:(NSTimeInterval)duration animatioStart:(void (^)(void))animationStart animationEnd:(void (^)(void))animationEnd completion:(void (^)(void))completion;

@end

@interface UIViewController (AnimatedContainer)

@property (nonatomic, readonly) SLAnimatedViewControllerContainer *animatedContainer;

@end
