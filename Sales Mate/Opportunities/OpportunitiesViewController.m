//
//  OpportunitiesViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/1/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "OpportunityDetailsViewController.h"

#import "Opportunity.h"

@interface OpportunitiesViewController ()
{
    UITableView *_menuTableView;
    NSArray *_opportunitiesData;
    
    CoreDataStore *_dataStore;
    NSIndexPath *_selectedIndexPath;
    
    UILabel *_noResultsLabel;
}

@end

@implementation OpportunitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    [MessageCenter addGlobalMessageListener:MESSAGE_OPPORTUNITIES_UPDATED target:self action:SEL(updateLocalData)];
    
    _noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 25.0f, (self.view.width - 50.0f), (self.view.height - 50.0f))];
    [_noResultsLabel setBackgroundColor:[UIColor clearColor]];
    [_noResultsLabel setTextColor:[UIColor colorWithHexString:@"FFFFFF1A"]];
    [_noResultsLabel setTextAlignment:UITextAlignmentCenter];
    [_noResultsLabel setNumberOfLines:2];
    [_noResultsLabel setShadowColor:[UIColor blackColor]];
    [_noResultsLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [_noResultsLabel setText:@"No Opportunties\nAvailable"];
    [_noResultsLabel setFont:[UIFont boldSystemFontOfSize:60.0f]];
    [_noResultsLabel setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).opportunitiesStackController setLargeLeftInset:(self.view.width - 400.0f) animated:YES];
    
    [self updateLocalData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [MessageCenter removeMessageListenersForTarget:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_menuTableView setFrame:CGRectMake(0.0f, 0.0f, 618.0f, self.view.height)];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).opportunitiesStackController setLargeLeftInset:(self.view.width - 400.0f) animated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_opportunitiesData count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImage *backgroundImage = [UIImage imageWithIdentifier:@"Cell Background" forSize:CGSizeMake(618.0f, 100.0f) andDrawingBlock:^{
            //// General Declarations
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Color Declarations
            UIColor* glass25 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.25];
            UIColor* glassShine = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
            
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
            UIBezierPath* cellBodyPath = [UIBezierPath bezierPathWithRect: CGRectMake(6, 36, 606, 59)];
            CGContextSaveGState(context);
            [cellBodyPath addClip];
            CGContextDrawLinearGradient(context, gradient2, CGPointMake(309, 36), CGPointMake(309, 95), 0);
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
            UIBezierPath* dividerPath = [UIBezierPath bezierPathWithRect: CGRectMake(7, 35.5, 605, 1)];
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
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 6.0f, 606.0f, 30.0f)];
        [headerLabel setTag:100];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextAlignment:UITextAlignmentCenter];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setFont:[UIFont boldSystemFontOfSize:22.0f]];
        [headerLabel setShadowColor:[UIColor blackColor]];
        [headerLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:headerLabel];
        
        UILabel *probabilityText = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 76.0f, 110.0f, 16.0f)];
        [probabilityText setBackgroundColor:[UIColor clearColor]];
        [probabilityText setText:@"PROBABILITY"];
        [probabilityText setTextAlignment:UITextAlignmentCenter];
        [probabilityText setTextColor:[UIColor lightTextColor]];
        [probabilityText setFont:[UIFont systemFontOfSize:12.0f]];
        [probabilityText setShadowColor:[UIColor darkGrayColor]];
        [probabilityText setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:probabilityText];
        
        UILabel *probabilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 38.0f, 110.0f, 46.0f)];
        [probabilityLabel setTag:110];
        [probabilityLabel setBackgroundColor:[UIColor clearColor]];
        [probabilityLabel setTextAlignment:UITextAlignmentCenter];
        [probabilityLabel setTextColor:[UIColor whiteColor]];
        [probabilityLabel setFont:[UIFont boldSystemFontOfSize:40.0f]];
        [probabilityLabel setShadowColor:[UIColor blackColor]];
        [probabilityLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:probabilityLabel];
        
        UILabel *closeDateText = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_X(probabilityText.frame, 10.0f)];
        [closeDateText setWidth:238.0f];
        [closeDateText setBackgroundColor:[UIColor clearColor]];
        [closeDateText setText:@"CLOSE DATE"];
        [closeDateText setTextAlignment:UITextAlignmentCenter];
        [closeDateText setTextColor:[UIColor lightTextColor]];
        [closeDateText setFont:[UIFont systemFontOfSize:12.0f]];
        [closeDateText setShadowColor:[UIColor darkGrayColor]];
        [closeDateText setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:closeDateText];
        
        UILabel *closeDateLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_X(probabilityLabel.frame, 10.0f)];
        [closeDateLabel setWidth:238.0f];
        [closeDateLabel setTag:120];
        [closeDateLabel setBackgroundColor:[UIColor clearColor]];
        [closeDateLabel setTextAlignment:UITextAlignmentCenter];
        [closeDateLabel setTextColor:[UIColor whiteColor]];
        [closeDateLabel setFont:[UIFont boldSystemFontOfSize:40.0f]];
        [closeDateLabel setShadowColor:[UIColor blackColor]];
        [closeDateLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:closeDateLabel];
        
        UILabel *amountText = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_X(closeDateText.frame, 10.0f)];
        [amountText setBackgroundColor:[UIColor clearColor]];
        [amountText setText:@"AMOUNT"];
        [amountText setTextAlignment:UITextAlignmentCenter];
        [amountText setTextColor:[UIColor lightTextColor]];
        [amountText setFont:[UIFont systemFontOfSize:12.0f]];
        [amountText setShadowColor:[UIColor darkGrayColor]];
        [amountText setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:amountText];
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_X(closeDateLabel.frame, 10.0f)];
        [amountLabel setTag:130];
        [amountLabel setBackgroundColor:[UIColor clearColor]];
        [amountLabel setTextAlignment:UITextAlignmentCenter];
        [amountLabel setTextColor:[UIColor whiteColor]];
        [amountLabel setFont:[UIFont boldSystemFontOfSize:40.0f]];
        [amountLabel setShadowColor:[UIColor blackColor]];
        [amountLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [cell addSubview:amountLabel];
    }
    
    UILabel *headerLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *probabilityLabel = (UILabel *)[cell viewWithTag:110];
    UILabel *closeDateLabel = (UILabel *)[cell viewWithTag:120];
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:130];
    
    if ([_selectedIndexPath isEqual:indexPath]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    Opportunity *opportunity = [_opportunitiesData objectAtIndex:indexPath.row];
    [headerLabel setText:opportunity.name];
    [probabilityLabel setText:[NSString stringWithFormat:@"%i%%", UNBOX_INT(opportunity.probability)]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [closeDateLabel setText:[dateFormatter stringFromDate:opportunity.closeDate]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];
    [amountLabel setText:[numberFormatter stringFromNumber:opportunity.amount]];
    
    UIImage *cellBackgroundImage = [UIImage imageForSize:CGSizeMake(618.0f, 100.0f) withDrawingBlock:^{
        //// Rounded Rectangle Drawing  
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(6, 36, 606, 59)];
        
        UIColor *fillColor = [UIColor colorWithHexString:@"FFFFFF40"];
        
        if (UNBOX_INT(opportunity.probability) < 25) {
            fillColor = [UIColor colorWithHexString:@"FF808040"];
        }
        else if (UNBOX_INT(opportunity.probability) < 50) {
            fillColor = [UIColor colorWithHexString:@"FFFF8040"];
        }
        else if (UNBOX_INT(opportunity.probability) < 75) {
            fillColor = [UIColor colorWithHexString:@"80FF8A40"];
        }
        else if (UNBOX_INT(opportunity.probability) > 75) {
            fillColor = [UIColor colorWithHexString:@"808AFF40"];
        }
        [fillColor setFill];
        [roundedRectanglePath fill];
    }];
    
    UIImageView *cellBackground = [[UIImageView alloc] initWithImage:cellBackgroundImage];
    
    UIView *cellBackgroundColor = (UIView *)[cell viewWithTag:90];
    [cellBackgroundColor removeFromSuperview];
    cellBackgroundColor = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 618.0f, 100.0f)];
    [cellBackgroundColor addSubview:cellBackground];
    [cell insertSubview:cellBackgroundColor atIndex:0];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    OpportunityDetailsViewController *detailsViewController = [[OpportunityDetailsViewController alloc] init];
    [detailsViewController setOpportunityId:((Opportunity *)[_opportunitiesData objectAtIndex:indexPath.row]).objectID];
    
    UINavigationController *detailsNavigationController = [[UINavigationController alloc] initWithRootViewController:detailsViewController];
    [detailsNavigationController.view setWidth:400.0f];
    [detailsNavigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:SEL(closeDetailView)];
    [detailsViewController.navigationItem setLeftBarButtonItem:closeButton];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).opportunitiesStackController pushViewController:detailsNavigationController fromViewController:self animated:YES];
}

#pragma mark - Actions

- (void)closeDetailView
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).opportunitiesStackController popViewControllerAnimated:YES];
    
    [_menuTableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];
    _selectedIndexPath = nil;
}

- (void)updateLocalData
{
    _dataStore = [CoreDataStore createStore];
    _opportunitiesData = [Opportunity allInStore:_dataStore];
    [_menuTableView reloadData];
    
    [_noResultsLabel removeFromSuperview];
    if ([_opportunitiesData count] == 0) {
        [_noResultsLabel setFrame:CGRectMake(25.0f, 25.0f, (self.view.width - 50.0f), (self.view.height - 50.0f))];
        [self.view addSubview:_noResultsLabel];
    }
}

@end
