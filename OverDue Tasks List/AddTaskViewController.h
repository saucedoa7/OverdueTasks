//
//  AddTaskViewController.h
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol AddTaskDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(Task *)task;

@end

@interface AddTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtTaskName;
@property (strong, nonatomic) IBOutlet UITextView *txtTaskDesc;
@property (strong, nonatomic) IBOutlet UIDatePicker *date;


- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@property (weak, nonatomic) id <AddTaskDelegate> delegate;

@end
