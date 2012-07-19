//
//  OpportunityDetailsViewController.h
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/2/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface OpportunityDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic, strong) id opportunityId;

@end
