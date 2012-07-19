//
//  AccountOpportunitiesTableViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/18/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "AccountOpportunitiesTableViewController.h"

#import "Opportunity.h"
#import "SalesAccount.h"

@interface AccountOpportunitiesTableViewController ()
{
    CoreDataStore *_dataStore;
    SalesAccount *_account;
    
    NSMutableArray *_accountOpportunitiesArray;
}
@end

@implementation AccountOpportunitiesTableViewController

@synthesize accountId = _accountId;
@synthesize navigationController = _navigationController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setFrame:CGRectMake(277.0f, 313.0f, 253.0f, 252.0f)];
    [self.tableView setAutoresizingMask:UIViewAutoresizingNone];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    _dataStore = [CoreDataStore createStore];
    _account = (SalesAccount *)[_dataStore entityByObjectID:_accountId];
    
    _accountOpportunitiesArray = [[NSMutableArray alloc] init];
    for (Opportunity *opportunity in [Opportunity allForPredicate:[NSPredicate predicateWithFormat:@"account == %@", _account] orderBy:@"name" ascending:YES]) {
        [_accountOpportunitiesArray addObject:opportunity];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_accountOpportunitiesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setNumberOfLines:2];
    }
    
    Opportunity *opportunity = [_accountOpportunitiesArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:opportunity.name];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
