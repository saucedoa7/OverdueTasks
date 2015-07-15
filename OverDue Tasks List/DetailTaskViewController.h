//
//  DetailTaskViewController.h
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTaskViewController.h"
#import "Task.h"

@protocol DetailsTaskVCDelegate <NSObject>

-(void)updateTask;

@end

@interface DetailTaskViewController : UIViewController

@property (weak, nonatomic) id <DetailsTaskVCDelegate> DetailsTaskdelegate;

@property (strong, nonatomic) Task *task;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
