//
//  Entry.h
//  Entries
//
//  Created by James Westmoreland on 9/20/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSDate *dateModified;

@end
