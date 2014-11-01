//
//  DXListTableViewDataSource.m
//  DayX
//
//  Created by James Westmoreland on 9/19/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import "DXListTableViewDataSource.h"
#import "EntryController.h"

@implementation DXListTableViewDataSource

- (void)registerTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [EntryController sharedInstance].entries.count;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entry *entry = [EntryController sharedInstance].entries[indexPath.row];
        [[EntryController sharedInstance] removeEntry:entry];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Add Entry";
        cell.textLabel.accessibilityTraits |= UIAccessibilityTraitButton;
    } else {
        Entry *entry = [EntryController sharedInstance].entries[indexPath.row];
        cell.textLabel.text = entry.title;
        if ([tableView isEditing] == YES) {
            cell.textLabel.accessibilityTraits &= ~UIAccessibilityTraitButton;
        } else {
            cell.textLabel.accessibilityTraits |= UIAccessibilityTraitButton;
        }
    }
    
    return cell;
}

@end
