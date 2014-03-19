//
//  MeasureTabBarViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureData.h"

@interface MeasureTabBarViewController : UITabBarController

@property (strong, nonatomic) MeasureData *measureData;



#pragma mark - Methods
- (void)setMeasureData:(MeasureData *)measureData;

#pragma mark - Bar Button Item
- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;

@end
