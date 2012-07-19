//
//  SalesAccount.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/18/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Opportunity;

@interface SalesAccount : NSManagedObject

@property (nonatomic, retain) NSNumber * annualRevenue;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSNumber * geoLatitude;
@property (nonatomic, retain) NSNumber * geoLongitude;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *opportunities;
@end

@interface SalesAccount (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addOpportunitiesObject:(Opportunity *)value;
- (void)removeOpportunitiesObject:(Opportunity *)value;
- (void)addOpportunities:(NSSet *)values;
- (void)removeOpportunities:(NSSet *)values;

@end
