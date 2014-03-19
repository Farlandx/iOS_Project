//
//  OtherDataViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "OtherDataViewController.h"
#import "MeasureTabBarViewController.h"

@interface OtherDataViewController ()

@end

@implementation OtherDataViewController {
    MeasureData *data;
}

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
	// Do any additional setup after loading the view.
    _displayView.delegate = self;
    
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
    
    heightChanged = NO;
    rect.origin = _scrollView.frame.origin;
    rect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    
    [_Xrem.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5f] CGColor]];
    [_Xrem.layer setBorderWidth:0.5f];
    _Xrem.delegate = self;
    
    _btnBreathSound.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if (data.BreathSounds != nil && ![data.BreathSounds isEqualToString:@""]) {
        data.BreathSounds = data.BreathSounds;
        [_btnBreathSound setTitle:data.BreathSounds forState:UIControlStateNormal];
    }
    else {
        _BreathSounds = @"Clear";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //取得measureData並將資料塞入textfield中
    data = ((MeasureTabBarViewController *)self.tabBarController).measureData;
    if (data != nil) {
        [self setMeasureData:data];
    }
    else {
        data = [[MeasureData alloc] init];
    }
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didKeyboardDismiss {
    _scrollView.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }];
    heightChanged = NO;
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:nil];
    pt = rc.origin;
    pt.x = 0;
    if (!heightChanged) {
        if (pt.y > 162) {
            pt.y -= 162;
            [_scrollView setContentOffset:pt animated:YES];
        }
        
        CGRect newRect;
        newRect.origin = _scrollView.frame.origin;
        newRect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height - 172);
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = newRect;
        }];
        heightChanged = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didKeyboardDismiss];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:nil];
    pt = rc.origin;
    pt.x = 0;
    if (!heightChanged) {
        pt.y -= 230;
        [_scrollView setContentOffset:pt animated:YES];
        CGRect newRect;
        newRect.origin = _scrollView.frame.origin;
        newRect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height - 172);
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = newRect;
        }];
        heightChanged = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self didKeyboardDismiss];
    
    [textView resignFirstResponder];
    return YES;
}

- (void)displayViewTouchesBeganDone {
    [self didKeyboardDismiss];
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
- (void)setMeasureData:(MeasureData *)measureData {
    _BreathSounds = measureData.BreathSounds;
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

- (void)getMeasureData:(MeasureData *)measureData {
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
