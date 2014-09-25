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

@property (strong, nonatomic) UILabel *dateInformation;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UITextView *textNote;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSDate *modificationDate;
@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DXDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.dateFormatter) {
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    }
    if (!self.creationDate) {
        self.creationDate = [NSDate date];
    }
    if (!self.modificationDate) {
        self.modificationDate = [NSDate date];
    }
    
    self.dateInformation = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 10, 44)];
    NSString *crDateStr = [self.dateFormatter stringFromDate:self.creationDate];
    NSString *moDateStr = [self.dateFormatter stringFromDate:self.modificationDate];
    NSString *dateString = [[NSString alloc] initWithFormat:@"Date created: %@    Date Modified: %@", crDateStr, moDateStr];
    self.dateInformation.text = dateString;
    [self.view addSubview:self.dateInformation];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 125, self.view.frame.size.width - 90, 64)];
    if (!self.titleField.text) {
        self.titleField.text = @"";
    }
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, 125, 64, 64)];
    [self.clearButton setTitle:@"Clear Fields" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    self.textNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 10, self.view.frame.size.height - 200)];
    if (!self.textNote.text) {
        self.textNote.text = @"";
    }
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
- (void)clear:(id *)sender
{
    self.titleField.text = @"";
    self.textNote.text = @"";
    self.creationDate = [NSDate new];
    self.modificationDate = [NSDate new];
}

- (void)save:(id)sender
{
    self.modificationDate = [NSDate new];
    Entry *entry = [[Entry alloc] initWithDictionary:@{titleKey: self.titleField.text, textKey: self.textNote.text, createdTimestampKey: self.creationDate, modifiedTimestampKey: self.modificationDate}];
    if ( self.entry) {
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
    self.creationDate = entry.createdTimestamp;
    self.modificationDate = entry.modifiedTimestamp;
}

@end
