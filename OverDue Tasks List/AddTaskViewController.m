//
//  AddTaskViewController.m
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"
#import "DetailTaskViewController.h"
#import "Task.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    Task *task = [Task new];
    task = [self returnATask:task];
    [self.delegate didAddTask:task];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
}


#pragma mark Helpers

-(Task *)returnATask:(Task *)task{

    /*
     NSDate *date = self.date.date;
     NSDateFormatter *formatter = [NSDateFormatter new];
     [formatter setDateFormat:@"MM-dd-yy hh:mm:ss"];
     NSString *dateFormat = [formatter stringFromDate:date];
     */

    task.title = self.txtTaskName.text;
    task.desc = self.txtTaskDesc.text;
    task.date = self.date.date;

    task.completion = NO;

    return task;
}
@end
