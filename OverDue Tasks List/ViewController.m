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
#import "Task.h"

#define CELL_ID @"taskCellID"

@interface ViewController () <AddTaskDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)didCancel{

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)didAddTask:(Task *)task{
    if (!self.taskObjects) {
        self.taskObjects = [NSMutableArray new];
    }

    [self taskObjectAsAPropertyList:task];

    NSLog(@"Dat Dictionary %@", task);

    [self.taskObjects addObject:task];
    NSLog(@"taskObjects %@", self.taskObjects);

    //[self saveData];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSDictionary *)taskObjectAsAPropertyList:(Task *)taskObject{

    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title,
                                 TASK_DESCRIPTION : taskObject.desc,
                                 TASK_DATE : taskObject.date,
                                 TASK_COMPLETION : [NSNumber numberWithBool: taskObject.completion],
                                 };
    return dictionary;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.destinationViewController isKindOfClass:[AddTaskViewController class]]) {
        //[self performSegueWithIdentifier:@"toAddTaskVC" sender:self];

        AddTaskViewController *addTaskVC = [segue destinationViewController];
        addTaskVC.delegate = self;
    } else if ([segue.destinationViewController isKindOfClass:[DetailTaskViewController class]]){
        //[self performSegueWithIdentifier:@"toDetailTaskVC" sender:self];
    }
}

- (IBAction)addTask:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskVC" sender:self];
}

-(void)saveData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"taskObjects %@", self.taskObjects);

    NSData *data = [NSData new];

    data = [NSKeyedArchiver archivedDataWithRootObject:self.taskObjects];
    [userDefaults setObject:data forKey:TASKS];

    [userDefaults synchronize];
}

-(void)loadData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    self.taskObjects = [userDefaults objectForKey:TASKS];
}
@end
