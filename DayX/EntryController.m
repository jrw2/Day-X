//
//  EntryControler.m
//  Entries
//
//  Created by James Westmoreland on 9/19/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import "EntryController.h"

static NSString * const entryListKey = @"entryList";

@interface EntryController ()

@property (strong, nonatomic) NSArray *entries;

@end

@implementation EntryController

+ (EntryController *)sharedInstance {
    static EntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EntryController alloc] init];
        sharedInstance.entries = @[];
        [sharedInstance loadFromDefaults];
    });
    return sharedInstance;
}

- (void)addEntry:(NSDictionary *)entry
{
    if (!entry) {
        return;
    }
    
    NSMutableArray *mutableEntries = [self.entries mutableCopy];
    [mutableEntries addObject:entry];
    self.entries = mutableEntries;
    [self synchronize];
}

- (void)removeEntry:(NSDictionary *)entry
{
    if (!entry) {
        return;
    }
    
    NSMutableArray *mutableEntries = [self.entries mutableCopy];
    [mutableEntries removeObject:entry];
    self.entries = mutableEntries;
    [self synchronize];
}

- (void)replaceEntry:(NSDictionary *)oldEntry withEntry:(NSDictionary *)newEntry
{
    if (!oldEntry || !newEntry) {
        return;
    }
    
    NSMutableArray *mutableEntries = [self.entries mutableCopy];
    if ([mutableEntries containsObject:oldEntry]) {
        NSInteger index = [mutableEntries indexOfObject:oldEntry];
        [mutableEntries replaceObjectAtIndex:index withObject:newEntry];
    }
    self.entries = mutableEntries;
    [self synchronize];
}

- (void)loadFromDefaults
{
    NSArray *entryDictionaries = [[NSUserDefaults standardUserDefaults] objectForKey:entryListKey];
    
    NSMutableArray *entries = [NSMutableArray new];
    for (NSDictionary *entry in entryDictionaries) {
        [entries addObject:[[Entry alloc] initWithDictionary:entry]];
    }
    
    self.entries = entries;
}

- (void)synchronize
{
    NSMutableArray *entryDictionaries = [NSMutableArray new];
    for (Entry *entry in self.entries) {
        [entryDictionaries addObject:[entry entryDictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:entryDictionaries forKey:entryListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
