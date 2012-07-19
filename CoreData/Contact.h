//
//  Contact.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/17/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Opportunity, SalesAccount;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSNumber * geoLatitude;
@property (nonatomic, retain) NSNumber * geoLongitude;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SalesAccount *account;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Opportunity *opportunity;

@end
