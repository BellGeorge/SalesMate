//
//  AppDelegate.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 6/30/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "DataHandler.h"

#import "RootTabBarController.h"

#import "PSStackedViewController.h"
#import "OpportunitiesViewController.h"
#import "LeadsViewController.h"
#import "NearMeViewController.h"

#import "SFOAuthCoordinator.h"
#import "SFRestAPI.h"
#import "LoginViewController.h"

#import "DCIntrospect.h"

@interface AppDelegate ()
{
    UINavigationController *_loginNavigationController;
    NSData *_deviceToken;
}
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize coordinator = _coordinator;

@synthesize tabBarController = _tabBarController;
@synthesize opportunitiesStackController = _opportunitiesStackController;
@synthesize leadsStackController = _leadsStackController;
@synthesize nearMeStackController = _nearMeStackController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    OpportunitiesViewController *opportunitiesViewController = [[OpportunitiesViewController alloc] init];
    _opportunitiesStackController = [[PSStackedViewController alloc] initWithRootViewController:opportunitiesViewController];
    [_opportunitiesStackController setDelegate:opportunitiesViewController];
    [_opportunitiesStackController setLeftInset:0];
    _opportunitiesStackController.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Opportunities" image:[UIImage imageNamed:@"money_bag_dollars.png"]];
    
    LeadsViewController *leadsViewController = [[LeadsViewController alloc] init];
    _leadsStackController = [[PSStackedViewController alloc] initWithRootViewController:leadsViewController];
    [_leadsStackController setLeftInset:0];
    _leadsStackController.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Leads" image:[UIImage imageNamed:@"favorite.png"]];
    
    NearMeViewController *nearMeViewController = [[NearMeViewController alloc] init];
    _nearMeStackController = [[PSStackedViewController alloc] initWithRootViewController:nearMeViewController];
    [_nearMeStackController setLeftInset:0];
    _nearMeStackController.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Leads Near Me" image:[UIImage imageNamed:@"compass.png"]];
    
    _tabBarController = [[RootTabBarController alloc] initWithDelegate:self];
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:_opportunitiesStackController, _leadsStackController, _nearMeStackController, nil]];
    [_tabBarController setTabBarPosition:NGTabBarPositionLeft];
    
    [self.window setRootViewController:_tabBarController];
    [self.window makeKeyAndVisible];
    
#warning - Provide Remove Access ID
    SFOAuthCredentials *credentials = [[SFOAuthCredentials alloc] initWithIdentifier:@"Sales Mate"
                                                                            clientId:nil
                                                                           encrypted:NO];
    [credentials setRedirectUri:@"salesmate://success"];
    _coordinator = [[SFOAuthCoordinator alloc] initWithCredentials:credentials];
    [_coordinator setDelegate:self];
    
    [[SFRestAPI sharedInstance] setCoordinator:_coordinator];
    
    [_coordinator authenticate];
    
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    _deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Remote Notifications Registration Error: %@", error);
}

#pragma mark - Tab Bar Controller

- (CGSize)tabBarController:(NGTabBarController *)tabBarController sizeOfItemForViewController:(UIViewController *)viewController atIndex:(NSUInteger)index position:(NGTabBarPosition)position
{
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(150.f, 150.f);
    } else {
        return CGSizeMake(60.f, 49.f);
    }
}

#pragma mark - Salesforce Delegate

- (void)oauthCoordinator:(SFOAuthCoordinator *)coordinator didBeginAuthenticationWithView:(UIWebView *)view
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [loginViewController setView:view];
    [loginViewController setTitle:@"Login"];
    
    _loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [_loginNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:SEL(cancelAuth)];
    [loginViewController.navigationItem setLeftBarButtonItem:cancelButton];
    
    [self.window.rootViewController presentModalViewController:_loginNavigationController animated:YES];
}

- (void)oauthCoordinator:(SFOAuthCoordinator *)coordinator didFailWithError:(NSError *)error
{
    
}

- (void)oauthCoordinatorDidAuthenticate:(SFOAuthCoordinator *)coordinator
{
    [[SFRestAPI sharedInstance] setCoordinator:_coordinator];
    [_loginNavigationController dismissModalViewControllerAnimated:YES];
    
    [DataHandler getOpportunities];
    [DataHandler getLeads];
    [DataHandler authenticateStreamingApi];
    
    if (_deviceToken != nil) {
        [DataHandler registerDeviceWithId:_deviceToken];
        _deviceToken = nil;
    }
    
    [_tabBarController.authButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [_tabBarController.refreshButton setHidden:NO];
}

#pragma mark - Actions

- (void)performLoginLogout
{
    [_coordinator revokeAuthentication];
    
    [_tabBarController.authButton setTitle:@"Log In" forState:UIControlStateNormal];
    [_tabBarController.refreshButton setHidden:YES];
    
    [DataHandler removeAllData];
    [_coordinator authenticate];
}

- (void)cancelAuth
{
    [_coordinator stopAuthentication];
    [_loginNavigationController dismissModalViewControllerAnimated:YES];
}

@end
