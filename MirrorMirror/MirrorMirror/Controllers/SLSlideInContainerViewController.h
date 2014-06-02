//
//  SLSlideInContainerViewController.h
//  MirrorMirror
//
//  Created by Bradley Griffith on 5/31/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAnimatedViewControllerContainer.h"

@interface SLSlideInContainerViewController : SLAnimatedViewControllerContainer

- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;

@end
