//
//  RootTabBarController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/1/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "RootTabBarController.h"

#import "DataHandler.h"

#import "LeadsViewController.h"

@interface RootTabBarController ()
{
    UIImageView *_flagImageView;
    UIButton *_flagButton;
    
    Boolean _isWatchingForUpdates;
}
- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@implementation RootTabBarController

@synthesize authButton = _authButton;
@synthesize refreshButton = _refreshButton;

- (id)initWithDelegate:(id<NGTabBarControllerDelegate>)delegate 
{
    self = [super initWithDelegate:delegate];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tactile_noise.png"]]];
        
        self.animation = NGTabBarControllerAnimationMoveAndScale;
        self.tabBar.tintColor = [UIColor colorWith256Red:255 green:255 blue:255 alpha:25];
        self.tabBar.backgroundColor = [UIColor clearColor];
        self.tabBar.backgroundImage = [UIImage imageNamed:@"random_grey_variations.png"];
        self.tabBar.itemPadding = 0.f;
        self.tabBarPosition = NGTabBarPositionLeft;
        self.tabBar.drawItemHighlight = YES;
        self.tabBar.drawGloss = NO;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyCentered;
        
        _authButton = [IBButton glossButtonWithTitle:@"Log In" color:[UIColor colorWithHexString:@"BDFDFF33"]];
        [_authButton setFrame:CGRectMake(15.0f, 15.0f, 120.0f, 37.0f)];
        [_authButton setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
        [_authButton setBottom:self.tabBar.height - 10.0f];
        [_authButton addTarget:(AppDelegate *)[[UIApplication sharedApplication] delegate]
                        action:SEL(performLoginLogout)
              forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:_authButton];
        
        _refreshButton = [IBButton glossButtonWithTitle:@"Refresh Data" color:[UIColor colorWithHexString:@"BDFDFF33"]];
        [_refreshButton setFrame:RECT_STACKED_OFFSET_BY_Y(_authButton.frame, -80.0f)];
        [_refreshButton setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
        [_refreshButton addTarget:self
                        action:SEL(refreshData)
              forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton setHidden:YES];
        [self.tabBar addSubview:_refreshButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImage *flagImage = [UIImage imageWithIdentifier:@"notification flag" forSize:CGSizeMake(150.0f, 200.0f) andDrawingBlock:^{
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Shadow Declarations
        CGColorRef outerShadow = [UIColor blackColor].CGColor;
        CGSize outerShadowOffset = CGSizeMake(3, 6);
        CGFloat outerShadowBlurRadius = 9;
        CGColorRef innerShaddow = [UIColor blackColor].CGColor;
        CGSize innerShaddowOffset = CGSizeMake(0, -0);
        CGFloat innerShaddowBlurRadius = 20;
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(137.5, 186)];
        [bezierPath addLineToPoint: CGPointMake(74, 133.47)];
        [bezierPath addLineToPoint: CGPointMake(10.52, 186)];
        [bezierPath addLineToPoint: CGPointMake(10.5, -23)];
        [bezierPath addLineToPoint: CGPointMake(137.5, -23)];
        [bezierPath addLineToPoint: CGPointMake(137.5, 186)];
        [bezierPath closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, outerShadowOffset, outerShadowBlurRadius, outerShadow);
        [[UIColor redColor] setFill];
        [bezierPath fill];
        
        ////// Bezier Inner Shadow
        CGRect bezierBorderRect = CGRectInset([bezierPath bounds], -innerShaddowBlurRadius, -innerShaddowBlurRadius);
        bezierBorderRect = CGRectOffset(bezierBorderRect, -innerShaddowOffset.width, -innerShaddowOffset.height);
        bezierBorderRect = CGRectInset(CGRectUnion(bezierBorderRect, [bezierPath bounds]), -1, -1);
        
        UIBezierPath* bezierNegativePath = [UIBezierPath bezierPathWithRect: bezierBorderRect];
        [bezierNegativePath appendPath: bezierPath];
        bezierNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = innerShaddowOffset.width + round(bezierBorderRect.size.width);
            CGFloat yOffset = innerShaddowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        innerShaddowBlurRadius,
                                        innerShaddow);
            
            [bezierPath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezierBorderRect.size.width), 0);
            [bezierNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [bezierNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(133.5, 175)];
        [bezier2Path addLineToPoint: CGPointMake(74, 124.74)];
        [bezier2Path addLineToPoint: CGPointMake(14.52, 175)];
        [bezier2Path addLineToPoint: CGPointMake(14.5, -25)];
        [bezier2Path addLineToPoint: CGPointMake(133.5, -25)];
        [bezier2Path addLineToPoint: CGPointMake(133.5, 175)];
        [bezier2Path closePath];
        [[UIColor blackColor] setStroke];
        bezier2Path.lineWidth = 1;
        CGFloat bezier2Pattern[] = {3, 3, 3, 3};
        [bezier2Path setLineDash: bezier2Pattern count: 4 phase: 0];
        [bezier2Path stroke];
        

    }];
    
    _flagImageView = [[UIImageView alloc] initWithImage:flagImage];
    [_flagImageView setBottom:0.0f];
    [self.view addSubview:_flagImageView];
    
    UILabel *flagTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, -10.0f, 140.0f, 150.0f)];
    [flagTextLabel setBackgroundColor:[UIColor clearColor]];
    [flagTextLabel setTextColor:[UIColor whiteColor]];
    [flagTextLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
    [flagTextLabel setText:@"NEW\nLEAD!"];
    [flagTextLabel setTextAlignment:UITextAlignmentCenter];
    [flagTextLabel setNumberOfLines:2];
    [flagTextLabel setShadowColor:[UIColor blackColor]];
    [flagTextLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [flagTextLabel setTransform:CGAffineTransformMakeRotation(M_PI/-4)];
    [_flagImageView addSubview:flagTextLabel];
    
    _flagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flagButton setFrame:CGRectMake(0.0f, 0.0f, 150.0f, 200.0f)];
    [_flagButton addTarget:self
                   action:SEL(switchToLeads)
         forControlEvents:UIControlEventTouchUpInside];
    [_flagButton setEnabled:NO];
    [self.view addSubview:_flagButton];
    
    _isWatchingForUpdates = NO;
    
    [MessageCenter addGlobalMessageListener:MESSAGE_STREAMING_UPDATE_RECEIVED
                                     target:self
                                     action:SEL(beginWatchingForUpdates)];
    
    [MessageCenter addGlobalMessageListener:MESSAGE_LEADS_UPDATED
                                     target:self
                                     action:SEL(showNewUpdateFlag)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self setupForInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - Tab Bar Controller

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; 
{

}

#pragma mark - Actions

- (void)beginWatchingForUpdates
{
    _isWatchingForUpdates = YES;
}

- (void)showNewUpdateFlag
{
    if (_isWatchingForUpdates) {
        _isWatchingForUpdates = NO;
        [_flagButton setEnabled:YES];
        
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             [_flagImageView setTop:0.0f];
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.4f
                                                   delay:4.0f
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
                                                  [_flagImageView setBottom:0.0f];
                                              }
                                              completion:^(BOOL finished){
                                                  [_flagButton setEnabled:NO];
                                              }];
                         }];
    }
}

- (void)switchToLeads 
{
    [((LeadsViewController *)[[[((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController viewControllers] objectAtIndex:1] rootViewController]) setShouldOpenNewestLead:YES];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController setSelectedIndex:1];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController setSelectedViewController:((AppDelegate *)[[UIApplication sharedApplication] delegate]).leadsStackController];
}

- (void)refreshData
{
    [DataHandler getOpportunities];
    [DataHandler getLeads];
}

@end
