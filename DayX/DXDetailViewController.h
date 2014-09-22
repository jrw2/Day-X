//
//  DXDetailViewController.h
//  DayX
//
//  Created by James Westmoreland on 9/17/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Entry;

static NSString * const EntryKey = @"entry";

@interface DXDetailViewController : UIViewController

- (void)updateWithEntry:(Entry *)entry;

@end
