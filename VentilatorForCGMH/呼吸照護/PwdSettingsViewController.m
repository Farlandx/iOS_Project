//
//  PwdSettingsViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/11/17.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "PwdSettingsViewController.h"

#define MSG_PWD_ENTER @"請輸入管理員密碼"
#define MSG_PWD_ENTER_OLD @"請輸入舊管理員密碼"
#define MSG_PWD_CONFIRM @"請重新輸入管理員密碼"
#define ERR_MSG_PWD_CONFIRM @"密碼不符。請再試一次。"
#define ERR_MSG_PWD_INVALID @"密碼錯誤"

#define PWD_CHAR_HAS_VALUE @"●"
#define PWD_CHAR_NO_VALUE @"–"

@interface PwdSettingsViewController ()

@end

@implementation PwdSettingsViewController {
    NSString *pwd;
    NSString *enterPwd;
    NSString *enterConfirmPwd;
    PwdSettingType pType;
}

@synthesize plManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.3];
//    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)dealloc {
    _delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    enterPwd = @"";
    enterConfirmPwd = @"";
    _lblErrMsg.text = @"";
    
    pwd = [plManager getAdminPwd];
    
    [self resetLabelPwd];
    
    if (pwd.length) {
        switch (pType) {
            case PWD_NEW:
            case PWD_CONFIRM:
                _lblMsg.text = MSG_PWD_ENTER;
                break;
                
            case PWD_MODIFY:
                _lblMsg.text = MSG_PWD_ENTER_OLD;
                break;
                
            default:
                break;
        }
    }
    else {
        //新增密碼
        pType = PWD_NEW;
        _lblMsg.text = MSG_PWD_ENTER;
    }
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)showAnimate
{
//    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
//        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)resetLabelPwd {
    _lblPwd1.text = PWD_CHAR_NO_VALUE;
    _lblPwd2.text = PWD_CHAR_NO_VALUE;
    _lblPwd3.text = PWD_CHAR_NO_VALUE;
    _lblPwd4.text = PWD_CHAR_NO_VALUE;
}

- (void)confirmPwd {
    switch (pType) {
        case PWD_NEW: {
            break;
        }
            
        case PWD_MODIFY:
            _lblMsg.text = MSG_PWD_CONFIRM;
            break;
            
        case PWD_CONFIRM:
            _lblMsg.text = MSG_PWD_ENTER_OLD;
            break;
            
        default:
            break;
    }
}

- (void)checkEnterPwd:(NSInteger)p {
    switch (enterPwd.length) {
        case 0: {
            enterPwd = [enterPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd1.text = PWD_CHAR_HAS_VALUE;
            break;
        }
            
        case 1: {
            enterPwd = [enterPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd2.text = PWD_CHAR_HAS_VALUE;
            break;
        }
            
        case 2: {
            enterPwd = [enterPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd3.text = PWD_CHAR_HAS_VALUE;
            break;
        }
            
        case 3: {
            enterPwd = [enterPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd4.text = PWD_CHAR_HAS_VALUE;
            _lblErrMsg.text = @"";
            if (pType == PWD_NEW) {
                [self resetLabelPwd];
                _lblMsg.text = MSG_PWD_CONFIRM;
            }
            else {
                //密碼正確
                if ([enterPwd isEqualToString:pwd]) {
                    if (pType == PWD_MODIFY) {
                        pType = PWD_NEW;
                        _lblMsg.text = MSG_PWD_ENTER;
                        enterPwd = @"";
                        
                        [self resetLabelPwd];
                    }
                    else {
                        [_delegate PwdValid];
                        [self removeAnimate];
                    }
                }
                else {
                    //密碼錯誤
                    _lblErrMsg.text = ERR_MSG_PWD_INVALID;
                    enterPwd = @"";
                    [self resetLabelPwd];
                }
            }
            break;
        }
            
        default:
            switch (pType) {
                case PWD_NEW:
                case PWD_MODIFY:
                    [self enterConfirmPwd:p];
                    break;
                    
                default:
                    break;
            }
            break;
    }
}

- (void)enterConfirmPwd:(NSInteger)p {
    switch (enterConfirmPwd.length) {
        case 0: {
            enterConfirmPwd = [enterConfirmPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd1.text = PWD_CHAR_HAS_VALUE;
            break;
        }
            
        case 1: {
            enterConfirmPwd = [enterConfirmPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd2.text = PWD_CHAR_HAS_VALUE;
            break;
        }
            
        case 2: {
            enterConfirmPwd = [enterConfirmPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd3.text = PWD_CHAR_HAS_VALUE;
            break;
        }
            
        case 3: {
            enterConfirmPwd = [enterConfirmPwd stringByAppendingString:[NSString stringWithFormat:@"%ld", p]];
            _lblPwd4.text = PWD_CHAR_HAS_VALUE;
            
            //因為只有新增和輸入會到這裡，所以確定兩次輸入相同就儲存起來
            if ([enterPwd isEqualToString:enterConfirmPwd]) {
                NSLog(@"Save Pwd");
                [plManager writeByKey:@"AdminPwd" value:enterPwd];
                [self removeAnimate];
            }
            else {
                if (pType == PWD_MODIFY) {
                    _lblMsg.text = MSG_PWD_ENTER_OLD;
                }
                else {
                    _lblMsg.text = MSG_PWD_ENTER;
                }
                _lblErrMsg.text = ERR_MSG_PWD_CONFIRM;
                enterPwd = @"";
                enterConfirmPwd = @"";
                [self resetLabelPwd];
            }
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

- (IBAction)touchDown:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag < 10) {
        [btn setBackgroundColor:[UIColor colorWithRed:215.0f / 255.0f green:215.0f / 255.0f blue:215.0f / 255.0f alpha:1.0f]];
    }
    else {
        //重新輸入
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    
}

- (IBAction)touchEnd:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag < 10) {
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        //重新輸入
        [btn setBackgroundColor:[UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f]];
    }
}

- (IBAction)touchUpInside:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag < 10) {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [self checkEnterPwd:btn.tag];
    }
    else {
        [btn setBackgroundColor:[UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f]];
        if (enterPwd.length < 4) {
            switch (pType) {
                case PWD_NEW:
                    _lblMsg.text = MSG_PWD_ENTER;
                    break;
                    
                case PWD_MODIFY:
                    _lblMsg.text = MSG_PWD_CONFIRM;
                    break;
                    
                case PWD_CONFIRM:
                    _lblMsg.text = MSG_PWD_ENTER_OLD;
                    break;
                    
                default:
                    break;
            }
            
            enterPwd = @"";
        }
        else {
            enterConfirmPwd = @"";
        }
        [self resetLabelPwd];
    }
}

#pragma mark - Public Method
- (void)showInView:(UIView *)aView animated:(BOOL)animated pwdType:(PwdSettingType)pwdType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        pType = pwdType;
        
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

@end
