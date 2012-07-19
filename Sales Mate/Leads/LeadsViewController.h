//
//  LeadsViewController.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/2/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface LeadsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (nonatomic) BOOL shouldOpenNewestLead;

@end
