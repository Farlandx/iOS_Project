//
//  HistoryTableViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/12.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLSectionHeaderView.h"

@interface HistoryTableViewController : UITableViewController<SectionHeaderViewDelegate>

@property (nonatomic) NSArray *batchAry;

@end
