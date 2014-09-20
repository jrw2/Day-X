//
//  Entry.m
//  Entries
//
//  Created by James Westmoreland on 9/20/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import "Entry.h"

@implementation Entry

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.title = dictionary[titleKey];
        self.text = dictionary[textKey];
        self.timestamp = dictionary[timestampKey];
    }
    return self;
}

- (NSDictionary *)entryDictionary
{
    NSMutableDictionary *entryDictionary = [NSMutableDictionary new];
    if (self.title) {
        [entryDictionary setObject:self.title forKey:titleKey];
    }
    if (self.text) {
        [entryDictionary setObject:self.text forKey:textKey];
    }
    if (self.timestamp) {
        [entryDictionary setObject:self.timestamp forKey:timestampKey];
    }
    
    return entryDictionary;
}

@end
