//
//  SettingsTableViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *cellServer;
@property (strong, nonatomic) IBOutlet UILabel *labelServer;

@property (strong, nonatomic) IBOutlet UIImageView *imgCheckbox;

@property (strong, nonatomic) IBOutlet UILabel *labelVersion;

@end
