//
//  MainViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/12.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PListManager.h"

@interface MainViewController : UITabBarController

@property (strong, nonatomic)NSMutableArray *historyList;

- (void)refreshHistoryList;
- (PListManager *)getPListManager;

@end
