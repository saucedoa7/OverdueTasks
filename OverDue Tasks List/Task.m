//
//  Task.m
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/26/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import "Task.h"
#import "ViewController.h"

@implementation Task


-(id)init{
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data{

    // initialize the super first aka NSObject
    self = [super init];

    self.title = data[TASK_TITLE];
    self.desc = data[TASK_DESCRIPTION];
    self.date = data[TASK_DATE];
    self.isCompleted = [data[TASK_COMPLETION] boolValue];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    ViewController *vc = [ViewController new];
    [aCoder encodeObject:vc.taskObjects forKey:TASKS];
}

-(Task *)initWithCoder:(NSCoder *)aDecoder{
    ViewController *vc = [ViewController new];
    if (self = [super init]) {
        vc.taskObjects = [aDecoder decodeObjectForKey:TASKS];
    }
    return self;
}
@end
