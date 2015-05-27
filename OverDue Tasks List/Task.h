//
//  Task.h
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 5/26/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSDate *date;
@property  BOOL completion;

-(id)initWithData:(NSDictionary *)data;

@end

