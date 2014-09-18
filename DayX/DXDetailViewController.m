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
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 44)];
    self.titleField.text = @"Enter Title Here";
    self.titleField.clearButtonMode = UITextFieldViewModeAlways;
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    self.textNote = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.textNote.text = @"Place notes and other related text in this area.";
    self.textNote.delegate = self;
    [self.view addSubview:self.textNote];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// called when clear button pressed. return NO to ignore
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.titleField = @"";
    self.textNote = @"";
    
    return YES;
}

@end
