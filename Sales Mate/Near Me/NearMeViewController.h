//
//  NearMeViewController.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/17/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@interface NearMeViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@end
