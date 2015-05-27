//
//  Task.m
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/26/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import "Task.h"

@implementation Task


-(id)init{
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data{

    self = [super init];

    self.title = data[TASK_TITLE];
    self.desc = data[TASK_DESCRIPTION];
    self.date = data[TASK_DATE];
    self.completion = [data[TASK_COMPLETION] boolValue];

    return self;
}
@end
