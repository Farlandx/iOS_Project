//
//  OtherDataViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreathSoundTableViewController.h"

@interface OtherDataViewController : UIViewController<BreathSoundTableViewDelegate> {
    NSArray *pickerArray;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *BreathSounds;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
#pragma mark - 其他資料
@property (strong, nonatomic) IBOutlet UIButton *btnBreathSound;

@end
