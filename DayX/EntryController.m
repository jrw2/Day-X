//
//  EntryControler.m
//  Entries
//
//  Created by James Westmoreland on 9/19/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import "EntryController.h"

@interface EntryController ()

@end

@implementation EntryController

+ (EntryController *)sharedInstance {
    static EntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EntryController alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)entries
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
    return objects;
}

- (void)addEntryWithTitle:(NSString *)title text:(NSString *)text dateCreated:(NSDate *)dateCreated dateModified:(NSDate *)dateModified
{
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                 inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    entry.title = title;
    entry.text = text;
    entry.dateCreated = dateCreated;
    entry.dateModified = dateModified;
    
    [self synchronize];
}

- (void)removeEntry:(Entry *)entry
{
    [entry.managedObjectContext deleteObject:entry];
    [self synchronize];
}

- (void)synchronize
{
    [[Stack sharedInstance].managedObjectContext save:NULL];
}

@end
