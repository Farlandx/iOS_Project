//
//  OtherDataViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreathSoundTableViewController.h"
#import "VentilationData.h"
#import "DisplayView.h"

@interface OtherDataViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, BreathSoundTableViewDelegate, DisplayViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet DisplayView *displayView;
@property (nonatomic) BOOL viewMode;

#pragma mark - 其他資料
@property (strong, nonatomic) NSString *BreathSounds;
//動脈血氧分析
@property (strong, nonatomic) IBOutlet UITextField *PetCo2;
@property (strong, nonatomic) IBOutlet UITextField *SpO2;

//呼吸器及氣道狀況監視
@property (strong, nonatomic) IBOutlet UITextField *RR;
@property (strong, nonatomic) IBOutlet UITextField *TV;
@property (strong, nonatomic) IBOutlet UITextField *MV;
@property (strong, nonatomic) IBOutlet UITextField *MaxPi;
@property (strong, nonatomic) IBOutlet UITextField *Mvv;
@property (strong, nonatomic) IBOutlet UITextField *Rsbi;
@property (strong, nonatomic) IBOutlet UITextField *EtSize;
@property (strong, nonatomic) IBOutlet UITextField *Mark;
@property (strong, nonatomic) IBOutlet UITextField *CuffPressure;
@property (strong, nonatomic) IBOutlet UIButton *btnBreathSound;

//血型力學
@property (strong, nonatomic) IBOutlet UITextField *Pr;
@property (strong, nonatomic) IBOutlet UITextField *Cvp;
@property (strong, nonatomic) IBOutlet UITextField *BpS;
@property (strong, nonatomic) IBOutlet UITextField *BpD;

//備註
@property (strong, nonatomic) IBOutlet UITextView *Xrem;

#pragma mark - 20140902新增欄位
@property (strong, nonatomic) IBOutlet UITextField *LeakTest;//Cuff Leak Test,XXXXX

#pragma mark - 20141023新增欄位
@property (strong, nonatomic) IBOutlet UITextField *MaxPe;
@property (strong, nonatomic) IBOutlet UITextField *VC;

#pragma mark - Method
- (void)getMeasureData:(VentilationData *)measureData;

@end
