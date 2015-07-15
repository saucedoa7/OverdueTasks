//
//  DetailTaskViewController.m
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "DetailTaskViewController.h"

@interface DetailTaskViewController () <EditTaskVCDelegate>

@end

@implementation DetailTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd-yy hh:mm"];
    
    self.lblTitle.text = self.task.title;
    self.lblDetails.text = self.task.desc;
    self.lblDate.text = [formatter stringFromDate:self.task.date];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editBarButtonTAsk:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"toEditTaskVC" sender:nil];
    
}

-(void)didUpdateTask{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd-yy"];
    NSString *stringFormat = [formatter stringFromDate:self.task.date];
    
    self.lblTitle.text = self.task.title;
    self.lblDetails.text = self.task.desc;
    self.lblDate.text = stringFormat;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.DetailsTaskdelegate updateTask];
}

//Pass data to another VC via Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[EditTaskViewController class]]) {
        
        EditTaskViewController *editVC = [segue destinationViewController];
        editVC.task = self.task;
        
        editVC.editTaskVCdelegate = self;
    }
}

@end
