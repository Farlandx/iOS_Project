//
//  VentilatorDataViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "VentilatorDataViewController.h"
#import "MeasureTabBarViewController.h"

@interface VentilatorDataViewController ()

@end

@implementation VentilatorDataViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    //取得measureData並將資料塞入textfield中
    MeasureData *data = ((MeasureTabBarViewController *)self.tabBarController).measureData;
    if (data != nil) {
        [self setMeasureData:data];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMeasureData:(MeasureData *)measureData {
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

@end
