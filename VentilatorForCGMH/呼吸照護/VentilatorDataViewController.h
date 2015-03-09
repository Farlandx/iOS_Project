//
//  VentilatorDataViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VentilationData.h"
#import "DisplayView.h"

@protocol VentilatorDataViewDelegate <NSObject>

@optional
- (void)VentilationModeSelected:(NSString *)mode;

@end

@interface VentilatorDataViewController : UIViewController<UITextFieldDelegate, DisplayViewDelegate>

@property (assign, nonatomic) id<VentilatorDataViewDelegate> delegate;

@property (nonatomic) BOOL viewMode;
@property (nonatomic) NSInteger dataMode;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet DisplayView *displayView;

- (void)setDataMode:(NSInteger)mode;

#pragma mark - Methods
- (void)getMeasureData:(VentilationData *)measureData;
- (void)setMeasureData:(VentilationData *)measureData;

#pragma mark - 量測資料
//Ventilation
//@property (strong, nonatomic) IBOutlet UITextField *VentilationMode;
@property (strong, nonatomic) IBOutlet UIButton *VentilationMode;

//Tidal Volume
@property (strong, nonatomic) IBOutlet UITextField *TidalVolumeSet;
@property (strong, nonatomic) IBOutlet UITextField *TidalVolumeMeasured;

//Ventilation Rate
@property (strong, nonatomic) IBOutlet UITextField *VentilationRateSet;
@property (strong, nonatomic) IBOutlet UITextField *VentilationRateTotal;

//MV
@property (strong, nonatomic) IBOutlet UITextField *MVSet;
@property (strong, nonatomic) IBOutlet UITextField *MVTotal;

//SIMV Rate
@property (strong, nonatomic) IBOutlet UITextField *SIMVRateSet;

//%min Vol
//Minute Volume Set
@property (strong, nonatomic) IBOutlet UITextField *PercentMinVolSet;

//Pattern
@property (strong, nonatomic) IBOutlet UITextField *Pattern;

//Vol Target
@property (strong, nonatomic) IBOutlet UITextField *VolumeTarget;

//Insp. T
@property (strong, nonatomic) IBOutlet UITextField *InspT;

//I:E
//I:E Ratio
@property (strong, nonatomic) IBOutlet UITextField *InspirationExpirationRatio;


//THigh
@property (strong, nonatomic) IBOutlet UITextField *THigh;

//TLow
@property (strong, nonatomic) IBOutlet UITextField *Tlow;

//Flow
@property (strong, nonatomic) IBOutlet UITextField *FlowSetting;
@property (strong, nonatomic) IBOutlet UITextField *FlowMeasured;
@property (strong, nonatomic) IBOutlet UITextField *BaseFlow;
@property (strong, nonatomic) IBOutlet UITextField *FlowSensitivity;
@property (strong, nonatomic) IBOutlet UITextField *AutoFlow;

//Pressure
@property (strong, nonatomic) IBOutlet UITextField *PeakPressure;
@property (strong, nonatomic) IBOutlet UITextField *PlateauPressure;
@property (strong, nonatomic) IBOutlet UITextField *MeanPressure;
@property (strong, nonatomic) IBOutlet UITextField *PEEP;
@property (strong, nonatomic) IBOutlet UITextField *PressureSupport;
@property (strong, nonatomic) IBOutlet UITextField *PressureControl;

//PHigh
@property (strong, nonatomic) IBOutlet UITextField *PHigh;

//Plow
@property (strong, nonatomic) IBOutlet UITextField *Plow;

//Temp.
@property (strong, nonatomic) IBOutlet UITextField *Temperature;

//FiO2
@property (strong, nonatomic) IBOutlet UITextField *FiO2Set;
@property (strong, nonatomic) IBOutlet UITextField *FiO2Measured;

//Resistance
@property (strong, nonatomic) IBOutlet UITextField *Resistance;

//Compliance
@property (strong, nonatomic) IBOutlet UITextField *Compliance;

//L. MV
@property (strong, nonatomic) IBOutlet UITextField *LowerMV;

//H. Pr. Alarm
@property (strong, nonatomic) IBOutlet UITextField *HighPressureAlarm;

//Relief. Pr.
@property (strong, nonatomic) IBOutlet UITextField *ReliefPressure;


#pragma mark - 20140902新增欄位
@property (strong, nonatomic) IBOutlet UITextField *VentilationHertz;  //Hertz, XXX

@property (strong, nonatomic) IBOutlet UITextField *PressureAmplitude; //Amplitude,XXX
@property (strong, nonatomic) IBOutlet UITextField *TubeCompensation;//Tube Compensation%,XXXX
@property (strong, nonatomic) IBOutlet UITextField *VolumeAssist;//Volume Assist,XXX
@property (strong, nonatomic) IBOutlet UITextField *FlowAssist;//Flow Assist,XXX

@property (strong, nonatomic) IBOutlet UITextField *EdiPeak;//Edi Peak,XXX
@property (strong, nonatomic) IBOutlet UITextField *EdiMin;//Edi Min,XXX
@property (strong, nonatomic) IBOutlet UITextField *NavaLevel;//Nava Level,XXXX
@property (strong, nonatomic) IBOutlet UITextField *EdiTrigger;//Edi Trigger,XXX
#pragma mark 原本欄位是NO，與關鍵字衝突，因此在前面加了底線
@property (strong, nonatomic) IBOutlet UITextField *_NO;//NO,XXX
@property (strong, nonatomic) IBOutlet UITextField *NO2;//NO2(2下標),XXXX


@end
