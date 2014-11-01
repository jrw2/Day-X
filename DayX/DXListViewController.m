//
//  DXListViewController.m
//  DayX
//
//  Created by James Westmoreland on 9/19/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import "DXListViewController.h"
#import "DXListTableViewDataSource.h"
#import "DXDetailViewController.h"
#import "EntryController.h"

@interface DXListViewController () <UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXListTableViewDataSource *dataSource;

@end

@implementation DXListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"DayX";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.dataSource = [DXListTableViewDataSource new];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.tableView setEditing:NO];
    [self.dataSource registerTableView:self.tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DXDetailViewController *detailViewController = [DXDetailViewController new];
    if (indexPath.section != 0) {
        [detailViewController updateWithEntry:[EntryController sharedInstance].entries[indexPath.row]];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)edit:(id)sender
{
    [self.tableView setEditing:YES];
//    [self.tableView reloadData];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)done:(id)sender
{
    [self.tableView setEditing:NO];
//    [self.tableView reloadData];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

@end
