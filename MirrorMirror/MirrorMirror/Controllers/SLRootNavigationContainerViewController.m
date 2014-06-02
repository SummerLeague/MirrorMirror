//
//  SLRootNavigationContainerViewController.m
//  MirrorMirror
//
//  Created by Bradley Griffith on 5/31/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

#import "SLRootNavigationContainerViewController.h"
#import "SLSlideInContainerViewController.h"
#import "SLCameraViewController.h"
#import "SLFeedViewController.h"

@interface SLRootNavigationContainerViewController ()
- (IBAction)showCamera:(id)sender;
- (IBAction)cancelCamera:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *rootContainerView;
@property (nonatomic, strong) SLCameraViewController *cameraViewController;
@property (nonatomic, strong) SLFeedViewController *feedViewController;
@property (nonatomic, strong) SLSlideInContainerViewController *slideInController;

@end

@implementation SLRootNavigationContainerViewController


-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_cameraViewController = [[SLCameraViewController alloc] init];
		_feedViewController = [[SLFeedViewController alloc] init];
	}
	return self;
}

- (void)cancelCamera:(id)sender {
	[_slideInController pushViewController:_feedViewController];
}

- (IBAction)showCamera:(id)sender {
	[_slideInController popViewController];
}

- (void)setupSlideInController
{
	 _slideInController = [[SLSlideInContainerViewController alloc] initWithRootViewController:_cameraViewController];
	
	[_slideInController willMoveToParentViewController:self];
	[self addChildViewController:_slideInController];
	
	_slideInController.view.frame = _rootContainerView.bounds;
	
	[_rootContainerView addSubview:_slideInController.view];
	[_slideInController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self setupSlideInController];
	[_slideInController pushViewController:_feedViewController];
}

@end