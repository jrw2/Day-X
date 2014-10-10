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
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DXDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    if (!self.dateFormatter) {
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    }
    
    if (!self.entry) {
        self.dateCreated = [NSDate date];
        self.dateModified = [NSDate date];
    } else {
        self.dateCreated = self.entry.dateCreated;
        self.dateModified = self.entry.dateModified;
    }
    
    self.dateInformation = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 10, 44)];
    NSString *crDateStr = [self.dateFormatter stringFromDate:self.dateCreated];
    NSString *moDateStr = [self.dateFormatter stringFromDate:self.dateModified];
    NSString *dateString = [[NSString alloc] initWithFormat:@"Date created: %@    Date Modified: %@", crDateStr, moDateStr];
    self.dateInformation.text = dateString;
    [self.view addSubview:self.dateInformation];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 125, self.view.frame.size.width - 100, 64)];
    if (!self.entry) {
        self.titleField.text = @"";
    } else {
        self.titleField.text = self.entry.title;
    }
    self.titleField.backgroundColor = [UIColor whiteColor];
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 85, 125, 64, 64)];
    [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    self.textNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, self.view.frame.size.height - 220)];
    if (!self.entry) {
        self.textNote.text = @"";
    } else {
        self.textNote.text = self.entry.text;
    }
    self.textNote.backgroundColor = [UIColor whiteColor];
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

// called when clear button pressed.
- (void)clear:(id *)sender
{
    self.titleField.text = @"";
    self.textNote.text = @"";
    self.dateCreated = [NSDate new];
    self.dateModified = [NSDate new];
}

- (void)save:(id)sender
{
    self.dateModified = [NSDate new];
    if (self.entry) {
        self.entry.title = self.titleField.text;
        self.entry.text = self.textNote.text;
        self.entry.dateCreated = self.dateCreated;
        self.entry.dateModified = self.dateModified;
        [[EntryController sharedInstance] synchronize];
    } else {
        [[EntryController sharedInstance] addEntryWithTitle:self.titleField.text text:self.textNote.text dateCreated:self.dateCreated dateModified:self.dateModified];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateWithEntry:(Entry *)entry
{
    self.entry = entry;
}

@end
