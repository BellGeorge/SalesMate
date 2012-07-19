//
//  LeadsViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/2/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "LeadsViewController.h"
#import "LeadDetailsViewController.h"

#import "Lead.h"

#import <MapKit/MapKit.h>

@interface LeadsViewController ()
{
    UITableView *_menuTableView;
    NSArray *_leadsData;
    
    CoreDataStore *_dataStore;
    NSIndexPath *_selectedIndexPath;
    
    UILabel *_noResultsLabel;
}
@end

@implementation LeadsViewController

@synthesize shouldOpenNewestLead = _shouldOpenNewestLead;

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
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 618.0f, self.view.height) style:UITableViewStylePlain];
    [_menuTableView setBackgroundColor:[UIColor clearColor]];
    [_menuTableView setSeparatorColor:[UIColor clearColor]];
    [_menuTableView setDataSource:self];
    [_menuTableView setDelegate:self];
    [self.view addSubview:_menuTableView];
    
    [MessageCenter addGlobalMessageListener:MESSAGE_LEADS_UPDATED target:self action:SEL(updateLocalData)];
    
    _noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 25.0f, (self.view.width - 50.0f), (self.view.height - 50.0f))];
    [_noResultsLabel setBackgroundColor:[UIColor clearColor]];
    [_noResultsLabel setTextColor:[UIColor colorWithHexString:@"FFFFFF1A"]];
    [_noResultsLabel setTextAlignment:UITextAlignmentCenter];
    [_noResultsLabel setNumberOfLines:2];
    [_noResultsLabel setShadowColor:[UIColor blackColor]];
    [_noResultsLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [_noResultsLabel setText:@"No Leads\nAvailable"];
    [_noResultsLabel setFont:[UIFont boldSystemFontOfSize:60.0f]];
    [_noResultsLabel setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    _shouldOpenNewestLead = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).leadsStackController setLargeLeftInset:(self.view.width - 400.0f) animated:YES];
    
    [self updateLocalData];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_menuTableView setFrame:CGRectMake(0.0f, 0.0f, 618.0f, self.view.height)];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).leadsStackController setLargeLeftInset:(self.view.width - 400.0f) animated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leadsData count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImage *backgroundImage = [UIImage imageWithIdentifier:@"Leads Cell Background" forSize:CGSizeMake(618.0f, 120.0f) andDrawingBlock:^{
            //// General Declarations
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Color Declarations
            UIColor* glassShine = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
            UIColor* glass25 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.25];
            
            //// Gradient Declarations
            NSArray* gradient2Colors = [NSArray arrayWithObjects: 
                                        (id)glassShine.CGColor, 
                                        (id)glass25.CGColor, nil];
            CGFloat gradient2Locations[] = {0, 1};
            CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
            
            //// Shadow Declarations
            CGColorRef shadow = [UIColor blackColor].CGColor;
            CGSize shadowOffset = CGSizeMake(0, 2);
            CGFloat shadowBlurRadius = 5;
            
            
            //// Cell Body Drawing
            UIBezierPath* cellBodyPath = [UIBezierPath bezierPathWithRect: CGRectMake(6, 36, 606, 78)];
            CGContextSaveGState(context);
            [cellBodyPath addClip];
            CGContextDrawLinearGradient(context, gradient2, CGPointMake(309, 36), CGPointMake(309, 114), 0);
            CGContextRestoreGState(context);
            
            [[UIColor blackColor] setStroke];
            cellBodyPath.lineWidth = 1.5;
            [cellBodyPath stroke];
            
            
            //// Cell Header Drawing
            UIBezierPath* cellHeaderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(6, 6, 606, 30) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
            CGContextSaveGState(context);
            [cellHeaderPath addClip];
            CGContextDrawLinearGradient(context, gradient2, CGPointMake(309, 6), CGPointMake(309, 36), 0);
            CGContextRestoreGState(context);
            
            [[UIColor blackColor] setStroke];
            cellHeaderPath.lineWidth = 1.5;
            [cellHeaderPath stroke];
            
            
            //// Divider Drawing
            UIBezierPath* dividerPath = [UIBezierPath bezierPathWithRect: CGRectMake(7.5, 35.5, 605, 1)];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
            [[UIColor blackColor] setFill];
            [dividerPath fill];
            CGContextRestoreGState(context);
            
            [[UIColor blackColor] setStroke];
            dividerPath.lineWidth = 1;
            [dividerPath stroke];
            
            //// Cleanup
            CGGradientRelease(gradient2);
            CGColorSpaceRelease(colorSpace);
        }];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [cell insertSubview:backgroundImageView atIndex:0];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 6.0f, 598.0f, 30.0f)];
        [headerLabel setTag:100];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextAlignment:UITextAlignmentLeft];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setFont:[UIFont boldSystemFontOfSize:22.0f]];
        [headerLabel setShadowColor:[UIColor blackColor]];
        [headerLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:headerLabel];
        
        UILabel *headerLabelRight = [[UILabel alloc] initWithFrame:headerLabel.frame];
        [headerLabelRight setTag:101];
        [headerLabelRight setBackgroundColor:[UIColor clearColor]];
        [headerLabelRight setTextAlignment:UITextAlignmentRight];
        [headerLabelRight setTextColor:[UIColor whiteColor]];
        [headerLabelRight setFont:[UIFont boldSystemFontOfSize:22.0f]];
        [headerLabelRight setShadowColor:[UIColor blackColor]];
        [headerLabelRight setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:headerLabelRight];
        
        UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 36.0f, 360.0f, 26.0f)];
        [companyLabel setTag:110];
        [companyLabel setBackgroundColor:[UIColor clearColor]];
        [companyLabel setTextAlignment:UITextAlignmentLeft];
        [companyLabel setTextColor:[UIColor whiteColor]];
        [companyLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [companyLabel setShadowColor:[UIColor blackColor]];
        [companyLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:companyLabel];
        
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(companyLabel.frame, 0.0f)];
        [emailLabel setTag:111];
        [emailLabel setBackgroundColor:[UIColor clearColor]];
        [emailLabel setTextAlignment:UITextAlignmentLeft];
        [emailLabel setTextColor:[UIColor whiteColor]];
        [emailLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [emailLabel setShadowColor:[UIColor blackColor]];
        [emailLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:emailLabel];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(emailLabel.frame, 0.0f)];
        [phoneLabel setTag:112];
        [phoneLabel setBackgroundColor:[UIColor clearColor]];
        [phoneLabel setTextAlignment:UITextAlignmentLeft];
        [phoneLabel setTextColor:[UIColor whiteColor]];
        [phoneLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [phoneLabel setShadowColor:[UIColor blackColor]];
        [phoneLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:phoneLabel];
        
        UILabel *revenueLabel = [[UILabel alloc] initWithFrame:CGRectMake(372.0f, 37.0f, 240.0f, 68.0f)];
        [revenueLabel setTag:115];
        [revenueLabel setBackgroundColor:[UIColor clearColor]];
        [revenueLabel setTextAlignment:UITextAlignmentCenter];
        [revenueLabel setTextColor:[UIColor whiteColor]];
        [revenueLabel setFont:[UIFont boldSystemFontOfSize:40.0f]];
        [revenueLabel setShadowColor:[UIColor blackColor]];
        [revenueLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:revenueLabel];
        
        UILabel *revenueText = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(revenueLabel.frame, -12.0f)];
        [revenueText setHeight:16.0f];
        [revenueText setBackgroundColor:[UIColor clearColor]];
        [revenueText setText:@"ANNUAL REVENUE"];
        [revenueText setTextAlignment:UITextAlignmentCenter];
        [revenueText setTextColor:[UIColor lightTextColor]];
        [revenueText setFont:[UIFont systemFontOfSize:12.0f]];
        [revenueText setShadowColor:[UIColor darkGrayColor]];
        [revenueText setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:revenueText];
        
        
        UIImage *mapOverlay = [UIImage imageWithIdentifier:@"Lead Cell Map Overlay" forSize:CGSizeMake(240.0f, 78.0f) andDrawingBlock:^{
            //// General Declarations
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Shadow Declarations
            CGColorRef shadow = [UIColor blackColor].CGColor;
            CGSize shadowOffset = CGSizeMake(0, -0);
            CGFloat shadowBlurRadius = 5;
            
            
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 240, 78)];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
            [[UIColor blackColor] setStroke];
            rectanglePath.lineWidth = 2;
            [rectanglePath stroke];
            CGContextRestoreGState(context);
        }];
        
        UIImageView *mapOverlayView = [[UIImageView alloc] initWithImage:mapOverlay];
        [mapOverlayView setLeft:372.0f];
        [mapOverlayView setTop:36.0f];
        [cell addSubview:mapOverlayView];
    }
    
    UILabel *headerLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *headerLabelRight = (UILabel *)[cell viewWithTag:101];
    UILabel *companyLabel = (UILabel *)[cell viewWithTag:110];
    UILabel *emailLabel = (UILabel *)[cell viewWithTag:111];
    UILabel *phoneLabel = (UILabel *)[cell viewWithTag:112];
    UILabel *revenueLabel = (UILabel *)[cell viewWithTag:115];
    
    if ([_selectedIndexPath isEqual:indexPath]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    Lead *lead = [_leadsData objectAtIndex:indexPath.row];
    [headerLabel setText:lead.name];
    [headerLabelRight setText:lead.leadStatus];
    [companyLabel setText:(lead.company != nil ? lead.company : @"")];
    [emailLabel setText:(lead.email != nil ? lead.email : @"")];
    [phoneLabel setText:[NSString stringWithFormat:@"Phone: %@", (lead.phone != nil ? lead.phone : @"Unknown")]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];
    [revenueLabel setText:[numberFormatter stringFromNumber:lead.annualRevenue]];
    
    UIImage *cellBackgroundImage = [UIImage imageForSize:CGSizeMake(618.0f, 120.0f) withDrawingBlock:^{
        //// Rounded Rectangle Drawing  
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(6, 36, 606, 78)];
        
        UIColor *fillColor = [UIColor colorWithHexString:@"FFFFFF40"];
        
        if ([lead.leadStatus contains:@"Open"]) {
            fillColor = [UIColor colorWithHexString:@"FF808040"];
        }
        else if ([lead.leadStatus contains:@"Working"]) {
            fillColor = [UIColor colorWithHexString:@"80FF8A40"];
        }
        else if ([lead.leadStatus contains:@"Not Converted"]) {
            fillColor = [UIColor colorWithHexString:@"FFFFFF40"];
        }
        else if ([lead.leadStatus contains:@"Converted"]) {
            fillColor = [UIColor colorWithHexString:@"808AFF40"];
        }
        [fillColor setFill];
        [roundedRectanglePath fill];
    }];
    
    UIImageView *cellBackground = [[UIImageView alloc] initWithImage:cellBackgroundImage];
    
    UIView *cellBackgroundColor = (UIView *)[cell viewWithTag:90];
    [cellBackgroundColor removeFromSuperview];
    cellBackgroundColor = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 618.0f, 120.0f)];
    [cellBackgroundColor addSubview:cellBackground];
    [cell insertSubview:cellBackgroundColor atIndex:0];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self processRowSelectionAtIndexPath:indexPath];
}

- (void)processRowSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    LeadDetailsViewController *detailsViewController = [[LeadDetailsViewController alloc] init];
    [detailsViewController setLeadId:((Lead *)[_leadsData objectAtIndex:indexPath.row]).objectID];
    
    UINavigationController *detailsNavigationController = [[UINavigationController alloc] initWithRootViewController:detailsViewController];
    [detailsNavigationController.view setWidth:400.0f];
    [detailsNavigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:SEL(closeDetailView)];
    [detailsViewController.navigationItem setLeftBarButtonItem:closeButton];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).leadsStackController pushViewController:detailsNavigationController fromViewController:self animated:YES];
}

#pragma mark - Actions

- (void)closeDetailView
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).leadsStackController popViewControllerAnimated:YES];
    
    [_menuTableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];
    _selectedIndexPath = nil;
}

- (void)updateLocalData
{
    _dataStore = [CoreDataStore createStore];
    _leadsData = [Lead allForPredicate:[NSPredicate predicateWithFormat:@"leadStatus != %@", @"Closed - Converted"] orderBy:@"createdDate" ascending:NO inStore:_dataStore];
    [_menuTableView reloadData];
    
    [_noResultsLabel removeFromSuperview];
    if ([_leadsData count] == 0) {
        [_noResultsLabel setFrame:CGRectMake(25.0f, 25.0f, (self.view.width - 50.0f), (self.view.height - 50.0f))];
        [self.view addSubview:_noResultsLabel];
    }
    
    if (_shouldOpenNewestLead) {
        _shouldOpenNewestLead = NO;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:SEL(selectTableViewRow) userInfo:nil repeats:NO];
    }
}

- (void)selectTableViewRow
{
    [_menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self processRowSelectionAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - Map View Delegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"geoLatitude == %f && geoLongitude == %f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude]];
    NSArray *leadsArray = [Lead allForPredicate:predicate inStore:_dataStore];
    
    UIGraphicsBeginImageContextWithOptions(mapView.frame.size, YES, 0.0);
    [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    for (Lead *lead in leadsArray) {
        [lead setMapImage:UIImagePNGRepresentation(mapImage)];
    }
    
    [_dataStore save];
    
    _leadsData = [Lead allForPredicate:nil orderBy:@"name" ascending:YES inStore:_dataStore];
}

@end
