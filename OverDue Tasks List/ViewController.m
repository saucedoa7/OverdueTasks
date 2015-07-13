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
    
    [self loadData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    NSLog(@"Loaded Data %@", self.taskObjects);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    Task *task = self.taskObjects [indexPath.row];


    if (task.isCompleted) {
        cell.backgroundColor = [UIColor greenColor];
    }

    NSLog(@"Current Task Being Loaded %@", task);
    
    NSDate *date = task.date;
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd-yy"];
    NSString *dateFormat = [formatter stringFromDate:date];
    
    NSLog(@"Current Task Date Being Loaded %@", task.date);
    
    BOOL isOverDue = [self isTaskDateGreaterThanTodaysDate:date and:currentDate];
    
    cell.lblTitle.text = task.title;
    cell.lblDetails.text = task.desc;
    cell.lblDate.text = dateFormat;
    
    if (isOverDue) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Task *task = self.taskObjects [indexPath.row];
    
    [self updateCompletionOfTask:task forIndex:indexPath];

    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *updatedTasks = [NSMutableArray new];
        
        for (Task *task in self.taskObjects) {
            [updatedTasks addObject:[self taskObjectAsAPropertyList:task]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:updatedTasks forKey:TASKS_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void)updateCompletionOfTask:(Task *)task forIndex:(NSIndexPath *)indexPath{
    
    
    //1
    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS_ARRAY] mutableCopy];
    NSLog(@"Tapped array %@", tasksAsPropertyLists);
    
    if (!tasksAsPropertyLists) tasksAsPropertyLists = [NSMutableArray new];
    
    //2
    [tasksAsPropertyLists removeObjectAtIndex:indexPath.row];

    for (Task *task in self.taskObjects) {
        [tasksAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    }
    
    //3
    task.isCompleted = YES;
    
    //4 & 5
    [self.taskObjects insertObject: [self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
    
    //6
    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //7
    [self.tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskObjects.count;
}

-(void)didAddTask:(Task *)task{ //A
    //if (!self.taskObjects) self.taskObjects = [NSMutableArray new];

    [self.taskObjects addObject:task];
    
    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS_ARRAY] mutableCopy];
    
    if (!tasksAsPropertyLists) tasksAsPropertyLists = [NSMutableArray new];
    
    [tasksAsPropertyLists addObject: [self taskObjectAsAPropertyList:task]];

    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:tasksAsPropertyLists.count];

    for (Task *task in tasksAsPropertyLists) {
        NSData *taskEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:task];
        [archiveArray addObject:taskEncodedObject];
    }

    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];


}


-(void)didCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSDictionary *)taskObjectAsAPropertyList:(Task *)taskObject{ //B
    
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title,
                                 TASK_DESCRIPTION : taskObject.desc,
                                 TASK_DATE : taskObject.date,
                                 TASK_COMPLETION : @(taskObject.isCompleted),
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

-(Task *)taskObjectForDic:(NSDictionary *)dic{
    Task *task = [[Task alloc] initWithData:dic];
    return task;
}

/*
-(void)saveData{ //C
    
    Task *task = [Task new];
    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS_ARRAY] mutableCopy];
    
    if (!tasksAsPropertyLists) tasksAsPropertyLists = [NSMutableArray new];
    
    [tasksAsPropertyLists addObject: [self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"taskObjects %@", self.taskObjects);
}
*/

-(void)loadData{
    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:TASKS_ARRAY];
    
    for (NSDictionary * dic in tasksAsPropertyLists) {
        Task *task = [self taskObjectForDic:dic];
        [self.taskObjects addObject:task];
    }
    
}
@end