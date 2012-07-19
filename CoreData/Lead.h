//
//  Lead.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/18/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address;

@interface Lead : NSManagedObject

@property (nonatomic, retain) NSNumber * annualRevenue;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * doNotCall;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * emailOptOut;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSNumber * faxOptOut;
@property (nonatomic, retain) NSNumber * geoLatitude;
@property (nonatomic, retain) NSNumber * geoLongitude;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSDate * lastModifiedDate;
@property (nonatomic, retain) NSString * leadSource;
@property (nonatomic, retain) NSString * leadStatus;
@property (nonatomic, retain) NSData * mapImage;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfEmployees;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) NSManagedObject *owner;

@end
