//
//  HistoryTableViewCell.h
//  呼吸照護
//
//  Created by Farland on 2014/5/12.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ChtNo;
@property (strong, nonatomic) IBOutlet UILabel *RecordOper;
@property (strong, nonatomic) IBOutlet UILabel *RecordTime;
@property (strong, nonatomic) IBOutlet UILabel *VentilationMode;

@end
