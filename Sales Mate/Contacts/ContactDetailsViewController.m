//
//  ContactDetailsViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/16/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "AccountDetailsViewController.h"

#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

#import "Contact.h"
#import "Address.h"
#import "SalesAccount.h"

@interface ContactDetailsViewController ()
{
    CoreDataStore *_dataStore;
    
    Contact *_contact;
    
    UITableView *_contactTableView;
}

@end

@implementation ContactDetailsViewController

@synthesize contactId = _contactId;

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
    _contact = (Contact *)[_dataStore entityByObjectID:_contactId];

    [self setTitle:_contact.name];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"strange_bullseyes.png"]]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self
                                                                                 action:SEL(dismissModalViewControllerAnimated:)];
    [self.navigationItem setRightBarButtonItem:closeButton];
    
    UIImage *backgroundImage = [UIImage imageWithIdentifier:@"Contact Details Background" forSize:CGSizeMake(540.0f, 576.0f) andDrawingBlock:^{
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
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10, 312, 520, 254) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, mapDropShadowOffset, mapDropShadowBlurRadius, mapDropShadow);
        [descriptionBackdrop setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
    }];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:backgroundImageView];
    
    //Map View
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(256.0f, 16.0f, 268.0f, 268.0f)];
    [mapView setMapType:MKMapTypeStandard];
    [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(UNBOX_DOUBLE(_contact.geoLatitude), UNBOX_DOUBLE(_contact.geoLongitude)), MKCoordinateSpanMake(0.1f, 0.1f))];
    [self.view addSubview:mapView];
    
    if (UNBOX_DOUBLE(_contact.geoLatitude) != 0 && UNBOX_DOUBLE(_contact.geoLongitude) != 0) {
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        [pointAnnotation setCoordinate:mapView.region.center];
        [mapView addAnnotation:pointAnnotation];
    }
    
    _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(-50.0f, 0.0f, 290.0f, 300.0f) style:UITableViewStylePlain];
    [_contactTableView setDelegate:self];
    [_contactTableView setDataSource:self];
    [_contactTableView setBackgroundView:nil];
    [_contactTableView setBackgroundColor:[UIColor clearColor]];
    [_contactTableView setSeparatorColor:[UIColor clearColor]];
    [_contactTableView setScrollEnabled:NO];
    [self.view addSubview:_contactTableView];
    
    //Description
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(12.0f, 313.0f, 516.0f, 252.0f)];
    [descriptionView setBackgroundColor:[UIColor clearColor]];
    [descriptionView setText:_contact.descriptionText];
    [descriptionView setEditable:NO];
    [self.view addSubview:descriptionView];
    
    // Email
    IBButton *emailButton = [IBButton softButtonWithTitle:@"Send Email" color:[UIColor colorWithHexString:@"458040"]];
    [emailButton setFrame:CGRectMake(10.0f, 263.0f, 220.0f, 37.0f)];
    [emailButton addTarget:self
                    action:SEL(showMailCompose)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailButton];
    if (_contact.email == nil || ![MFMailComposeViewController canSendMail]) {
        [emailButton setEnabled:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return 7;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.detailTextLabel setNumberOfLines:2];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            [cell.textLabel setText:@"Role"];
            [cell.detailTextLabel setText:(_contact.role != nil ? _contact.title : @"Unknown")];
            break;
        }
        case 1:
        {
            [cell.textLabel setText:@"Title"];
            [cell.detailTextLabel setText:(_contact.title != nil ? _contact.title : @"Unknown")];
            break;
        }
        case 2:
        {
            [cell.textLabel setText:@"Account"];
            [cell.detailTextLabel setText:(_contact.account != nil ? ((SalesAccount *)_contact.account).name : @"Unknown")];
            if (_contact.account != nil) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            break;
        }
        case 3:
        {
            [cell.textLabel setText:@"Phone"];
            [cell.detailTextLabel setText:(_contact.phone != nil ? _contact.phone : @"Unknown")];
            break;
        }
        case 4:
        {
            [cell.textLabel setText:@"Home"];
            [cell.detailTextLabel setText:(_contact.homePhone != nil ? _contact.homePhone : @"Unknown")];
            break;
        }
        case 5:
        {
            [cell.textLabel setText:@"Mobile"];
            [cell.detailTextLabel setText:(_contact.mobilePhone != nil ? _contact.mobilePhone : @"Unknown")];
        }
        case 6:
        {
            [cell.textLabel setText:@"Fax"];
            [cell.detailTextLabel setText:(_contact.fax != nil ? _contact.fax : @"Unknown")];
            break;
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        AccountDetailsViewController *accountDetailsView = [[AccountDetailsViewController alloc] init];
        [accountDetailsView setAccountId:_contact.account.objectID];
        
        [self.navigationController pushViewController:accountDetailsView animated:YES];
    }
}

#pragma mark - Actions

- (void)showMailCompose
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
    [mailController setToRecipients:[NSArray arrayWithObject:_contact.email]];
    [mailController setMailComposeDelegate:self];
    [self presentModalViewController:mailController animated:YES];
}

#pragma mark - Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            [IBAlertView showAlertWithTitle:@"Compose Email" 
                                    message:@"Sending Failed – Unknown Error" 
                               dismissTitle:@"Okay"
                               dismissBlock:nil];
            break;
        }
    }
    
    [controller dismissModalViewControllerAnimated:YES];
}

@end
