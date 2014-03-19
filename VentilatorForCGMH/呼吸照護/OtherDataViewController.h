//
//  OtherDataViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreathSoundTableViewController.h"
#import "MeasureData.h"
#import "DisplayView.h"

@interface OtherDataViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, BreathSoundTableViewDelegate, DisplayViewDelegate> {
    CGRect rect;
    BOOL heightChanged;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet DisplayView *displayView;
@property (strong, nonatomic) IBOutlet UIButton *btnBreathSound;

#pragma mark - 其他資料
@property (strong, nonatomic) NSString *BreathSounds;
@property (strong, nonatomic) IBOutlet UITextField *PetCo2;
@property (strong, nonatomic) IBOutlet UITextField *SpO2;
@property (strong, nonatomic) IBOutlet UITextField *RR;
@property (strong, nonatomic) IBOutlet UITextField *TV;
@property (strong, nonatomic) IBOutlet UITextField *MV;
@property (strong, nonatomic) IBOutlet UITextField *MaxPi;
@property (strong, nonatomic) IBOutlet UITextField *Mvv;
@property (strong, nonatomic) IBOutlet UITextField *Rsbi;
@property (strong, nonatomic) IBOutlet UITextField *EtSize;
@property (strong, nonatomic) IBOutlet UITextField *Mark;
@property (strong, nonatomic) IBOutlet UITextField *CuffPressure;
@property (strong, nonatomic) IBOutlet UITextField *Pr;
@property (strong, nonatomic) IBOutlet UITextField *Cvp;
@property (strong, nonatomic) IBOutlet UITextField *BpS;
@property (strong, nonatomic) IBOutlet UITextField *BpD;
@property (strong, nonatomic) IBOutlet UITextView *Xrem;

#pragma mark - Method
- (void)getMeasureData:(MeasureData *)measureData;

@end
