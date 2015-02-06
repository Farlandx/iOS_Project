//
//  VentilatorDataViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "VentilatorDataViewController.h"
#import "MeasureTabBarViewController.h"
#import "MeasureViewController.h"

#define FOO_PATTERN @"0123456789."
#define FOO_IE_PATTERN @"0123456789.:"

#define DROPDOWNVIEW_TAG 1023
#define DROPDOWNVIEW_HEIGHT 300.0
#define DROPDOWN_LIST_ITEMS @[@"NC", @"NC/H", @"Mask", @"Tr-Mask", @"T-P", @"O₂ hood", @"hood/heater", @"O₂ inhalation", @"S-M", @"S-M/H", @"V-M", @"Tr.O₂", @"Tr.O₂/H", @"NRM", @"HF-Mask", @"HF-TP", @"HF FM", @"O₂ blow", @"RA"]

@interface VentilatorDataViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VentilatorDataViewController {
    CGRect textRect;
    BOOL isDropdownViewShow;
}

@synthesize viewMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isDropdownViewShow = NO;
    
    //SwipeGesture
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTrigger:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view  addGestureRecognizer:swipeGesture];
    
    _displayView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.origin.x, _displayView.frame.size.height + self.tabBarController.tabBar.frame.size.height)];
    
    _VentilationMode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if (viewMode) {
        for(UIView *v in _displayView.subviews) {
            if ([v isKindOfClass:[UITextField class]]) {
                ((UITextField *)v).enabled = NO;
            }
        }
    }
    else {
        for (UIView *v in [_displayView subviews]) {
            if ([v isKindOfClass:[UITextField class]]) {
                UITextField *txtField = (UITextField *)v;
                txtField.keyboardType = UIKeyboardTypeDecimalPad;
                txtField.delegate = self;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //取得measureData並將資料塞入textfield中
    MeasureViewController *mvc = (MeasureViewController *)(self.tabBarController).parentViewController;
    VentilationData *data = mvc.myMeasureData;
    if (data != nil) {
        [self setMeasureData:data];
    }
}

- (void)dealloc {
    _delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void){
                        [super viewWillAppear:YES];
                    } completion:^(BOOL finished){
                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayViewTouchesBeganDone {
    [self removeDropdownView];
}

#pragma mark - Button & DropdownView
- (IBAction)btnModeClick:(id)sender {
    if (isDropdownViewShow) {
        [self removeDropdownView];
        return;
    }
    [self showDropdownViewBelowSender:sender];
}

- (void)showDropdownViewBelowSender:(id)sender {
    CGRect rect = ((UIView *)sender).frame;
    
    UIView *dropdownView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x,
                                                                    rect.origin.y + rect.size.height,
                                                                    rect.size.width,
                                                                    DROPDOWNVIEW_HEIGHT)];
    dropdownView.tag = DROPDOWNVIEW_TAG;
    dropdownView.backgroundColor = [UIColor whiteColor];
    dropdownView.alpha = 0;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:dropdownView.bounds];
    dropdownView.layer.masksToBounds = NO;
    dropdownView.layer.shadowColor = [UIColor blackColor].CGColor;
    dropdownView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    dropdownView.layer.shadowOpacity = 0.5f;
    dropdownView.layer.shadowPath = shadowPath.CGPath;
    
    UITableView *listTable = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           dropdownView.frame.size.width,
                                                                           DROPDOWNVIEW_HEIGHT)
                                                          style:UITableViewStylePlain];
    listTable.alpha = 0;
    listTable.dataSource = self;
    listTable.delegate = self;
    
    [dropdownView addSubview:listTable];
    [dropdownView bringSubviewToFront:listTable];
    
    [_displayView addSubview:dropdownView];
    [_displayView bringSubviewToFront:dropdownView];
    
    //animation
    [UIView animateWithDuration:0.3f animations:^ {
//        CGRect dropdownViewRect = dropdownView.frame;
//        dropdownViewRect.size.height = DROPDOWNVIEW_HEIGHT;
//        dropdownView.frame = dropdownViewRect;
//        
//        CGRect listTableRect = listTable.frame;
//        listTableRect.size.height = DROPDOWNVIEW_HEIGHT;
//        listTable.frame = listTableRect;
        dropdownView.alpha = 1.0f;
        listTable.alpha = 1.0f;
    }];
    
    isDropdownViewShow = YES;
}

- (void)removeDropdownView {
    if (!isDropdownViewShow) {
        return;
    }
    
    for (UIView *view in _displayView.subviews) {
        if (view.tag == DROPDOWNVIEW_TAG) {
            [view removeFromSuperview];
            isDropdownViewShow = NO;
            return;
        }
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DROPDOWN_LIST_ITEMS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = DROPDOWN_LIST_ITEMS[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *mode = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [_VentilationMode setTitle:mode forState:UIControlStateNormal];
    [_delegate VentilationModeSelected:mode];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self removeDropdownView];
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    
    if (!CGRectIsEmpty(textRect)) {
        // Get the size of the keyboard.
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGFloat textPos = textRect.origin.y + textRect.size.height;
        if (self.view.window.frame.size.height - textPos < keyboardSize.height) {
            CGPoint pt = textRect.origin;
            pt.x = 0;
            pt.y = textPos + keyboardSize.height - self.view.window.frame.size.height;
            
            [self.view setTransform:CGAffineTransformIdentity];
            
            [self.view.window setBounds:CGRectMake(self.view.window.frame.origin.x, keyboardSize.height, self.view.window.frame.size.width, self.view.window.frame.size.height)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];

    [self.view.window setBounds:CGRectMake(self.view.window.frame.origin.x, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
    
    [UIView commitAnimations];
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textRect = [self.view.window convertRect:textField.bounds fromView:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    else if (textField == _InspirationExpirationRatio && string.length == 1) {
        return [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:FOO_IE_PATTERN]].location != NSNotFound;
    }
    else if (string.length == 1) {
        return [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:FOO_PATTERN]].location != NSNotFound;
    }
    
    return NO;
}

#pragma mark - Methods
- (void)setMeasureData:(VentilationData *)measureData {
    //Ventilation
    [_VentilationMode setTitle:(measureData.VentilationMode.length > 0 ? measureData.VentilationMode : @"請選擇或讀取模式") forState:UIControlStateNormal];
    
    //Tidal Volume
    _TidalVolumeSet.text = measureData.TidalVolumeSet;
    _TidalVolumeMeasured.text = measureData.TidalVolumeMeasured;
    
    //Ventilation Rate
    _VentilationRateSet.text = measureData.VentilationRateSet;
    _VentilationRateTotal.text = measureData.VentilationRateTotal;
    
    //MV
    _MVSet.text = measureData.MVSet;
    _MVTotal.text = measureData.MVTotal;
    
    //SIMV Rate
    _SIMVRateSet.text = measureData.SIMVRateSet;
    
    //%min Vol
    //Minute Volume Set
    _PercentMinVolSet.text = measureData.PercentMinVolSet;
    
    //Pattern
    _Pattern.text = measureData.Pattern;
    
    //Vol Target
    _VolumeTarget.text = measureData.VolumeTarget;
    
    //Insp. T
    _InspT.text = measureData.InspT;
    
    //I:E
    //I:E Ratio
    _InspirationExpirationRatio.text = measureData.InspirationExpirationRatio;
    
    
    //THigh
    _THigh.text = measureData.THigh;
    
    //TLow
    _Tlow.text = measureData.Tlow;
    
    //Flow
    _FlowSetting.text = measureData.FlowSetting;
    _FlowMeasured.text = measureData.FlowMeasured;
    _BaseFlow.text = measureData.BaseFlow;
    _FlowSensitivity.text = measureData.FlowSensitivity;
    _AutoFlow.text = measureData.AutoFlow;
    
    //Pressure
    _PeakPressure.text = measureData.PeakPressure;
    _PlateauPressure.text = measureData.PlateauPressure;
    _MeanPressure.text = measureData.MeanPressure;
    _PEEP.text = measureData.PEEP;
    _PressureSupport.text = measureData.PressureSupport;
    _PressureControl.text = measureData.PressureControl;
    
    //PHigh
    _PHigh.text = measureData.PHigh;
    
    //Plow
    _Plow.text = measureData.Plow;
    
    //Temp.
    _Temperature.text = measureData.Temperature;
    
    //FiO2
    _FiO2Set.text = measureData.FiO2Set;
    _FiO2Measured.text = measureData.FiO2Measured;
    
    //Resistance
    _Resistance.text = measureData.Resistance;
    
    //Compliance
    _Compliance.text = measureData.Compliance;
    
    //L. MV
    _LowerMV.text = measureData.LowerMV;
    
    //H. Pr. Alarm
    _HighPressureAlarm.text = measureData.HighPressureAlarm;
    
    //Relief. Pr.
    _ReliefPressure.text = measureData.ReliefPressure;
    
    //20140902新增欄位
    //Hertz, XXX
    _VentilationHertz.text = measureData.VentilationHertz;
    
    //Amplitude,XXX
    _PressureAmplitude.text = measureData.PressureAmplitude;
    
    //Tube Compensation%,XXXX
    _TubeCompensation.text = measureData.TubeCompensation;
    
    //Volume Assist,XXX
    _VolumeAssist.text = measureData.VolumeAssist;
    
    //Flow Assist,XXX
    _FlowAssist.text = measureData.FlowAssist;
    
    //Edi Peak,XXX
    _EdiPeak.text = measureData.EdiPeak;
    
    //Edi Min,XXX
    _EdiMin.text = measureData.EdiMin;
    
    //Nava Level,XXXX
    _NavaLevel.text = measureData.NavaLevel;
    
    //Edi Trigger,XXX
    _EdiTrigger.text = measureData.EdiTrigger;
    
    //NO.XXX
    __NO.text = measureData._NO;
    
    //NO2(2下標),XXXX
    _NO2.text = measureData.NO2;
}

- (void)getMeasureData:(VentilationData *)measureData {
    //Ventilation
    measureData.VentilationMode = _VentilationMode.titleLabel.text;
    
    //Tidal Volume
    measureData.TidalVolumeSet = _TidalVolumeSet.text;
    measureData.TidalVolumeMeasured = _TidalVolumeMeasured.text;
    
    //Ventilation Rate
    measureData.VentilationRateSet = _VentilationRateSet.text;
    measureData.VentilationRateTotal = _VentilationRateTotal.text;
    
    //MV
    measureData.MVSet = _MVSet.text;
    measureData.MVTotal = _MVTotal.text;
    
    //SIMV Rate
    measureData.SIMVRateSet = _SIMVRateSet.text;
    
    //%min Vol
    //Minute Volume Set
    measureData.PercentMinVolSet = _PercentMinVolSet.text;
    
    //Pattern
    measureData.Pattern = _Pattern.text;
    
    //Vol Target
    measureData.VolumeTarget = _VolumeTarget.text;
    
    //Insp. T
    measureData.InspT = _InspT.text;
    
    //I:E
    //I:E Ratio
    measureData.InspirationExpirationRatio = _InspirationExpirationRatio.text;
    
    
    //THigh
    measureData.THigh = _THigh.text;
    
    //TLow
    measureData.Tlow = _Tlow.text;
    
    //Flow
    measureData.FlowSetting = _FlowSetting.text;
    measureData.FlowMeasured = _FlowMeasured.text;
    measureData.BaseFlow = _BaseFlow.text;
    measureData.FlowSensitivity = _FlowSensitivity.text;
    measureData.AutoFlow = _AutoFlow.text;
    
    //Pressure
    measureData.PeakPressure = _PeakPressure.text;
    measureData.PlateauPressure = _PlateauPressure.text;
    measureData.MeanPressure = _MeanPressure.text;
    measureData.PEEP = _PEEP.text;
    measureData.PressureSupport = _PressureSupport.text;
    measureData.PressureControl = _PressureControl.text;
    
    //PHigh
    measureData.PHigh = _PHigh.text;
    
    //Plow
    measureData.Plow = _Plow.text;
    
    //Temp.
    measureData.Temperature = _Temperature.text;
    
    //FiO2
    measureData.FiO2Set = _FiO2Set.text;
    measureData.FiO2Measured = _FiO2Measured.text;
    
    //Resistance
    measureData.Resistance = _Resistance.text;
    
    //Compliance
    measureData.Compliance = _Compliance.text;
    
    //L. MV
    measureData.LowerMV = _LowerMV.text;
    
    //H. Pr. Alarm
    measureData.HighPressureAlarm = _HighPressureAlarm.text;
    
    //Relief. Pr.
    measureData.ReliefPressure = _ReliefPressure.text;
    
    //20140902新增欄位
    //Hertz, XXX
    measureData.VentilationHertz = _VentilationHertz.text;
    
    //Amplitude,XXX
    measureData.PressureAmplitude = _PressureAmplitude.text;
    
    //Tube Compensation%,XXXX
    measureData.TubeCompensation = _TubeCompensation.text;
    
    //Volume Assist,XXX
    measureData.VolumeAssist = _VolumeAssist.text;
    
    //Flow Assist,XXX
    measureData.FlowAssist = _FlowAssist.text;
    
    //Edi Peak,XXX
    measureData.EdiPeak = _EdiPeak.text;
    
    //Edi Min,XXX
    measureData.EdiMin = _EdiMin.text;
    
    //Nava Level,XXXX
    measureData.NavaLevel = _NavaLevel.text;
    
    //Edi Trigger,XXX
    measureData.EdiTrigger = _EdiTrigger.text;
    
    //NO.XXX
    measureData._NO = __NO.text;
    
    //NO2(2下標),XXXX
    measureData.NO2 = _NO2.text;
}

#pragma mark - Gesture
- (void)swipeTrigger:(UISwipeGestureRecognizer*)gesture {
    MeasureTabBarViewController *tabbarView = (MeasureTabBarViewController *)self.parentViewController;
    tabbarView.selectedIndex = 1;
}

@end
