//
//  ViewController.m
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"
#import "DetailTaskViewController.h"

#define CELL_ID @"taskCellID"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[AddTaskViewController class]]) {
        //[self performSegueWithIdentifier:@"toAddTaskVC" sender:self];
    } else if ([segue.destinationViewController isKindOfClass:[DetailTaskViewController class]]){
        //[self performSegueWithIdentifier:@"toDetailTaskVC" sender:self];
    }
}

- (IBAction)addTask:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskVC" sender:self];
}
@end
