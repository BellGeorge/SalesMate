//
//  AccountContactsTableViewController.m
//  Sales Mate
//
//  Created by Thomas Hajcak Jr on 7/18/12.
//  Copyright (c) 2012 Mavens Consulting, Inc. All rights reserved.
//

#import "AccountContactsTableViewController.h"
#import "ContactDetailsViewController.h"

#import "Contact.h"
#import "SalesAccount.h"

@interface AccountContactsTableViewController ()
{
    CoreDataStore *_dataStore;
    SalesAccount *_account;
    
    NSMutableArray *_accountContactsArray;
}
@end

@implementation AccountContactsTableViewController

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
    
    [self.tableView setFrame:CGRectMake(11.0f, 313.0f, 253.0f, 252.0f)];
    [self.tableView setAutoresizingMask:UIViewAutoresizingNone];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    _dataStore = [CoreDataStore createStore];
    _account = (SalesAccount *)[_dataStore entityByObjectID:_accountId];
    
    _accountContactsArray = [[NSMutableArray alloc] init];
    for (Contact *contact in [Contact allForPredicate:[NSPredicate predicateWithFormat:@"account == %@", _account] orderBy:@"name" ascending:YES]) {
        [_accountContactsArray addObject:contact];
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
    return [_accountContactsArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    Contact *contact = [_accountContactsArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:contact.name];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactDetailsViewController *detailsViewController = [[ContactDetailsViewController alloc] init];
    [detailsViewController setContactId:((Contact *)[_accountContactsArray objectAtIndex:indexPath.row]).objectID];
    
    [_navigationController pushViewController:detailsViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
