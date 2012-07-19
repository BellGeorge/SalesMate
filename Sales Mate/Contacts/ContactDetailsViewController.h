//
//  ContactDetailsViewController.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/16/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) id contactId;

@end
