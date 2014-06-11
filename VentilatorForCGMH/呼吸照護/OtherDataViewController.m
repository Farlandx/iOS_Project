//
//  OtherDataViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "OtherDataViewController.h"
#import "MeasureTabBarViewController.h"
#import "MeasureViewController.h"

@interface OtherDataViewController ()

@end

@implementation OtherDataViewController {
    VentilationData *data;
    CGPoint svos;
    CGRect textRect;
}

@synthesize viewMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _displayView.delegate = self;
    
    if (viewMode) {
        for(UIView *v in _displayView.subviews) {
            if ([v isKindOfClass:[UITextField class]]) {
                ((UITextField *)v).enabled = NO;
            }
            else if ([v isKindOfClass:[UITextView class]]) {
                ((UITextView *)v).editable = NO;
            }
        }
    }
    else {
        for (UIView *v in [_displayView subviews]) {
            if ([v isKindOfClass:[UITextField class]]) {
                UITextField *txtField = (UITextField *)v;
                if (txtField.tag == 1) {
                    txtField.keyboardType = UIKeyboardTypeDefault;
                }
                else {
                    txtField.keyboardType = UIKeyboardTypeDecimalPad;
                }
                txtField.delegate = self;
            }
        }
    }
    
    svos = _scrollView.contentOffset;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_Xrem.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5f] CGColor]];
    [_Xrem.layer setBorderWidth:0.5f];
    [_Xrem.layer setCornerRadius:5.0f];
    _Xrem.delegate = self;
    
    _btnBreathSound.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if (data.BreathSounds != nil && ![data.BreathSounds isEqualToString:@""]) {
        data.BreathSounds = data.BreathSounds;
        [_btnBreathSound setTitle:data.BreathSounds forState:UIControlStateNormal];
    }
    else {
        _BreathSounds = @"Clear";
    }
    
    //取得measureData並將資料塞入textfield中
    MeasureViewController *mvc = (MeasureViewController *)(self.tabBarController).parentViewController;
    data = mvc.myMeasureData;
    if (data != nil) {
        [self setMeasureData:data];
    }
    else {
        data = [[VentilationData alloc] init];
    }
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    if (!CGRectIsEmpty(textRect)) {
        // Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGFloat textPos = textRect.origin.y + textRect.size.height;
        if (_scrollView.frame.size.height - textPos < keyboardSize.height) {
            CGPoint pt = textRect.origin;
            pt.x = 0;
            pt.y = keyboardSize.height;
            [_scrollView setContentOffset:pt animated:YES];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_scrollView setContentOffset:svos animated:YES];
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textRect = [textField bounds];
    textRect = [textField convertRect:textRect toView:_scrollView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textRect = [textView bounds];
    textRect = [textView convertRect:textRect toView:_scrollView];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)displayViewTouchesBeganDone {
}

- (void)breathSoundTableViewDismissWithStringData:(NSString *)sound {
    [_btnBreathSound setTitle:sound forState:UIControlStateNormal];
    _BreathSounds = sound;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BreathSoundTableViewController *vc = [segue destinationViewController];
    vc.delegate  = self;
}

#pragma mark - Methods
- (void)setMeasureData:(VentilationData *)measureData {
    _BreathSounds = measureData.BreathSounds;
    if (![measureData.BreathSounds isEqualToString:@""]) {
        [_btnBreathSound setTitle:measureData.BreathSounds forState:UIControlStateNormal];
    }
    _PetCo2.text = measureData.PetCo2;
    _SpO2.text = measureData.SpO2;
    _RR.text = measureData.RR;
    _TV.text = measureData.TV;
    _MV.text = measureData.MV;
    _MaxPi.text = measureData.MaxPi;
    _Mvv.text = measureData.Mvv;
    _Rsbi.text = measureData.Rsbi;
    _EtSize.text = measureData.EtSize;
    _Mark.text = measureData.Mark;
    _CuffPressure.text = measureData.CuffPressure;
    _Pr.text = measureData.Pr;
    _Cvp.text = measureData.Cvp;
    _BpS.text = measureData.BpS;
    _BpD.text = measureData.BpD;
    _Xrem.text = measureData.Xrem;
}

- (void)getMeasureData:(VentilationData *)measureData {
    measureData.BreathSounds = _btnBreathSound.currentTitle;
    measureData.PetCo2 = _PetCo2.text;
    measureData.SpO2 = _SpO2.text;
    measureData.RR = _RR.text;
    measureData.TV = _TV.text;
    measureData.MV = _MV.text;
    measureData.MaxPi = _MaxPi.text;
    measureData.Mvv = _Mvv.text;
    measureData.Rsbi = _Rsbi.text;
    measureData.EtSize = _EtSize.text;
    measureData.Mark = _Mark.text;
    measureData.CuffPressure = _CuffPressure.text;
    measureData.Pr = _Pr.text;
    measureData.Cvp = _Cvp.text;
    measureData.BpS = _BpS.text;
    measureData.BpD = _BpD.text;
    measureData.Xrem = _Xrem.text;
}

@end
