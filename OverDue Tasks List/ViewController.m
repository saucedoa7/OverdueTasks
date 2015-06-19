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

@interface ViewController () <AddTaskDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    NSLog(@"Loaded Data %@", self.taskObjects);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCellID" forIndexPath:indexPath];

    Task *task = [self.taskObjects objectAtIndex:indexPath.row];

    NSLog(@"Current Task Being Loaded %@", task);

    cell.textLabel.text = task.title;
    //cell.detailTextLabel.text = task.desc;

    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskObjects.count;
}

-(void)didAddTask:(Task *)task{ //A
    if (!self.taskObjects) self.taskObjects = [NSMutableArray new];
    NSLog(@"Dat Dictionary %@", task);

    [self.taskObjects addObject:task];
    NSLog(@"taskObjects %@", self.taskObjects);

    NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKS] mutableCopy];

    if (!tasksAsPropertyLists) tasksAsPropertyLists = [NSMutableArray new];

    [tasksAsPropertyLists addObject: [self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:TASKS];
    [[NSUserDefaults standardUserDefaults] synchronize];

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

-(void)saveData{ //C

    Task *task = [Task new];
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