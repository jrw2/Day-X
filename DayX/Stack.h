//
//  Stack.h
//  Core Data Bank
//
//  Created by James Westmoreland on 9/16/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

+ (Stack *)sharedInstance;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
