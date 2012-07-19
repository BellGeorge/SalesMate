//
//  OpportunityDetailsViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/2/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "OpportunityDetailsViewController.h"
#import "ContactDetailsViewController.h"
#import "AccountDetailsViewController.h"

#import "Contact.h"
#import "SalesAccount.h"
#import "Opportunity.h"

@interface OpportunityDetailsViewController ()
{
    UITableView *_contactsTableView;
    
    Opportunity *_opportunity;
    NSArray *_contacts;
    
    CoreDataStore *_dataStore;
    
    XYPieChart *_probabilityChart;
}
@end

@implementation OpportunityDetailsViewController

@synthesize opportunityId = _opportunityId;

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
    _opportunity = (Opportunity *)[_dataStore entityByObjectID:_opportunityId];
    _contacts = [_opportunity.contacts allObjects];
	
    [self setTitle:@"Opportunity Details"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"px_by_Gre3g.png"]]];
    [self.view setWidth:400.0f];
    
    UIImage *headerImage = [UIImage imageWithIdentifier:@"Opportunity Header" forSize:CGSizeMake(400.0f, 250.0f) andDrawingBlock:^{
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* color = [UIColor colorWithRed: 0.39 green: 0.56 blue: 0.81 alpha: 0.5];
        UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        UIColor* color3 = [UIColor colorWithRed: 0.92 green: 0.92 blue: 1 alpha: 0.8];
        UIColor* color4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.7];
        
        //// Gradient Declarations
        NSArray* gradient2Colors = [NSArray arrayWithObjects: 
                                    (id)color.CGColor, 
                                    (id)color2.CGColor, nil];
        CGFloat gradient2Locations[] = {0, 1};
        CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
        
        //// Shadow Declarations
        CGColorRef shadow = [UIColor blackColor].CGColor;
        CGSize shadowOffset = CGSizeMake(1, 2);
        CGFloat shadowBlurRadius = 5;
        
        
        //// Rounded Rectangle 3 Drawing
        UIBezierPath* roundedRectangle3Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(30, 194, 340, 50) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [color4 setFill];
        [roundedRectangle3Path fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectangle3Path.lineWidth = 2;
        [roundedRectangle3Path stroke];
        
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 60, 380, 134)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [color3 setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
        
        
        //// Rounded Rectangle 2 Drawing
        UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10, 10, 380, 50) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        [roundedRectangle2Path addClip];
        CGContextDrawLinearGradient(context, gradient2, CGPointMake(200, 10), CGPointMake(200, 60), 0);
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectangle2Path.lineWidth = 2;
        [roundedRectangle2Path stroke];
        
        //// Cleanup
        CGGradientRelease(gradient2);
        CGColorSpaceRelease(colorSpace);
    }];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    [self.view addSubview:headerImageView];
    
    UILabel *opportunityName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 380.0f, 50.0f)];
    [opportunityName setBackgroundColor:[UIColor clearColor]];
    [opportunityName setShadowColor:[UIColor blackColor]];
    [opportunityName setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [opportunityName setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [opportunityName setTextAlignment:UITextAlignmentCenter];
    [opportunityName setTextColor:[UIColor whiteColor]];
    [opportunityName setText:_opportunity.name];
    [opportunityName setNumberOfLines:2];
    [headerImageView addSubview:opportunityName];
    
    _probabilityChart = [[XYPieChart alloc] initWithFrame:CGRectMake(10.0f, 60.0f, 134.0f, 134.0f)];
    [_probabilityChart setDelegate:self];
    [_probabilityChart setDataSource:self];
    [_probabilityChart setPieRadius:60.0f];
    [_probabilityChart setPieCenter:CGPointMake(67.0f, 67.0f)];
    [_probabilityChart setShowLabel:NO];
    [_probabilityChart setAnimationSpeed:2.0f];
    [_probabilityChart setPieBackgroundColor:[UIColor clearColor]];
    [_probabilityChart setUserInteractionEnabled:NO];
    [headerImageView addSubview:_probabilityChart];
    [_probabilityChart reloadData];
    
    UILabel *probabilityLabel = [[UILabel alloc] initWithFrame:RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(_probabilityChart.frame, 27.0f, 27.0f, 27.0f, 27.0f)];
    [probabilityLabel.layer setCornerRadius:40.0f];
    [probabilityLabel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [probabilityLabel.layer setBorderWidth:1.0f];
    [probabilityLabel setTextAlignment:UITextAlignmentCenter];
    [probabilityLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [probabilityLabel setText:[NSString stringWithFormat:@"%i%%", UNBOX_INT(_opportunity.probability)]];
    [headerImageView addSubview:probabilityLabel];
    
    UILabel *probabilityText = [[UILabel alloc] initWithFrame:RECT_INSET_BY_TOP_BOTTOM(probabilityLabel.frame, 52.0f, 18.0f)];
    [probabilityText setBackgroundColor:[UIColor clearColor]];
    [probabilityText setTextColor:[UIColor lightGrayColor]];
    [probabilityText setFont:[UIFont systemFontOfSize:8.0f]];
    [probabilityText setTextAlignment:UITextAlignmentCenter];
    [probabilityText setText:@"PROBABILITY"];
    [headerImageView addSubview:probabilityText];
    
    UILabel *stageLabel = [[UILabel alloc] initWithFrame:CGRectMake(134.0f, 60.0f, 246.0f, 40.0f)];
    [stageLabel setBackgroundColor:[UIColor clearColor]];
    [stageLabel setShadowColor:[UIColor darkGrayColor]];
    [stageLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [stageLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
    [stageLabel setTextColor:[UIColor whiteColor]];
    [stageLabel setTextAlignment:UITextAlignmentCenter];
    [stageLabel setText:[_opportunity.stage uppercaseString]];
    [headerImageView addSubview:stageLabel];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(stageLabel.frame, 0.0f)];
    [amountLabel setHeight:30.0f];
    [amountLabel setBackgroundColor:[UIColor clearColor]];
    [amountLabel setShadowColor:[UIColor lightGrayColor]];
    [amountLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [amountLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [amountLabel setTextAlignment:UITextAlignmentCenter];
    [amountLabel setText:[numberFormatter stringFromNumber:_opportunity.amount]];
    [headerImageView addSubview:amountLabel];

    UILabel *amountText = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(amountLabel.frame, -10.0f)];
    [amountText setBackgroundColor:[UIColor clearColor]];
    [amountText setShadowColor:[UIColor darkGrayColor]];
    [amountText setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [amountText setFont:[UIFont systemFontOfSize:10.0f]];
    [amountText setTextAlignment:UITextAlignmentCenter];
    [amountText setTextColor:[UIColor whiteColor]];
    [amountText setText:@"AMOUNT"];
    [headerImageView addSubview:amountText];
    
    UILabel *revenueLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(amountLabel.frame, 15.0f)];
    [revenueLabel setBackgroundColor:[UIColor clearColor]];
    [revenueLabel setShadowColor:[UIColor lightGrayColor]];
    [revenueLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [revenueLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [revenueLabel setTextAlignment:UITextAlignmentCenter];
    [revenueLabel setText:[numberFormatter stringFromNumber:_opportunity.expectedRevenue]];
    [headerImageView addSubview:revenueLabel];
    
    UILabel *revenueText = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(revenueLabel.frame, -10.0f)];
    [revenueText setBackgroundColor:[UIColor clearColor]];
    [revenueText setShadowColor:[UIColor darkGrayColor]];
    [revenueText setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [revenueText setFont:[UIFont systemFontOfSize:10.0f]];
    [revenueText setTextAlignment:UITextAlignmentCenter];
    [revenueText setTextColor:[UIColor whiteColor]];
    [revenueText setText:@"EXPECTED REVENUE"];
    [headerImageView addSubview:revenueText];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34.0f, 196.0f, 332.0f, 23.0f)];
    [typeLabel setBackgroundColor:[UIColor clearColor]];
    [typeLabel setText:[NSString stringWithFormat:@"Type: %@", (_opportunity.type != nil ? _opportunity.type : @"Unknown")]];
    [headerImageView addSubview:typeLabel];
    
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(typeLabel.frame, 0.0f)];
    [sourceLabel setBackgroundColor:[UIColor clearColor]];
    [sourceLabel setText:[NSString stringWithFormat:@"Source: %@", _opportunity.leadSource]];
    [headerImageView addSubview:sourceLabel];
    
    UIImage *accountInfo = [UIImage imageWithIdentifier:@"Opportunity Account Info" forSize:CGSizeMake(400.0f, 60.0f) andDrawingBlock:^{
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* color = [UIColor colorWithRed: 0.39 green: 0.56 blue: 0.81 alpha: 0.5];
        UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        
        //// Gradient Declarations
        NSArray* gradient2Colors = [NSArray arrayWithObjects: 
                                    (id)color.CGColor, 
                                    (id)color2.CGColor, nil];
        CGFloat gradient2Locations[] = {0, 1};
        CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
        
        //// Shadow Declarations
        CGColorRef shadow = [UIColor blackColor].CGColor;
        CGSize shadowOffset = CGSizeMake(3, 3);
        CGFloat shadowBlurRadius = 5;
        
        
        //// Rounded Rectangle 2 Drawing
        UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10, 10, 380, 41) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        CGContextSetFillColorWithColor(context, shadow);
        [roundedRectangle2Path fill];
        [roundedRectangle2Path addClip];
        CGContextDrawLinearGradient(context, gradient2, CGPointMake(200, 10), CGPointMake(200, 51), 0);
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectangle2Path.lineWidth = 2;
        [roundedRectangle2Path stroke];
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(370.13, 23)];
        [bezierPath addLineToPoint: CGPointMake(381.5, 30.13)];
        [bezierPath addLineToPoint: CGPointMake(370.13, 37.26)];
        [bezierPath addLineToPoint: CGPointMake(369.5, 38.26)];
        [bezierPath addLineToPoint: CGPointMake(369.5, 22)];
        [bezierPath addLineToPoint: CGPointMake(370.13, 23)];
        [bezierPath closePath];
        [[UIColor whiteColor] setFill];
        [bezierPath fill];
        
        [[UIColor blackColor] setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        //// Cleanup
        CGGradientRelease(gradient2);
        CGColorSpaceRelease(colorSpace);
    }];
    
    // Account Info
    UIImageView *accountInfoView = [[UIImageView alloc] initWithImage:accountInfo];
    [accountInfoView setTop:250.0f];
    
    // Opportunity Contacts
    _contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(15.0f, (accountInfoView.bottom - 8.0f), 370.0f, (self.view.height - accountInfoView.bottom + 8.0f)) style:UITableViewStylePlain];
    [_contactsTableView setDelegate:self];
    [_contactsTableView setDataSource:self];
    [_contactsTableView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight)];
    [_contactsTableView setBackgroundView:nil];
    [_contactsTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_contactsTableView];
    
    [self.view addSubview:accountInfoView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 345.0f, 41.0f)];
    [accountLabel setBackgroundColor:[UIColor clearColor]];
    [accountLabel setTextColor:[UIColor whiteColor]];
    [accountLabel setText:((SalesAccount *)_opportunity.account).name];
    [accountInfoView addSubview:accountLabel];
    
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountButton setFrame:accountInfoView.frame];
    [accountButton addTarget:self
                      action:SEL(showAccountDetails)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountButton];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Contacts";
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    Contact *contact = [_contacts objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:contact.name];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactDetailsViewController *detailsViewController = [[ContactDetailsViewController alloc] init];
    [detailsViewController setContactId:((Contact *)[_contacts objectAtIndex:indexPath.row]).objectID];
      
    UINavigationController *detailsNavigationController = [[UINavigationController alloc] initWithRootViewController:detailsViewController];
    [detailsNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:detailsNavigationController animated:YES];
    [_contactsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 3;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            return UNBOX_INT(_opportunity.probability);
        case 1:
            return (100 - UNBOX_INT(_opportunity.probability));
    }
    return 0;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            return [UIColor colorWithHexString:@"00B300"];
        case 1:
            return [UIColor colorWithHexString:@"B30000"];
    }
    return nil;
}

#pragma mark - Actions

- (void)showAccountDetails
{
    AccountDetailsViewController *detailsViewController = [[AccountDetailsViewController alloc] init];
    [detailsViewController setAccountId:((SalesAccount *)_opportunity.account).objectID];
    
    UINavigationController *detailsNavigationController = [[UINavigationController alloc] initWithRootViewController:detailsViewController];
    [detailsNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:detailsNavigationController animated:YES];
}

@end
