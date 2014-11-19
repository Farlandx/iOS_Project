//
//  PwdSettingsViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/11/17.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PListManager.h"

@protocol PwdSettingDelegate <NSObject>

@required
- (void)PwdValid;

@end

typedef NS_ENUM(NSUInteger, PwdSettingType) {
    PWD_NEW = 0,
    PWD_MODIFY,
    PWD_CONFIRM
};

@interface PwdSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblErrMsg;

@property (weak, nonatomic) PListManager *plManager;
@property (assign, nonatomic) id<PwdSettingDelegate> delegate;

#pragma mark - Password Label
@property (weak, nonatomic) IBOutlet UILabel *lblPwd1;
@property (weak, nonatomic) IBOutlet UILabel *lblPwd2;
@property (weak, nonatomic) IBOutlet UILabel *lblPwd3;
@property (weak, nonatomic) IBOutlet UILabel *lblPwd4;

#pragma mark - Number Pad
@property (weak, nonatomic) IBOutlet UIButton *btnNum0;
@property (weak, nonatomic) IBOutlet UIButton *btnNum1;
@property (weak, nonatomic) IBOutlet UIButton *btnNum2;
@property (weak, nonatomic) IBOutlet UIButton *btnNum3;
@property (weak, nonatomic) IBOutlet UIButton *btnNum4;
@property (weak, nonatomic) IBOutlet UIButton *btnNum5;
@property (weak, nonatomic) IBOutlet UIButton *btnNum6;
@property (weak, nonatomic) IBOutlet UIButton *btnNum7;
@property (weak, nonatomic) IBOutlet UIButton *btnNum8;
@property (weak, nonatomic) IBOutlet UIButton *btnNum9;
@property (weak, nonatomic) IBOutlet UIButton *btnBackspace;

#pragma mark - Method
- (void)showInView:(UIView *)aView animated:(BOOL)animated pwdType:(PwdSettingType)pwdType;

@end
