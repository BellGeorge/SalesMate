//
//  LeadDetailsViewController.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/11/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LeadDetailsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) id leadId;

@end
