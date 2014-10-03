//
//  EntryControler.h
//  Entries
//
//  Created by James Westmoreland on 9/19/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"


@interface EntryController : NSObject

+ (EntryController *)sharedInstance;
- (NSArray *)entries;
- (void)addEntryWithTitle:(NSString *)title text:(NSString *)text dateCreated:(NSDate *)dateCreated dateModified:(NSDate *)dateModified;
- (void)removeEntry:(Entry *)entry;
- (void)synchronize;

@end
