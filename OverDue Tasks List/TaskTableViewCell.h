//
//  TaskTableViewCell.h
//  OverDue Tasks List
//
//  Created by Albert Saucedo on 6/25/15.
//  Copyright (c) 2015 Albert Saucedo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
