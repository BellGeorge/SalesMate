//
//  NearMeViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/17/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "NearMeViewController.h"
#import "NearMeAnnotationView.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Lead.h"

@interface NearMeViewController ()
{
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
    
    NSMutableArray *_leadsInArea;
    CoreDataStore *_dataStore;
    
    Boolean *_needsUpdate;
}

@end

@implementation NearMeViewController

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
	
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [_mapView setTop:0.0f];
    [_mapView setDelegate:self];
    [_mapView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [_mapView setShowsUserLocation:YES];
    [self.view addSubview:_mapView];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate: self];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _needsUpdate = NO;
    
    [self updateLocalData];
    
    [MessageCenter addGlobalMessageListener:MESSAGE_LEADS_UPDATED
                                     target:self
                                     action:SEL(updateLocalData)];
    
    IBButton *currentLocationButton = [IBButton flatButtonWithTitle:nil color:[UIColor colorWithHexString:@"005050BF"]];
    [currentLocationButton setImage:[UIImage imageNamed:@"navigation.png"] forState:UIControlStateNormal];
    [currentLocationButton setFrame:CGRectMake(0.0f, 10.0f, 50.0f, 50.0f)];
    [currentLocationButton setRight:(self.view.width - 10.0f)];
    [currentLocationButton setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin)];
    [currentLocationButton addTarget:self
                              action:SEL(moveToCurrentLocation)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [_locationManager stopUpdatingLocation];
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

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
}

#pragma mark - Actions

- (void)updateLocalData
{
    for (id annotation in _mapView.annotations){
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    _dataStore = [CoreDataStore createStore];
    for (Lead *lead in [Lead allForPredicate:[NSPredicate predicateWithFormat:@"geoLatitude != nil && geoLongitude != nil"] inStore:_dataStore]) {
        MKPointAnnotation *leadPoint = [[MKPointAnnotation alloc] init];
        [leadPoint setCoordinate:CLLocationCoordinate2DMake(UNBOX_DOUBLE(lead.geoLatitude), UNBOX_DOUBLE(lead.geoLongitude))];
        [leadPoint setTitle:lead.name];
        [leadPoint setSubtitle:lead.company];
        
        [_mapView addAnnotation:leadPoint];
    }
}

- (void)moveToCurrentLocation
{
    [_mapView setRegion:MKCoordinateRegionMake(_mapView.userLocation.coordinate, MKCoordinateSpanMake(1.0f, 1.0f)) animated:YES];
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Did Select View: %@", [view.annotation title]);
}

@end
