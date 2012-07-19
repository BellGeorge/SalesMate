//
//  Opportunity.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/16/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, SalesAccount;

@interface Opportunity : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * closeDate;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * expectedRevenue;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * leadSource;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nextStep;
@property (nonatomic, retain) NSNumber * probability;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * stage;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) SalesAccount *account;
@property (nonatomic, retain) NSSet *contacts;
@end

@interface Opportunity (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
