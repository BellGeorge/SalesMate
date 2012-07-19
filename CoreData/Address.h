//
//  Address.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/12/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lead;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSSet *lead;
@end

@interface Address (CoreDataGeneratedAccessors)

- (void)addLeadObject:(Lead *)value;
- (void)removeLeadObject:(Lead *)value;
- (void)addLead:(NSSet *)values;
- (void)removeLead:(NSSet *)values;

@end
