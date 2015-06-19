//
//  ViewController.h
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)addTask:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *taskObjects;

@end

