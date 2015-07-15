//
//  EditTaskViewController.m
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"
#import "DetailTaskViewController.h"

@interface EditTaskViewController ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtTitle.text = self.task.title;
    self.txtDesc.text = self.task.desc;
    self.datePicker.date = self.task.date;
    
    self.txtTitle.delegate = self;
    self.txtDesc.delegate = self;
}

- (IBAction)saveUpdatedTask:(UIBarButtonItem *)sender {
    [self updateTask];
    //D
    [self.editTaskVCdelegate didUpdateTask];
}

//C
-(void)updateTask{
    self.task.title = self.txtTitle.text;
    self.task.desc = self.txtDesc.text;
    self.task.date = self.datePicker.date;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtTitle resignFirstResponder];
    [self.txtDesc resignFirstResponder];
    
    return YES;
}

@end
