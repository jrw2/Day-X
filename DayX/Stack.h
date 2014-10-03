//
//  Stack.h
//  Core Data Bank
//
//  Created by Joshua Howland on 6/12/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

+ (Stack *)sharedInstance;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
