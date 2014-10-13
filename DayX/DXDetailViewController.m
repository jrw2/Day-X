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

// Screen controls
@property (strong, nonatomic) UILabel *dateInformation;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextView *textNote;
@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *deleteButton;

@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (readwrite, nonatomic) BOOL dataHasChanged;

@property (strong, nonatomic) Entry *entry;

@end

@implementation DXDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.dataHasChanged = NO;
    
    if (!self.dateFormatter) {
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    }
    
    if (!self.entry) {
        self.dateCreated = [NSDate new];
        self.dateModified = [NSDate new];
    }
    
    self.dateInformation = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, self.view.frame.size.width - 20, 44)];
    if (self.entry) {
        self.dateCreated = self.entry.dateCreated;
        self.dateModified = self.entry.dateModified;
        NSString *crDateStr = [self.dateFormatter stringFromDate:self.dateCreated];
        NSString *moDateStr = [self.dateFormatter stringFromDate:self.dateModified];
        NSString *dateString = [[NSString alloc] initWithFormat:@"Date created: %@    Date Modified: %@", crDateStr, moDateStr];
        self.dateInformation.text = dateString;
    } else {
        self.dateInformation.text = @"";
    }
    self.dateInformation.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.dateInformation];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width - 20, 64)];
    if (self.entry) {
        self.titleField.text = self.entry.title;
    } else {
        self.titleField.text = @"";
    }
    self.titleField.backgroundColor = [UIColor whiteColor];
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    self.textNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, self.view.frame.size.height - 300)];
    if (self.entry) {
        self.textNote.text = self.entry.text;
    } else {
        self.textNote.text = @"";
    }
    self.textNote.backgroundColor = [UIColor whiteColor];
    self.textNote.delegate = self;
    [self.view addSubview:self.textNote];
    
    if (!self.entry) {
        self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, self.view.frame.size.height - 75, 64, 64)];
        [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.clearButton];
    } else {
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, self.view.frame.size.height - 75, 64, 64)];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deleteButton];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.dataHasChanged = YES;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (!self.entry) {
        NSString *crDateStr = [self.dateFormatter stringFromDate:self.dateCreated];
        NSString *moDateStr = [self.dateFormatter stringFromDate:self.dateModified];
        NSString *dateString = [[NSString alloc] initWithFormat:@"Date created: %@    Date Modified: %@", crDateStr, moDateStr];
        self.dateInformation.text = dateString;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.entry) {
        self.dataHasChanged = YES;
    }

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    return YES;
}

- (void)done:(id *)sender
{
    [self.textNote resignFirstResponder];
}

- (void)clear:(id *)sender
{
    if (!self.entry) {
        self.titleField.text = @"";
        self.textNote.text = @"";
        self.dateCreated = [NSDate new];
        self.dateModified = [NSDate new];
    }
}

- (void)delete:(id)sender
{
    if (self.entry) {
        [[EntryController sharedInstance] removeEntry:self.entry];
        [[EntryController sharedInstance] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
