//
//  DXDetailViewController.m
//  DayX
//
//  Created by James Westmoreland on 9/17/14.
//  Copyright (c) 2014 Custom Computers & Consulting. All rights reserved.
//

#import "DXDetailViewController.h"
#import "EntryController.h"

@interface DXDetailViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextView *textNote;
@property (strong, nonatomic) Entry *entry;

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
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// called when clear button pressed. return NO to ignore
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.titleField.text = @"";
    self.textNote.text = @"";
    return YES;
}

- (void)save:(id)sender
{
    Entry *entry = [[Entry alloc] initWithDictionary:@{titleKey: self.titleField.text, textKey: self.textNote.text}];
    if (self.entry) {
        [[EntryController sharedInstance] replaceEntry:self.entry withEntry:entry];
    } else {
        [[EntryController sharedInstance] addEntry:entry];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateWithEntry:(Entry *)entry
{
    self.entry = entry;
    self.titleField.text = entry.title;
    self.textNote.text = entry.text;
}

@end
