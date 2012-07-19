//
//  DataHandler.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/2/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFRestAPI.h"
#import "RestKit.h"
#import "StreamingApiClient.h"

@interface DataHandler : NSObject <SFRestDelegate, StreamingApiClientDelegate, RKRequestDelegate>

@property (retain) StreamingApiClient   *client;
@property (retain) NSString             *stateDescription;


+ (DataHandler *)sharedInstance;

+ (void)getOpportunities;
+ (void)getLeads;
+ (void)authenticateStreamingApi;
+ (void)unsubscribeFrom:(NSString *)subscription;
+ (void)registerDeviceWithId:(id)deviceId;
+ (void)removeAllData;

@end
