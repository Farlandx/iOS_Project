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

@interface VentilatorDataViewController ()

@end

@implementation VentilatorDataViewController

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
	// Do any additional setup after loading the view.
    _displayView.delegate = self;
    
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
    
    heightChanged = NO;
    rect.origin = _scrollView.frame.origin;
    rect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    //取得measureData並將資料塞入textfield中
    MeasureViewController *mvc = (MeasureViewController *)(self.tabBarController).parentViewController;
    VentilationData *data = mvc.myMeasureData;
    if (data != nil) {
        [self setMeasureData:data];
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

- (void)displayViewTouchesBeganDone {
    [self didKeyboardDismiss];
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:_scrollView];
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

#pragma mark - Methods
- (void)setMeasureData:(VentilationData *)measureData {
    //Ventilation
    _VentilationMode.text = measureData.VentilationMode;
    
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
}

- (void)getMeasureData:(VentilationData *)measureData {
    //Ventilation
    measureData.VentilationMode = _VentilationMode.text;
    
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
}

@end
