//
//  EditTaskViewController.h
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

//A
@protocol EditTaskVCDelegate <NSObject>

-(void)didUpdateTask;

@end

@interface EditTaskViewController : UIViewController
//B
@property (strong,nonatomic) id <EditTaskVCDelegate> editTaskVCdelegate;

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
