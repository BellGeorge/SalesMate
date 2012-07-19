//
//  LeadDetailsViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/11/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "LeadDetailsViewController.h"
#import "TSMiniWebBrowser.h"
#import "AccountDetailsViewController.h"

#import "Address.h"
#import "Lead.h"

#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface LeadDetailsViewController ()
{
    Lead *_lead;
    CoreDataStore *_dataStore;
    
    MKMapView *_mapView;
    
    UITextView *_descriptionView;
    IBButton *_showDescriptionButton;
}

@end

@implementation LeadDetailsViewController

@synthesize leadId = _leadId;

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
    _lead = (Lead *)[_dataStore entityByObjectID:_leadId];
    
    [self setTitle:@"Lead Details"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"px_by_Gre3g.png"]]];
    [self.view setWidth:400.0f];
    
    UIImage *statusImage = [UIImage imageForSize:CGSizeMake(400.0f, 120.0f) withDrawingBlock:^{
        UIColor *fillColor = [UIColor colorWithHexString:@"FFFFFFBF"];
        if ([_lead.leadStatus contains:@"Open"]) {
            fillColor = [UIColor colorWithHexString:@"FF8080BF"];
        }
        else if ([_lead.leadStatus contains:@"Working"]) {
            fillColor = [UIColor colorWithHexString:@"80FF8ABF"];
        }
        else if ([_lead.leadStatus contains:@"Not Converted"]) {
            fillColor = [UIColor colorWithHexString:@"FFFFFFBF"];
        }
        else if ([_lead.leadStatus contains:@"Converted"]) {
            fillColor = [UIColor colorWithHexString:@"808AFFBF"];
        }
        [fillColor setFill];
        
        //// Status Drawing
        UIBezierPath* statusPath = [UIBezierPath bezierPath];
        [statusPath moveToPoint: CGPointMake(200, 103)];
        [statusPath addCurveToPoint: CGPointMake(204, 107) controlPoint1: CGPointMake(200, 105.21) controlPoint2: CGPointMake(201.79, 107)];
        [statusPath addLineToPoint: CGPointMake(356, 107)];
        [statusPath addCurveToPoint: CGPointMake(360, 103) controlPoint1: CGPointMake(358.21, 107) controlPoint2: CGPointMake(360, 105.21)];
        [statusPath addLineToPoint: CGPointMake(360, 86)];
        [statusPath addLineToPoint: CGPointMake(200, 86)];
        [statusPath addLineToPoint: CGPointMake(200, 103)];
        [statusPath closePath];
        [statusPath fill];
        
        //// Header Background Drawing
//        UIBezierPath* headerBackgroundPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(6, 6, 309, 30) byRoundingCorners: UIRectCornerTopLeft cornerRadii: CGSizeMake(4, 4)];
//        [headerBackgroundPath fill];
    }];
    
    UIImageView *statusImageView = [[UIImageView alloc] initWithImage:statusImage];
    [self.view addSubview:statusImageView];
    
    UIImage *headerImage = [UIImage imageWithIdentifier:@"Leads Details Header" forSize:CGSizeMake(400.0f, 120.0f) andDrawingBlock:^{
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* statusColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.25];
        UIColor* glassShine = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
        UIColor* accountBox = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.75];
        
        //// Gradient Declarations
        NSArray* gradient2Colors = [NSArray arrayWithObjects: 
                                    (id)glassShine.CGColor, 
                                    (id)statusColor.CGColor, nil];
        CGFloat gradient2Locations[] = {0, 1};
        CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
        
        //// Shadow Declarations
        CGColorRef imageShadow = [UIColor blackColor].CGColor;
        CGSize imageShadowOffset = CGSizeMake(2, 2);
        CGFloat imageShadowBlurRadius = 5;
        CGColorRef shadow = [UIColor blackColor].CGColor;
        CGSize shadowOffset = CGSizeMake(0, -0);
        CGFloat shadowBlurRadius = 20;
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(6, 36, 309, 50)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, imageShadowOffset, imageShadowBlurRadius, imageShadow);
        [accountBox setFill];
        [rectanglePath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        rectanglePath.lineWidth = 2;
        [rectanglePath stroke];
        
        
        //// Status Drawing
        UIBezierPath* statusPath = [UIBezierPath bezierPath];
        [statusPath moveToPoint: CGPointMake(200, 103)];
        [statusPath addCurveToPoint: CGPointMake(204, 107) controlPoint1: CGPointMake(200, 105.21) controlPoint2: CGPointMake(201.79, 107)];
        [statusPath addLineToPoint: CGPointMake(356, 107)];
        [statusPath addCurveToPoint: CGPointMake(360, 103) controlPoint1: CGPointMake(358.21, 107) controlPoint2: CGPointMake(360, 105.21)];
        [statusPath addLineToPoint: CGPointMake(360, 86)];
        [statusPath addLineToPoint: CGPointMake(200, 86)];
        [statusPath addLineToPoint: CGPointMake(200, 103)];
        [statusPath closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, imageShadowOffset, imageShadowBlurRadius, imageShadow);
        [statusColor setFill];
        [statusPath fill];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [[UIColor blackColor] setStroke];
        statusPath.lineWidth = 2;
        [statusPath stroke];
        CGContextRestoreGState(context);
        
        
        //// Header Background Drawing
        UIBezierPath* headerBackgroundPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(6, 6, 309, 30) byRoundingCorners: UIRectCornerTopLeft cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        [headerBackgroundPath addClip];
        CGContextDrawLinearGradient(context, gradient2, CGPointMake(160.5, 6), CGPointMake(160.5, 36), 0);
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        headerBackgroundPath.lineWidth = 2;
        [headerBackgroundPath stroke];
        
        
        //// Status Rectangle Drawing
        UIBezierPath* statusRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(315, 6, 80, 80) byRoundingCorners: UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, imageShadowOffset, imageShadowBlurRadius, imageShadow);
        [[UIColor blackColor] setFill];
        [statusRectanglePath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        statusRectanglePath.lineWidth = 2;
        [statusRectanglePath stroke];
        
        //// Cleanup
        CGGradientRelease(gradient2);
        CGColorSpaceRelease(colorSpace);
    }];
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:headerImage];
    [self.view addSubview:headerView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 6.0f, 305.0f, 30.0f)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setShadowColor:[UIColor blackColor]];
    [nameLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setText:_lead.name];
    [headerView addSubview:nameLabel];
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(nameLabel.frame, 0.0f)];
    [companyLabel setHeight:50.0f];
    [companyLabel setBackgroundColor:[UIColor clearColor]];
    [companyLabel setShadowColor:[UIColor whiteColor]];
    [companyLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [companyLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [companyLabel setNumberOfLines:2];
    [companyLabel setTextColor:[UIColor blackColor]];
    [companyLabel setText:_lead.company];
    [headerView addSubview:companyLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 86.0f, 160.0f, 21.0f)];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [statusLabel setShadowColor:[UIColor blackColor]];
    [statusLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [statusLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [statusLabel setTextAlignment:UITextAlignmentCenter];
    [statusLabel setTextColor:[UIColor whiteColor]];
    [statusLabel setText:_lead.leadStatus];
    [headerView addSubview:statusLabel];
    
    //Actions Area
    UIView *actionsView = [[UIView alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(headerView.frame, -28.0f)];
    [actionsView setBackgroundColor:[UIColor clearColor]];
    [actionsView setHeight:144.0f];
    [self.view addSubview:actionsView];
    
    UIImage *actionsBackgroundImage = [UIImage imageWithIdentifier:@"Leads Actions Background" forSize:CGSizeMake(400.0f, 100.0f) andDrawingBlock:^{
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* bodyColor = [UIColor colorWithRed: 1 green: 1 blue: 0.89 alpha: 0.7];
        
        //// Shadow Declarations
        CGColorRef shadow = [UIColor blackColor].CGColor;
        CGSize shadowOffset = CGSizeMake(3, 3);
        CGFloat shadowBlurRadius = 5;
        
        
        //// Rounded Rectangle 2 Drawing
        UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(13, 6, 159, 21) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [bodyColor setFill];
        [roundedRectangle2Path fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectangle2Path.lineWidth = 2;
        [roundedRectangle2Path stroke];
        
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(6, 27, 388, 66) cornerRadius: 4];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [bodyColor setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(9, 49)];
        [bezierPath addCurveToPoint: CGPointMake(391, 49) controlPoint1: CGPointMake(394.43, 49) controlPoint2: CGPointMake(391, 49)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [bodyColor setFill];
        [bezierPath fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(9, 71)];
        [bezier2Path addCurveToPoint: CGPointMake(391, 71) controlPoint1: CGPointMake(394.43, 71) controlPoint2: CGPointMake(391, 71)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [bodyColor setFill];
        [bezier2Path fill];
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        bezier2Path.lineWidth = 1;
        [bezier2Path stroke];
    }];
    
    UIImageView *actionBackground = [[UIImageView alloc] initWithImage:actionsBackgroundImage];
    [actionsView addSubview:actionBackground];
    
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 6.0f, 159.0f, 21.0f)];
    [sourceLabel setBackgroundColor:[UIColor clearColor]];
    [sourceLabel setTextAlignment:UITextAlignmentCenter];
    [sourceLabel setText:[NSString stringWithFormat:@"Source: %@", (_lead.leadSource != nil ? _lead.leadSource : @"Unknown")]];
    [actionsView addSubview:sourceLabel];
    
    UILabel *industryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 27.0f, 380.0f, 22.0f)];
    [industryLabel setBackgroundColor:[UIColor clearColor]];
    [industryLabel setText:[NSString stringWithFormat:@"Industry: %@", (_lead.industry != nil ? _lead.industry : @"Unknown")]];
    [actionsView addSubview:industryLabel];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(industryLabel.frame, 0.0f)];
    [mobileLabel setBackgroundColor:[UIColor clearColor]];
    [mobileLabel setText:[NSString stringWithFormat:@"Mobile: %@", (_lead.mobilePhone != nil ? _lead.mobilePhone : @"Unknown")]];
    [actionsView addSubview:mobileLabel];
    
    UILabel *faxLabel = [[UILabel alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(mobileLabel.frame, 0.0f)];
    [faxLabel setBackgroundColor:[UIColor clearColor]];
    [faxLabel setText:[NSString stringWithFormat:@"Fax: %@", (_lead.fax != nil ? _lead.fax : @"Unknown")]];
    [actionsView addSubview:faxLabel];
    
    IBButton *emailButton = [IBButton softButtonWithTitle:@"Send Email" color:[UIColor colorWithHexString:@"458040"]];
    [emailButton setFrame:CGRectMake(10.0f, (actionsView.height - 44.0f), 184.0f, 44.0f)];
    [emailButton addTarget:self
                    action:SEL(showMailCompose)
          forControlEvents:UIControlEventTouchUpInside];
    [actionsView addSubview:emailButton];
    if (_lead.email == nil || ![MFMailComposeViewController canSendMail]) {
        [emailButton setEnabled:NO];
    }
    
    IBButton *websiteButton = [IBButton softButtonWithTitle:@"View Website" color:[UIColor colorWithHexString:@"404080"]];
    [websiteButton setFrame:RECT_STACKED_OFFSET_BY_X(emailButton.frame, 12.0f)];
    [websiteButton addTarget:self
                      action:SEL(openWebsite) 
            forControlEvents:UIControlEventTouchUpInside];
    [actionsView addSubview:websiteButton];
    if (_lead.website == nil) {
        [websiteButton setEnabled:NO];
    }
    
    //Description Area
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:RECT_STACKED_OFFSET_BY_Y(actionsView.frame, 8.0f)];
    [descriptionView setHeight:(self.view.height - 650.0f)];
    [descriptionView setEditable:NO];
    [descriptionView setBackgroundColor:[UIColor colorWithHexString:@"FFFFFF80"]];
    [descriptionView setText:_lead.descriptionText];
    [descriptionView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:descriptionView];
    
    //Map View
    UIView *mapAreaView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 400.0f, 400.0f)];
    [mapAreaView setBottom:self.view.height];
    [mapAreaView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
    [self.view addSubview:mapAreaView];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(12.0f, 10.0f, 370.0f, 370.0f)];
    [_mapView setMapType:MKMapTypeStandard];
    [mapAreaView addSubview:_mapView];
        
    UIImageView *mapOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
    [mapAreaView addSubview:mapOverlay];
    
    Address *leadAddress = (Address *)_lead.address;
    if (leadAddress.street != nil && leadAddress.city != nil && leadAddress.state != nil)
    {
        UIImage *addressBackdropImage = [UIImage imageWithIdentifier:@"Lead Detail Address Backdrop" forSize:CGSizeMake(360.0f, 100.0f) andDrawingBlock:^{
            //// General Declarations
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Gradient Declarations
            NSArray* gradientColors = [NSArray arrayWithObjects: 
                                       (id)[UIColor blackColor].CGColor, 
                                       (id)[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5].CGColor, 
                                       (id)[UIColor clearColor].CGColor, nil];
            CGFloat gradientLocations[] = {0, 0.75, 1};
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
            
            
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
            [bezier2Path moveToPoint: CGPointMake(360, 100)];
            [bezier2Path addLineToPoint: CGPointMake(351.6, 100)];
            [bezier2Path addLineToPoint: CGPointMake(280.5, 95.5)];
            [bezier2Path addLineToPoint: CGPointMake(190.5, 100)];
            [bezier2Path addLineToPoint: CGPointMake(170.5, 100)];
            [bezier2Path addLineToPoint: CGPointMake(80.5, 95.5)];
            [bezier2Path addLineToPoint: CGPointMake(8.5, 100)];
            [bezier2Path addLineToPoint: CGPointMake(0, 100)];
            [bezier2Path addLineToPoint: CGPointMake(0, -0)];
            [bezier2Path addLineToPoint: CGPointMake(360, -0)];
            [bezier2Path addLineToPoint: CGPointMake(360, 100)];
            [bezier2Path closePath];
            CGContextSaveGState(context);
            [bezier2Path addClip];
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 50), CGPointMake(360, 50), 0);
            CGContextRestoreGState(context);
            
            
            //// Cleanup
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);
        }];
        UIImageView *addressView = [[UIImageView alloc] initWithImage:addressBackdropImage];
        [addressView setTop:277.0f];
        [addressView setLeft:20.0f];
        [mapAreaView addSubview:addressView];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(23.0f, 277.0f, 352.0f, 100.0f)];
        [addressLabel setNumberOfLines:4];
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [addressLabel setTextColor:[UIColor whiteColor]];
        [addressLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [addressLabel setShadowColor:[UIColor darkGrayColor]];
        [addressLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [addressLabel setText:[NSString stringWithFormat:@"%@\n%@, %@ %@\n%@", leadAddress.street, leadAddress.city, leadAddress.state, (leadAddress.postalCode != nil ? leadAddress.postalCode : @""), (leadAddress.country != nil ? leadAddress.country : @"")]];
        [mapAreaView addSubview:addressLabel];
    }
    
    UIImage *ratingImage;
    if ([_lead.rating isEqualToString:@"Hot"]) {
        ratingImage = [UIImage imageNamed:@"weather_clear.png"];
    }
    else if ([_lead.rating isEqualToString:@"Warm"]) {
        ratingImage = [UIImage imageNamed:@"weather_overcast.png"];
    }
    else if ([_lead.rating isEqualToString:@"Cold"]) {
        ratingImage = [UIImage imageNamed:@"weather_showers_scattered.png"];
    }
    else {
        ratingImage = [UIImage imageNamed:@"weather_fog.png"];
    }

    UIImageView *ratingImageView = [[UIImageView alloc] initWithImage:ratingImage];
    [ratingImageView setFrame:CGRectMake(315.0f, 6.0f, 80.0f, 80.0f)];
    [self.view addSubview:ratingImageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
    region.center.latitude = UNBOX_DOUBLE(_lead.geoLatitude);
    region.center.longitude = UNBOX_DOUBLE(_lead.geoLongitude);
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    [_mapView setRegion:region animated:NO];
    
    if (UNBOX_DOUBLE(_lead.geoLatitude) != 0 && UNBOX_DOUBLE(_lead.geoLongitude) != 0) {
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        [pointAnnotation setCoordinate:region.center];
        [_mapView addAnnotation:pointAnnotation];
    }
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

#pragma mark - Actions

- (void)showMailCompose
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
    [mailController setToRecipients:[NSArray arrayWithObject:_lead.email]];
    [mailController setMailComposeDelegate:self];
    [self presentModalViewController:mailController animated:YES];
}

- (void)openWebsite
{
    TSMiniWebBrowser *browser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:_lead.website]];
    [browser setMode:TSMiniWebBrowserModeModal];
    [browser setModalDismissButtonTitle:@"Close"];
    [browser setBarStyle:UIBarStyleBlack];
    [self presentModalViewController:browser animated:YES];
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
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
