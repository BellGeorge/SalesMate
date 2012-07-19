//
//  DataHandler.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/2/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "DataHandler.h"
#import "SFRestAPI+Blocks.h"

#import "SalesAccount.h"
#import "Contact.h"
#import "Address.h"
#import "Opportunity.h"
#import "Lead.h"

#import "UrlConnectionDelegate.h"

#import "SBJsonParser.h"
#import "NSObject+SBJson.h"

#import "RestKit.h"

#import <MapKit/MapKit.h>

@implementation DataHandler

@synthesize client = _client;
@synthesize stateDescription = _stateDescription;

+ (DataHandler *)sharedInstance
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    //    [_sharedObject getNewManagedObjectContext];
    
    return _sharedObject;
}

- (id)init
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });
    
    return self;
}

#pragma mark - Public Methods

+ (void)getOpportunities
{
    [[DataHandler sharedInstance] getOpportunities];
}

+ (void)getLeads
{
    [[DataHandler sharedInstance] getLeads];
}

+ (void)authenticateStreamingApi
{
    [[DataHandler sharedInstance] authenticateStreamingApi];
}

+ (void)unsubscribeFrom:(NSString *)subscription
{
    [[DataHandler sharedInstance] unsubscribeFrom:subscription];
}

+ (void)registerDeviceWithId:(id)deviceId
{
    [[DataHandler sharedInstance] registerDeviceWithId:deviceId];
}

+ (void)removeAllData
{
    [[DataHandler sharedInstance] removeAllData];
}

#pragma mark - Get Data

- (void)getOpportunities
{
    // Field Order: Contact Role, Opportunity, Opportunity.Account, Opportunity.Contact, Opportunity.Contact.Account
    NSString *queryString = [NSString stringWithFormat:@"Select %@, %@, %@, %@, %@ from OpportunityContactRole ocr",
                             @"Role",
                             @"ocr.Opportunity.Id, ocr.Opportunity.Amount, ocr.Opportunity.CloseDate, ocr.Opportunity.Description, ocr.Opportunity.ExpectedRevenue, ocr.Opportunity.LeadSource, ocr.Opportunity.NextStep, ocr.Opportunity.Name, ocr.Opportunity.Probability, ocr.Opportunity.TotalOpportunityQuantity, ocr.Opportunity.StageName, ocr.Opportunity.Type", 
                             @"ocr.Opportunity.Account.Id, ocr.Opportunity.Account.AnnualRevenue, ocr.Opportunity.Account.Description, ocr.Opportunity.Account.Fax, ocr.Opportunity.Account.Latitude__c, ocr.Opportunity.Account.Longitude__c, ocr.Opportunity.Account.Industry, ocr.Opportunity.Account.Name, ocr.Opportunity.Account.Phone, ocr.Opportunity.Account.Type, ocr.Opportunity.Account.Website",
                             @"ocr.Contact.Id, ocr.Contact.Description, ocr.Contact.Email, ocr.Contact.Fax, ocr.Contact.HomePhone, ocr.Contact.MobilePhone, ocr.Contact.Name, ocr.Contact.Phone, ocr.Contact.Latitude__c, ocr.Contact.Longitude__c, ocr.Contact.Title",
                             @"ocr.Contact.Account.Id, ocr.Contact.Account.AnnualRevenue, ocr.Contact.Account.Description, ocr.Contact.Account.Fax, ocr.Contact.Account.Latitude__c, ocr.Contact.Account.Longitude__c, ocr.Contact.Account.Industry, ocr.Contact.Account.Name, ocr.Contact.Account.Phone, ocr.Contact.Account.Type, ocr.Contact.Account.Website"];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:queryString];
    [[SFRestAPI sharedInstance] sendRESTRequest:request 
                                      failBlock:^(NSError *error){
                                          
                                      }
                                  completeBlock:^(id dictionary){
                                      dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                          CoreDataStore *dataStore = [CoreDataStore createStore];
                                          
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                          [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                          
                                          for (NSDictionary *record in [dictionary objectForKey:@"records"]) {
                                              
                                              // Opportunity Setup
                                              NSDictionary *opportunityDictionary = [record objectForKey:@"Opportunity"];
                                              Opportunity *opportunity = [Opportunity firstWithKey:@"id" 
                                                                                             value:[opportunityDictionary valueForKey:@"Id"]
                                                                                           inStore:dataStore];
                                              if (opportunity == nil) {
                                                  opportunity = [Opportunity createInStore:dataStore];
                                                  [opportunity setId:[opportunityDictionary valueForKey:@"Id"]];
                                              }
                                              
                                              // Required Fields
                                              [opportunity setName:[opportunityDictionary valueForKey:@"Name"]];
                                              [opportunity setStage:[opportunityDictionary valueForKey:@"StageName"]];
                                              [opportunity setCloseDate:[dateFormatter dateFromString:[opportunityDictionary valueForKey:@"CloseDate"]]];
                                              
                                              // Optional Fields
                                              if ([opportunityDictionary valueForKey:@"Description"] != [NSNull null]) {
                                                  [opportunity setDescriptionText:[opportunityDictionary valueForKey:@"Description"]];
                                              }
                                              if ([opportunityDictionary valueForKey:@"LeadSource"] != [NSNull null]) {
                                                  [opportunity setLeadSource:[opportunityDictionary valueForKey:@"LeadSource"]];
                                              }
                                              if ([opportunityDictionary valueForKey:@"NextStep"] != [NSNull null]) {
                                                  [opportunity setNextStep:[opportunityDictionary valueForKey:@"NextStep"]];
                                              }
                                              if ([opportunityDictionary valueForKey:@"Type"] != [NSNull null]) {
                                                  [opportunity setType:[opportunityDictionary valueForKey:@"Type"]];
                                              }
                                              
                                              if ([opportunityDictionary valueForKey:@"Amount"] != [NSNull null]) {
                                                  [opportunity setAmount:BOX_INT([[opportunityDictionary valueForKey:@"Amount"] integerValue])];
                                              }
                                              if ([opportunityDictionary valueForKey:@"ExpectedRevenue"] != [NSNull null]) {
                                                  [opportunity setExpectedRevenue:BOX_INT([[opportunityDictionary valueForKey:@"ExpectedRevenue"] integerValue])];
                                              }
                                              if ([opportunityDictionary valueForKey:@"Probability"] != [NSNull null]) {
                                                  [opportunity setProbability:BOX_INT([[opportunityDictionary valueForKey:@"Probability"] integerValue])];
                                              }
                                              
                                              
                                              // Opportunity Account Setup
                                              NSDictionary *accountDictionary = [opportunityDictionary valueForKey:@"Account"];
                                              SalesAccount *account = [SalesAccount firstWithKey:@"id"
                                                                                 value:[accountDictionary valueForKey:@"Id"]
                                                                               inStore:dataStore];
                                              if (account == nil) {
                                                  account = [SalesAccount createInStore:dataStore];
                                                  [account setId:[accountDictionary valueForKey:@"Id"]];
                                              }
                                              
                                              [opportunity setAccount:account];
                                              
                                              if ([accountDictionary valueForKey:@"AnnualRevenue"] != [NSNull null]) {
                                                  [account setAnnualRevenue:BOX_INT([[accountDictionary valueForKey:@"AnnualRevenue"] integerValue])];
                                              }
                                              if ([accountDictionary valueForKey:@"Description"] != [NSNull null]) {
                                                  [account setDescriptionText:[accountDictionary valueForKey:@"Description"]];
                                              }
                                              if ([accountDictionary valueForKey:@"Fax"] != [NSNull null]) {
                                                  [account setFax:[accountDictionary valueForKey:@"Fax"]];
                                              }
                                              if ([accountDictionary valueForKey:@"Latitude__c"] != [NSNull null]) {
                                                  [account setGeoLatitude:BOX_DOUBLE([[accountDictionary valueForKey:@"Latitude__c"] doubleValue])];
                                              }
                                              if ([accountDictionary valueForKey:@"Longitude__c"] != [NSNull null]) {
                                                  [account setGeoLongitude:BOX_DOUBLE([[accountDictionary valueForKey:@"Longitude__c"] doubleValue])];
                                              }
                                              if ([accountDictionary valueForKey:@"Industry"] != [NSNull null]) {
                                                  [account setIndustry:[accountDictionary valueForKey:@"Industry"]];
                                              }
                                              if ([accountDictionary valueForKey:@"Name"] != [NSNull null]) {
                                                  [account setName:[accountDictionary valueForKey:@"Name"]];
                                              }
                                              if ([accountDictionary valueForKey:@"Phone"] != [NSNull null]) {
                                                  [account setPhone:[accountDictionary valueForKey:@"Phone"]];
                                              }
                                              if ([accountDictionary valueForKey:@"Type"] != [NSNull null]) {
                                                  [account setType:[accountDictionary valueForKey:@"Type"]];
                                              }
                                              if ([accountDictionary valueForKey:@"Website"] != [NSNull null]) {
                                                  [account setWebsite:[accountDictionary valueForKey:@"Website"]];
                                              }
                                              
                                              
                                              // Contact Setup
                                              NSDictionary *contactDictionary = [record valueForKey:@"Contact"];
                                              Contact *contact = [Contact firstWithKey:@"id"
                                                                                 value:[contactDictionary valueForKey:@"Id"]
                                                                               inStore:dataStore];
                                              if (contact == nil) {
                                                  contact = [Contact createInStore:dataStore];
                                                  [contact setId:[contactDictionary valueForKey:@"Id"]];
                                                  [opportunity addContactsObject:contact];
                                              }
                                              
                                              if ([contactDictionary valueForKey:@"Name"] != [NSNull null]) {
                                                  [contact setName:[contactDictionary valueForKey:@"Name"]];
                                              }
                                              if ([contactDictionary valueForKey:@"Description"] != [NSNull null]) {
                                                  [contact setDescriptionText:[contactDictionary valueForKey:@"Description"]];
                                              }
                                              if ([contactDictionary valueForKey:@"Email"] != [NSNull null]) {
                                                  [contact setEmail:[contactDictionary valueForKey:@"Email"]];
                                              }
                                              if ([contactDictionary valueForKey:@"Fax"] != [NSNull null]) {
                                                  [contact setFax:[contactDictionary valueForKey:@"Fax"]];
                                              }
                                              if ([contactDictionary valueForKey:@"HomePhone"] != [NSNull null]) {
                                                  [contact setHomePhone:[contactDictionary valueForKey:@"HomePhone"]];
                                              }
                                              if ([contactDictionary valueForKey:@"MobilePhone"] != [NSNull null]) {
                                                  [contact setMobilePhone:[contactDictionary valueForKey:@"MobilePhone"]];
                                              }
                                              if ([contactDictionary valueForKey:@"Phone"] != [NSNull null]) {
                                                  [contact setPhone:[contactDictionary valueForKey:@"Phone"]];
                                              }
                                              if ([record valueForKey:@"Role"] != [NSNull null]) {
                                                  [contact setRole:[record valueForKey:@"Role"]];
                                              }
                                              if ([contactDictionary valueForKey:@"Latitude__c"] != [NSNull null]) {
                                                  [contact setGeoLatitude:BOX_DOUBLE([[contactDictionary valueForKey:@"Latitude__c"] doubleValue])];
                                              }
                                              if ([contactDictionary valueForKey:@"Longitude__c"] != [NSNull null]) {
                                                  [contact setGeoLongitude:BOX_DOUBLE([[contactDictionary valueForKey:@"Longitude__c"] doubleValue])];
                                              }
                                              if ([contactDictionary valueForKey:@"Title"] != [NSNull null]) {
                                                  [contact setTitle:[contactDictionary valueForKey:@"Title"]];
                                              }
                                              
                                              
                                              // Contact Account Setup
                                              NSDictionary *contactAccountDictionary = [contactDictionary valueForKey:@"Account"];
                                              SalesAccount *contactAccount = [SalesAccount firstWithKey:@"id"
                                                                                                  value:[contactAccountDictionary valueForKey:@"Id"]
                                                                                                inStore:dataStore];
                                              if (contactAccount == nil) {
                                                  contactAccount = [SalesAccount createInStore:dataStore];
                                                  [contactAccount setId:[contactAccountDictionary valueForKey:@"Id"]];
                                              }
                                              
                                              [contact setAccount:contactAccount];
                                              
                                              if ([contactAccountDictionary valueForKey:@"AnnualRevenue"] != [NSNull null]) {
                                                  [contactAccount setAnnualRevenue:BOX_INT([[contactAccountDictionary valueForKey:@"AnnualRevenue"] integerValue])];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Description"] != [NSNull null]) {
                                                  [contactAccount setDescriptionText:[contactAccountDictionary valueForKey:@"Description"]];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Fax"] != [NSNull null]) {
                                                  [contactAccount setFax:[contactAccountDictionary valueForKey:@"Fax"]];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Latitude__c"] != [NSNull null]) {
                                                  [contactAccount setGeoLatitude:BOX_DOUBLE([[contactAccountDictionary valueForKey:@"Latitude__c"] doubleValue])];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Longitude__c"] != [NSNull null]) {
                                                  [contactAccount setGeoLongitude:BOX_DOUBLE([[contactAccountDictionary valueForKey:@"Longitude__c"] doubleValue])];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Industry"] != [NSNull null]) {
                                                  [contactAccount setIndustry:[contactAccountDictionary valueForKey:@"Industry"]];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Name"] != [NSNull null]) {
                                                  [contactAccount setName:[contactAccountDictionary valueForKey:@"Name"]];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Phone"] != [NSNull null]) {
                                                  [contactAccount setPhone:[contactAccountDictionary valueForKey:@"Phone"]];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Type"] != [NSNull null]) {
                                                  [contactAccount setType:[contactAccountDictionary valueForKey:@"Type"]];
                                              }
                                              if ([contactAccountDictionary valueForKey:@"Website"] != [NSNull null]) {
                                                  [contactAccount setWebsite:[contactAccountDictionary valueForKey:@"Website"]];
                                              }
                                          }
                                          
                                          [dataStore save];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [MessageCenter sendGlobalMessageNamed:MESSAGE_OPPORTUNITIES_UPDATED];
                                          });
                                      });
                                  }];
}

- (void)getLeads
{
    NSString *queryString = [NSString stringWithFormat:@"Select Id, AnnualRevenue, CreatedDate, Company, Description, Email, Fax, Industry, LastModifiedDate, LeadSource, Status, MobilePhone, Name, NumberOfEmployees, Phone, Rating, Title, Website, Latitude__c, Longitude__c, Street, City, State, PostalCode, Country from Lead"];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:queryString];
    [[SFRestAPI sharedInstance] sendRESTRequest:request 
                                      failBlock:^(NSError *error){
                                          
                                      }
                                  completeBlock:^(id dictionary){
                                      dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                          CoreDataStore *dataStore = [CoreDataStore createStore];
                                          
                                          for (NSDictionary *record in [dictionary objectForKey:@"records"]) {
                                              Lead *lead = [Lead firstWithKey:@"id" 
                                                                        value:[record valueForKey:@"Id"]
                                                                      inStore:dataStore];
                                              if (lead == nil) {
                                                  lead = [Lead createInStore:dataStore];
                                                  [lead setId:[record valueForKey:@"Id"]];
                                              }
                                              
                                              // Required Fields
                                              [lead setLeadStatus:[record valueForKey:@"Status"]];
                                              
                                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                              [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.sssZ"];
                                              [lead setCreatedDate:[dateFormatter dateFromString:[record valueForKey:@"CreatedDate"]]];
                                              
                                              // Optional Fields
                                              if ([record valueForKey:@"AnnualRevenue"] != [NSNull null]) {
                                                  [lead setAnnualRevenue:BOX_INT([[record valueForKey:@"AnnualRevenue"] integerValue])];
                                              }
                                              if ([record valueForKey:@"Company"] != [NSNull null]) {
                                                  [lead setCompany:[record valueForKey:@"Company"]];
                                              }
                                              if ([record valueForKey:@"Description"] != [NSNull null]) {
                                                  [lead setDescriptionText:[record valueForKey:@"Description"]];
                                              }
                                              if ([record valueForKey:@"DoNotCall"] != [NSNull null]) {
                                                  [lead setDoNotCall:BOX_BOOL([[record valueForKey:@"DoNotCall"] boolValue])];
                                              }
                                              if ([record valueForKey:@"Email"] != [NSNull null]) {
                                                  [lead setEmail:[record valueForKey:@"Email"]];
                                              }
                                              if ([record valueForKey:@"HasOptedOutOfEmail"] != [NSNull null]) {
                                                  [lead setEmailOptOut:BOX_BOOL([[record valueForKey:@"HasOptedOutOfEmail"] boolValue])];
                                              }
                                              if ([record valueForKey:@"Fax"] != [NSNull null]) {
                                                  [lead setFax:[record valueForKey:@"Fax"]];
                                              }
                                              if ([record valueForKey:@"HasOptedOutOfFax"] != [NSNull null]) {
                                                  [lead setFaxOptOut:BOX_BOOL([[record valueForKey:@"HasOptedOutOfFax"] boolValue])];
                                              }
                                              if ([record valueForKey:@"Industry"] != [NSNull null]) {
                                                  [lead setIndustry:[record valueForKey:@"Industry"]];
                                              }
                                              if ([record valueForKey:@"LeadSource"] != [NSNull null]) {
                                                  [lead setLeadSource:[record valueForKey:@"LeadSource"]];
                                              }
                                              if ([record valueForKey:@"Status"] != [NSNull null]) {
                                                  [lead setLeadStatus:[record valueForKey:@"Status"]];
                                              }
                                              if ([record valueForKey:@"MobilePhone"] != [NSNull null]) {
                                                  [lead setMobilePhone:[record valueForKey:@"MobilePhone"]];
                                              }
                                              if ([record valueForKey:@"Name"] != [NSNull null]) {
                                                  [lead setName:[record valueForKey:@"Name"]];
                                              }
                                              if ([record valueForKey:@"NumberOfEmployees"] != [NSNull null]) {
                                                  [lead setNumberOfEmployees:BOX_INT([[record valueForKey:@"NumberOfEmployees"] integerValue])];
                                              }
                                              if ([record valueForKey:@"Phone"] != [NSNull null]) {
                                                  [lead setPhone:[record valueForKey:@"Phone"]];
                                              }
                                              if ([record valueForKey:@"Status"] != [NSNull null]) {
                                                  [lead setLeadStatus:[record valueForKey:@"Status"]];
                                              }
                                              if ([record valueForKey:@"Rating"] != [NSNull null]) {
                                                  [lead setRating:[record valueForKey:@"Rating"]];
                                              }
                                              if ([record valueForKey:@"Title"] != [NSNull null]) {
                                                  [lead setTitle:[record valueForKey:@"Title"]];
                                              }
                                              if ([record valueForKey:@"Website"] != [NSNull null]) {
                                                  [lead setWebsite:[record valueForKey:@"Website"]];
                                              }
                                              
                                              if ([record valueForKey:@"Latitude__c"] != [NSNull null]) {
                                                  [lead setGeoLatitude:BOX_DOUBLE([[record valueForKey:@"Latitude__c"] doubleValue])];
                                              }
                                              if ([record valueForKey:@"Longitude__c"] != [NSNull null]) {
                                                  [lead setGeoLongitude:BOX_DOUBLE([[record valueForKey:@"Longitude__c"] doubleValue])];
                                              }
                                              
                                              NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                              if (![lead.lastModifiedDate isEqualToDate:[dateFormatter2 dateFromString:[record valueForKey:@"LastModifiedDate"]]]) {
                                                  [lead setLastModifiedDate:[dateFormatter2 dateFromString:[record valueForKey:@"LastModifiedDate"]]];
                                              }
                                              
                                              // Address
                                              Address *leadAddress = lead.address;
                                              if (leadAddress == nil) {
                                                  leadAddress = [Address createInStore:dataStore];
                                                  [lead setAddress:leadAddress];
                                              }
                                              
                                              if ([record valueForKey:@"Street"] != [NSNull null]) {
                                                  [leadAddress setStreet:[record valueForKey:@"Street"]];
                                              }
                                              if ([record valueForKey:@"City"] != [NSNull null]) {
                                                  [leadAddress setCity:[record valueForKey:@"City"]];
                                              }
                                              if ([record valueForKey:@"State"] != [NSNull null]) {
                                                  [leadAddress setState:[record valueForKey:@"State"]];
                                              }
                                              if ([record valueForKey:@"PostalCode"] != [NSNull null]) {
                                                  [leadAddress setPostalCode:[record valueForKey:@"PostalCode"]];
                                              }
                                              if ([record valueForKey:@"Country"] != [NSNull null]) {
                                                  [leadAddress setCountry:[record valueForKey:@"Country"]];
                                              }
                                          }
                                          
                                          [dataStore save];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [MessageCenter sendGlobalMessageNamed:MESSAGE_LEADS_UPDATED];
                                          });
                                      });
                                  }];
}

- (void)removeAllData
{
    [self unsubscribeFrom:@"/topic/LeadWithWebSource"];
    [[CoreDataStore mainStore] clearAllData];
    [MessageCenter sendGlobalMessageNamed:MESSAGE_LEADS_UPDATED];
    [MessageCenter sendGlobalMessageNamed:MESSAGE_OPPORTUNITIES_UPDATED];
    
    // TO DO: Unregister device from push notifications
}

#pragma mark - Salesforce Streaming API Delegate

//You may want this public
+ (void)subscribeTo:(NSString *)subscription
{
    [[DataHandler sharedInstance] subscribeTo:subscription];
}


- (void)authenticateStreamingApi
{
    _client = [[StreamingApiClient alloc] initWithSessionId:[[[[SFRestAPI sharedInstance] coordinator] credentials] accessToken] instance:[[[[SFRestAPI sharedInstance] coordinator] credentials] instanceUrl]];
    
    _client.delegate = self;
    
    //You are now ready to subscribe to topics (connect is handled in subscribe call). Use the below code to get the 
    
    //Get Stream Topics
    /*
     NSString *query;
     query = @"select name, query, apiVersion from pushTopic order by name";
     
     NSString *path = [NSString stringWithFormat:@"/services/data/v21.0/query?q=%@", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     NSString *sessionId = [[[[SFRestAPI sharedInstance] coordinator] credentials] accessToken];
     NSURL *qurl = [NSURL URLWithString:path relativeToURL:[[[[SFRestAPI sharedInstance] coordinator] credentials] instanceUrl]];
     NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:qurl];
     
     [r addValue:[NSString stringWithFormat:@"OAuth %@", sessionId] forHTTPHeaderField:@"Authorization"];
     
     UrlConnectionDelegateWithBlock *d = [UrlConnectionDelegateWithBlock urlDelegateWithBlock:^(NSUInteger httpStatusCode, NSHTTPURLResponse *response, NSData *body, NSError *err) {
     
     SBJsonParser *p = [[SBJsonParser alloc] init];
     NSLog(@"httpstatuscode: %d", httpStatusCode);
     if (httpStatusCode == 200) {
         NSDictionary *qr = [p objectWithData:body];
         NSLog(@"qr: %@",qr);
         //Add these to an Array as needed. 
         
     } else {
         NSLog(@"errors: %@", err);
     }
     
     } runOnMainThread:YES];
     
     [[NSURLConnection alloc] initWithRequest:r delegate:d startImmediately:YES];
     */
    //Test subscription, hardcoded.
    [[DataHandler sharedInstance] subscribeTo:@"/topic/LeadWithWebSource"];
}

- (void)eventOnChannel:(NSString *)channel message:(NSDictionary *)eventMessage
{
    
    if (([channel isEqualToString:@"/topic/LeadWithWebSource"]) && [[[eventMessage objectForKey:@"event"] objectForKey:@"type"] isEqualToString:@"created"]) {
        [MessageCenter sendGlobalMessageNamed:MESSAGE_STREAMING_UPDATE_RECEIVED];
        [self getLeads];
    }
}

- (void)subscribeTo:(NSString *)subscription {
    //Pass a string in the format @"/topic/StreamName"
    [self.client subscribe:subscription];
}

- (void)unsubscribeFrom:(NSString *)subscription
{
    [self.client unsubscribe:subscription];
}
- (void)stateChangedTo:(StreamingApiState)newState {
    switch (newState) {
        case sacDisconnected: self.stateDescription = @"Disconnected"; break;
        case sacConnecting:   self.stateDescription = @"Connecting"; break;
        case sacConnected:    self.stateDescription = @"Connected"; break;
        case sacDisconnecting:self.stateDescription = @"Disconnecting"; break;
    }
}
     
- (void)registerDeviceWithId:(id)deviceId 
{
    NSString *fixedDeviceId = [NSString stringWithFormat:@"%@", deviceId];
    fixedDeviceId = [fixedDeviceId stringByReplacingOccurrencesOfString:@"<" withString:@""];
    fixedDeviceId = [fixedDeviceId stringByReplacingOccurrencesOfString:@">" withString:@""];
    fixedDeviceId = [fixedDeviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[[[SFRestAPI sharedInstance] coordinator] credentials] accessToken], @"access_token",
                            [[[[SFRestAPI sharedInstance] coordinator] credentials] refreshToken], @"refresh_token",
                            [[[[SFRestAPI sharedInstance] coordinator] credentials] instanceUrl], @"instance_url",
                            [[[[SFRestAPI sharedInstance] coordinator] credentials] userId], @"sfdc_id",
                            fixedDeviceId, @"device_id", nil];
                                              
    RKParams *params = [RKParams paramsWithDictionary:paramsDict];
    [[RKClient sharedClient] post:@"http://mobile-challenge.herokuapp.com/create" params:params delegate:self];
}

@end
