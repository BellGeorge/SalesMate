//
//  AppDelegate.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 6/30/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTabBarController.h"
#import "SFOAuthCoordinator.h"
#import "PSStackedViewController.h"

#define MESSAGE_OPPORTUNITIES_UPDATED @"opportunities updated and saved"
#define MESSAGE_LEADS_UPDATED @"leads updated and saved"
#define MESSAGE_STREAMING_UPDATE_RECEIVED @"streaming update received"

@class RootTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NGTabBarControllerDelegate, SFOAuthCoordinatorDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SFOAuthCoordinator *coordinator;

@property (strong, nonatomic) RootTabBarController *tabBarController;
@property (strong, nonatomic) PSStackedViewController *opportunitiesStackController;
@property (strong, nonatomic) PSStackedViewController *leadsStackController;
@property (strong, nonatomic) PSStackedViewController *nearMeStackController;

- (void)performLoginLogout;

@end
