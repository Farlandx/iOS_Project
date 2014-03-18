//
//  OtherDataViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreathSoundTableViewController.h"
#import "DisplayView.h"

@interface OtherDataViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, BreathSoundTableViewDelegate, DisplayViewDelegate> {
    CGRect rect;
    BOOL heightChanged;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *BreathSounds;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet DisplayView *displayView;

#pragma mark - 其他資料
@property (strong, nonatomic) IBOutlet UIButton *btnBreathSound;

@end
