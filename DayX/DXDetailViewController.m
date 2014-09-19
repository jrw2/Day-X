//
//  DXDetailViewController.m
//  DayX
//
//  Created by James Westmoreland on 9/17/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "DXDetailViewController.h"

@interface DXDetailViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextView *textNote;

@end

@implementation DXDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"DayX";
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 70, 70)];
    self.titleField.text = @"Enter Title Here";
    self.titleField.clearButtonMode = UITextFieldViewModeAlways;
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    self.textNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 145, self.view.frame.size.width - 10, self.view.frame.size.height - 145)];
    self.textNote.text = @"Place notes and other related text in this area.";
    self.textNote.delegate = self;
    [self.view addSubview:self.textNote];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn called.");
    [textField resignFirstResponder];
    
    return YES;
}

// called when clear button pressed. return NO to ignore
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"textFieldShouldClear called.");
    self.titleField.text = @"";
    self.textNote.text = @"";
    
    return YES;
}

@end
