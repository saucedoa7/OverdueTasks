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


    NSArray *taskAsPropList = [[NSUserDefaults standardUserDefaults] arrayForKey:TASKS];

    for (NSDictionary * dic in taskAsPropList) {
        Task *task = [self taskObjectForDic:dic];
        [self.taskObjects addObject:task];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    animated = YES;

    [self loadData];

    NSLog(@"Loaded Data %@", self.taskObjects);
}

-(void)didCancel{

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)didAddTask:(Task *)task{ //1
    if (!self.taskObjects) {
        self.taskObjects = [NSMutableArray new];
    }

    //[self taskObjectAsAPropertyList:task]; //2
    NSLog(@"Dat Dictionary %@", task);

    [self.taskObjects addObject:task];
    NSLog(@"taskObjects %@", self.taskObjects);

    [self saveData]; //3

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(Task *)taskObjectForDic:(NSDictionary *)dic{
    Task *task = [[Task alloc] initWithData:dic];
    return task;
}

-(NSDictionary *)taskObjectAsAPropertyList:(Task *)taskObject{ //2

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



-(void)saveData{ //3
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"taskObjects %@", self.taskObjects);

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.taskObjects];
    [userDefaults setObject:data forKey:TASKS];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:TASKS];

    [userDefaults synchronize];
}

-(void)loadData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *arrayData = [userDefaults objectForKey:TASKS];
    NSMutableArray *retrievedArray = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];

    self.taskObjects = [[NSMutableArray alloc] initWithArray:retrievedArray];
}
@end
