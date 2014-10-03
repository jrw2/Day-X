//
//  Entry.h
//  DayX
//
//  Created by James Westmoreland on 10/3/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;

@end
