//
//  AccountDetailsViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/17/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "AccountDetailsViewController.h"
#import "AccountContactsTableViewController.h"
#import "AccountOpportunitiesTableViewController.h"

#import "SalesAccount.h"

#import "TSMiniWebBrowser.h"

#import <MapKit/MapKit.h>

@interface AccountDetailsViewController ()
{
    CoreDataStore *_dataStore;
    SalesAccount *_account;
    
    UITableView *_accountDetailsTableView;
    
    AccountContactsTableViewController *_contactsTableViewController;
    AccountOpportunitiesTableViewController *_opportunitiesTableViewController;
}
@end

@implementation AccountDetailsViewController

@synthesize accountId = _accountId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _dataStore = [CoreDataStore createStore];
    _account = (SalesAccount *)[_dataStore entityByObjectID:_accountId];
    
    [self setTitle:_account.name];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gplaypattern.png"]]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self
                                                                                 action:SEL(dismissModalViewControllerAnimated:)];
    [self.navigationItem setRightBarButtonItem:closeButton];
    
    UIImage *backgroundImage = [UIImage imageWithIdentifier:@"Account Details Background" forSize:CGSizeMake(540.0f, 576.0f) andDrawingBlock:^{
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* semiTransparentBlack = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
        UIColor* descriptionBackdrop = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.35];
        
        //// Shadow Declarations
        CGColorRef mapInnerShadow = [UIColor blackColor].CGColor;
        CGSize mapInnerShadowOffset = CGSizeMake(0, -0);
        CGFloat mapInnerShadowBlurRadius = 10;
        CGColorRef mapDropShadow = [UIColor blackColor].CGColor;
        CGSize mapDropShadowOffset = CGSizeMake(3, 3);
        CGFloat mapDropShadowBlurRadius = 5;
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(240, 0, 300, 300)];
        [semiTransparentBlack setFill];
        [rectanglePath fill];
        
        ////// Rectangle Inner Shadow
        CGRect rectangleBorderRect = CGRectInset([rectanglePath bounds], -mapInnerShadowBlurRadius, -mapInnerShadowBlurRadius);
        rectangleBorderRect = CGRectOffset(rectangleBorderRect, -mapInnerShadowOffset.width, -mapInnerShadowOffset.height);
        rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
        
        UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
        [rectangleNegativePath appendPath: rectanglePath];
        rectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = mapInnerShadowOffset.width + round(rectangleBorderRect.size.width);
            CGFloat yOffset = mapInnerShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        mapInnerShadowBlurRadius,
                                        mapInnerShadow);
            
            [rectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
            [rectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [rectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(255, 15, 270, 270)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, mapDropShadowOffset, mapDropShadowBlurRadius, mapDropShadow);
        [[UIColor blackColor] setFill];
        [rectangle2Path fill];
        CGContextRestoreGState(context);
        
        
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10, 312, 255, 254) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, mapDropShadowOffset, mapDropShadowBlurRadius, mapDropShadow);
        [descriptionBackdrop setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
        
        
        //// Rounded Rectangle 2 Drawing
        UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(276, 312, 255, 254) byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, mapDropShadowOffset, mapDropShadowBlurRadius, mapDropShadow);
        [descriptionBackdrop setFill];
        [roundedRectangle2Path fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectangle2Path.lineWidth = 2;
        [roundedRectangle2Path stroke];
        

    }];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:backgroundImageView];
    
    //Map View
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(256.0f, 16.0f, 268.0f, 268.0f)];
    [mapView setMapType:MKMapTypeStandard];
    CLLocationCoordinate2D accountCoordinates = CLLocationCoordinate2DMake(UNBOX_DOUBLE(_account.geoLatitude), UNBOX_DOUBLE(_account.geoLongitude));
    [mapView setRegion:MKCoordinateRegionMake(accountCoordinates, MKCoordinateSpanMake(0.1f, 0.1f))];
    
    if (_account.geoLatitude != nil && _account.geoLongitude != nil) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:accountCoordinates];
        [mapView addAnnotation:annotation];
    }
    
    [self.view addSubview:mapView];
    
    // Account Details
    _accountDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(-45.0f, 0.0f, 285.0f, 300.0f) style:UITableViewStylePlain];
    [_accountDetailsTableView setBackgroundView:nil];
    [_accountDetailsTableView setBackgroundColor:[UIColor clearColor]];
    [_accountDetailsTableView setScrollEnabled:NO];
    [_accountDetailsTableView setSeparatorColor:[UIColor clearColor]];
    [_accountDetailsTableView setDataSource:self];
    [_accountDetailsTableView setDelegate:self];
    [self.view addSubview:_accountDetailsTableView];
    
    IBButton *websiteButton = [IBButton flatButtonWithTitle:@"View Website" color:[UIColor colorWithHexString:@"404080"]];
    [websiteButton setFrame:CGRectMake(10.0f, 154.0f, 220.0f, 37.0f)];
    [websiteButton addTarget:self
                      action:SEL(openWebsite) 
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:websiteButton];
    if (_account.website == nil) {
        [websiteButton setEnabled:NO];
    }
    
    // Other Tables
    _contactsTableViewController = [[AccountContactsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [_contactsTableViewController setAccountId:_accountId];
    [_contactsTableViewController setNavigationController:self.navigationController];
    [self.view addSubview:_contactsTableViewController.tableView];
    
    _opportunitiesTableViewController = [[AccountOpportunitiesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [_opportunitiesTableViewController setAccountId:_accountId];
    [_opportunitiesTableViewController setNavigationController:self.navigationController];
    [self.view addSubview:_opportunitiesTableViewController.tableView];
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

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.detailTextLabel setNumberOfLines:2];
        [cell.textLabel setNumberOfLines:2];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            [cell.textLabel setText:@"Type"];
            [cell.detailTextLabel setText:(_account.type != nil ? _account.type : @"Unknown")];
            break;
        }
        case 1:
        {
            [cell.textLabel setText:@"Industry"];
            [cell.detailTextLabel setText:(_account.industry != nil ? _account.industry : @"Unknown")];
            break;
        }
        case 2:
        {
            [cell.textLabel setText:@"Annual Revenue"];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setMaximumFractionDigits:0];
            [cell.detailTextLabel setText:(_account.annualRevenue != nil ? [numberFormatter stringFromNumber:_account.annualRevenue] : @"Unknown")];
            break;
        }
        case 3:
        {
            [cell.textLabel setText:@"Phone"];
            [cell.detailTextLabel setText:(_account.phone != nil ? _account.phone : @"Unknown")];
            break;
        }
        case 4:
        {
            [cell.textLabel setText:@"Fax"];
            [cell.detailTextLabel setText:(_account.fax != nil ? _account.fax : @"Unknown")];
            break;
        }
        case 5:
        {
            [cell.textLabel setText:@"Website"];
            [cell.detailTextLabel setText:(_account.website != nil ? _account.website : @"Unknown")];
            break;
        }
    }
    
    return cell;
}

#pragma mark - Actions

- (void)openWebsite
{
    TSMiniWebBrowser *browser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:_account.website]];
    [browser setMode:TSMiniWebBrowserModeModal];
    [browser setModalDismissButtonTitle:@"Close"];
    [browser setBarStyle:UIBarStyleBlack];
    [self presentModalViewController:browser animated:YES];
}

@end
