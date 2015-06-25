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
#import "TaskTableViewCell.h"

#define CELL_ID @"taskCellID"

@interface ViewController () <AddTaskDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    [self loadData];


    NSLog(@"%lu total Task Objects\n", (unsigned long)[self.taskObjects count]);

    NSLog(@"Loaded Data %@", self.taskObjects);


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCellID" forIndexPath:indexPath];

    Task *task = [self.taskObjects objectAtIndex:indexPath.row];

    NSLog(@"Current Task Being Loaded %@", task);

    NSDate *date = task.date;
    NSDate *currentDate = [NSDate date];

    BOOL isOverDue = [self isTaskDateGreaterThanTodaysDate:date and:currentDate];

    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd-yy"];
    NSString *dateFormat = [formatter stringFromDate:date];

    cell.lblTitle.text = task.title;
    cell.lblDetails.text = task.desc;
    cell.lblDate.text = dateFormat;

    if (isOverDue) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }

    if (task.isCompleted) {
        cell.backgroundColor = [UIColor greenColor];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //1
    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS] mutableCopy];
    NSLog(@"Tapped array %@", tasksAsPropertyLists);

    //2
    Task *task = [self.taskObjects objectAtIndex:indexPath.row];
    NSLog(@"Tapped Cell %@", task);
    [self.taskObjects removeObject:task];

    //3
    task.isCompleted = YES;

    //4
    //[tasksAsPropertyLists addObject: [self taskObjectAsAPropertyList:task]];

    //5
    [self.taskObjects insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];

    //6
    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //7
    [self.tableView reloadData];

    NSLog(@"Tapped array %@", tasksAsPropertyLists);
    NSLog(@"Loaded Data %@", self.taskObjects);

}


-(BOOL)isTaskDateGreaterThanTodaysDate:(NSDate *)taskDate and:(NSDate *)todaysDate{

    NSTimeInterval taskDateSec = [taskDate timeIntervalSince1970]/100000;
    NSTimeInterval todaysDateSec = [todaysDate timeIntervalSince1970]/100000;

    NSLog(@"Task Date %.4f and Todays Date %.4f", taskDateSec, todaysDateSec);

    if (taskDateSec < todaysDateSec) {
        return YES;
    } else {
        return NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskObjects.count;
}

-(void)didAddTask:(Task *)task{ //A

    //    if (!self.taskObjects) self.taskObjects = [NSMutableArray new];
//    NSLog(@"Dat Dictionary %@", task);
//
//    [self.taskObjects addObject:task];
//    NSLog(@"taskObjects %@", self.taskObjects);

//    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS] mutableCopy];
//
//    if (!tasksAsPropertyLists) tasksAsPropertyLists = [NSMutableArray new];
//
//    [tasksAsPropertyLists addObject: [self taskObjectAsAPropertyList:task]];
//    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS];
//    [[NSUserDefaults standardUserDefaults] synchronize];


    [self saveTask:task];

    NSLog(@"taskObjects %@", self.taskObjects);

    [self dismissViewControllerAnimated:YES completion:nil];

    [self.tableView reloadData];
}

-(void)didCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(Task *)taskObjectForDic:(NSDictionary *)dic{
    Task *task = [[Task alloc] initWithData:dic];
    return task;
}

-(NSDictionary *)taskObjectAsAPropertyList:(Task *)taskObject{ //B

    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title,
                                 TASK_DESCRIPTION : taskObject.desc,
                                 TASK_DATE : taskObject.date,
                                 TASK_COMPLETION : [NSNumber numberWithBool: taskObject.isCompleted],
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

-(NSMutableArray *)taskObjects{
    if (!_taskObjects) _taskObjects = [NSMutableArray new];
    return _taskObjects;
}

-(void)saveTask:(Task *)task{ //C

    if (!self.taskObjects) self.taskObjects = [NSMutableArray new];
    NSLog(@"Dat Dictionary %@", task);

    //[self.taskObjects addObject:task];
    NSLog(@"taskObjects %@", self.taskObjects);

    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS] mutableCopy];

    if (!tasksAsPropertyLists) tasksAsPropertyLists = [NSMutableArray new];

    [tasksAsPropertyLists addObject: [self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSLog(@"taskObjects %@", self.taskObjects);

}

-(void)loadData{
    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:TASKS];

    for (NSDictionary * dic in tasksAsPropertyLists) {
        Task *task = [self taskObjectForDic:dic];
        [self.taskObjects addObject:task];
    }
}
@end