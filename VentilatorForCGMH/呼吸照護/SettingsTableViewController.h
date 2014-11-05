//
//  SettingsTableViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/10/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (nonatomic, retain) NSIndexPath *checkedHospitalIndexPath;
@property (nonatomic, retain) NSIndexPath *checkedCareSortIndexPath;

@end
