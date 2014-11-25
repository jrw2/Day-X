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
@property (strong, nonatomic) UILabel *dateCreatedLabel;
@property (strong, nonatomic) UILabel *dateModifiedLabel;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextView *textNote;

@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *dateModified;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (readwrite, nonatomic) BOOL titleDataHasChanged;
@property (readwrite, nonatomic) BOOL noteDataHasChanged;

@property (strong, nonatomic) Entry *entry;

@end

@implementation DXDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.titleDataHasChanged = NO;
    self.noteDataHasChanged = NO;
    
    if (!self.dateFormatter) {
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    }
    
    if (!self.entry) {
        self.dateCreated = [NSDate new];
        self.dateModified = [NSDate new];
    }
    
    self.titleField = [UITextField new];
    [self.titleField setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (self.entry) {
        self.titleField.text = self.entry.title;
    } else {
        self.titleField.text = @"";
        self.titleField.placeholder = @"Enter title here (Required)";
    }
    self.titleField.returnKeyType = UIReturnKeyDone;
    self.titleField.backgroundColor = [UIColor whiteColor];
    self.titleField.delegate = self;
    [self.view addSubview:self.titleField];
    
    self.textNote = [UITextView new];
    [self.textNote setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (self.entry) {
        self.textNote.text = self.entry.text;
    } else {
        self.textNote.text = @"Enter note(s) here.";
    }
    self.textNote.backgroundColor = [UIColor whiteColor];
    self.textNote.delegate = self;
    [self.view addSubview:self.textNote];
    
    self.dateCreatedLabel = [UILabel new];
    self.dateModifiedLabel = [UILabel new];
    [self.dateCreatedLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dateModifiedLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (self.entry) {
        self.dateCreated = self.entry.dateCreated;
        NSString *crDateStr = [self.dateFormatter stringFromDate:self.dateCreated];
        NSString *dateStringCr = [[NSString alloc] initWithFormat:@"Date created: %@", crDateStr];
        self.dateCreatedLabel.text = dateStringCr;
        
        self.dateModified = self.entry.dateModified;
        NSString *moDateStr = [self.dateFormatter stringFromDate:self.dateModified];
        NSString *dateStringMo = [[NSString alloc] initWithFormat:@"Date Modified: %@", moDateStr];
        self.dateModifiedLabel.text = dateStringMo;
    } else {
        self.dateCreatedLabel.text = @"Date Created:";
        self.dateModifiedLabel.text = @"Date Modified:";
    }
    self.dateCreatedLabel.backgroundColor = [UIColor whiteColor];
    self.dateModifiedLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.dateCreatedLabel];
    [self.view addSubview:self.dateModifiedLabel];
    
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(_titleField, _textNote, _dateCreatedLabel, _dateModifiedLabel);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-72-[_titleField(==44)]-[_textNote]-[_dateCreatedLabel(==44)]-[_dateModifiedLabel(==44)]-56-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_titleField]-(margin)-|" options:0 metrics:@{@"margin":@8} views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_textNote]-(margin)-|" options:0 metrics:@{@"margin":@8} views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_dateCreatedLabel]-(margin)-|" options:0 metrics:@{@"margin":@8} views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_dateModifiedLabel]-(margin)-|" options:0 metrics:@{@"margin":@8} views:viewsDictionary]];
    
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"CLEAR" style:UIBarButtonItemStylePlain target:self action:@selector(clear:)];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"DELETE" style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
    
    if (!self.entry) {
        deleteButton.enabled = NO;
    } else {
        clearButton.enabled = NO;
    }
    
    [self setToolbarItems:@[clearButton, spaceItem, deleteButton]];
    
    [self showDoneButton:NO];
}

- (void)showDoneButton:(BOOL)show
{
    if (show) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = doneButton;
    } else {
        if (self.entry) {
            if (!(self.titleDataHasChanged || self.noteDataHasChanged)) {
                self.navigationItem.rightBarButtonItem = nil;
                return;
            }
        } else {
            if (!self.titleDataHasChanged) {
                self.navigationItem.rightBarButtonItem = nil;
                return;
            }
        }
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = saveButton;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self titleFieldValidate];
    
    [self showDoneButton:NO];
    
    return YES;
}

- (void)titleFieldValidate
{
    if (!self.entry) {
        if (self.titleField.text.length > 0) {
            self.titleDataHasChanged = YES;
            
            NSString *crDateStr = [self.dateFormatter stringFromDate:self.dateCreated];
            NSString *dateStringCr = [[NSString alloc] initWithFormat:@"Date Created: %@", crDateStr];
            self.dateCreatedLabel.text = dateStringCr;
            
            NSString *moDateStr = [self.dateFormatter stringFromDate:self.dateModified];
            NSString *dateStringMo = [[NSString alloc] initWithFormat:@"Date Modified: %@", moDateStr];
            self.dateModifiedLabel.text = dateStringMo;
        }
    } else {
        self.titleDataHasChanged  = YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    [self titleFieldValidate];
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.entry) {
        self.textNote.text = @"";
    }
    
    [self showDoneButton:YES];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.entry) {
        self.noteDataHasChanged = YES;
    } else {
        if (textView.text.length == 0) {
            self.textNote.text = @"Enter note(s).";
            self.noteDataHasChanged = NO;
        } else {
            self.noteDataHasChanged = YES;
        }
    }
    
    [self showDoneButton:NO];
    
    return YES;
}

- (void)done:(id *)sender
{
    [self.textNote resignFirstResponder];
    
    [self showDoneButton:NO];
}

- (void)clear:(id *)sender
{
    self.titleField.text = @"";
    self.titleField.placeholder = @"Title";
    self.textNote.text = @"Enter Note(s).";
    self.dateCreatedLabel.text = @"Date Created:";
    self.dateModifiedLabel.text = @"Date Modified:";
    self.dateCreated = [NSDate new];
    self.dateModified = [NSDate new];
    self.titleDataHasChanged = NO;
    self.noteDataHasChanged = NO;
    [self showDoneButton:NO];
}

- (void)delete:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Delete Confirmation"
                              message:@"Delete this entry?"
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[EntryController sharedInstance] removeEntry:self.entry];
        [[EntryController sharedInstance] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)save:(id)sender
{
    if (self.titleDataHasChanged || self.noteDataHasChanged) {
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
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateWithEntry:(Entry *)entry
{
    self.entry = entry;
}

@end