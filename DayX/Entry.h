//
//  Entry.h
//  Entries
//
//  Created by James Westmoreland on 9/20/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const titleKey = @"title";
static NSString * const textKey = @"text";
static NSString * const timestampKey = @"timestamp";

@interface Entry : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong,nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *timestamp;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)entryDictionary;

@end
