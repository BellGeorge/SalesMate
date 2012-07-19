//
//  AccountDetailsViewController.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/17/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id accountId;

@end
