//
//  HistoryCollectionViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/20.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HistoryCollectionViewController.h"

#import "CollectionViewHeader.h"

#import "ContentScrollView.h"
#import "TitleView.h"
#import "ContentCollectionView.h"
#import "VentilationData.h"
#import "DatabaseUtility.h"
#import "WebService.h"
#import "DeviceStatus.h"
#import "ProgressHUD.h"
#import "DtoGetAssociatedRespCareRecRslt.h"
#import "DtoRespCareCol.h"

@interface HistoryCollectionViewController () <CollectionViewHeaderProtocol, ContentCollectionViewProtocol, WebServiceDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@end

@implementation HistoryCollectionViewController {
    CollectionViewHeader *collectionViewHeader;
    ContentCollectionView *contentCollectionView;
    DatabaseUtility *db;
    ABGUpdateRecord *updateRecord;
    WebService *ws;
    UITextField *userText;
    UIAlertView *alertView;
    NSMutableArray *VentRecList;
}

@synthesize ChtNo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *btnGetABGData = [[UIBarButtonItem alloc] initWithTitle:@"取得動脈血氣體分析資料" style:UIBarButtonItemStylePlain target:self action:@selector(getABGData)];
    self.navigationItem.rightBarButtonItem = btnGetABGData;
    
    //左上角加入一塊填充的UIView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, HEADER_WIDTH, HEADER_HEIGHT)];
    [view setBackgroundColor:[UIColor whiteColor]];
    CALayer *bottomBorder = [CALayer layer];
    
    //bottom border
    bottomBorder.frame = CGRectMake(0, HEADER_HEIGHT - 1.0f, HEADER_WIDTH, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    [view.layer addSublayer:bottomBorder];
    
    //right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(HEADER_WIDTH - 1.0f, 0, 1.0f, HEADER_HEIGHT);
    rightBorder.backgroundColor = [UIColor grayColor].CGColor;
    [view.layer addSublayer:rightBorder];
    
    [self.view addSubview:view];
    
    db = [[DatabaseUtility alloc] init];
    VentRecList = [db getUploadHistoriesByChtNo:ChtNo];
    
    ws = [[WebService alloc] init];
    ws.delegate = self;
    
    //調整subview裡面的內容
    ContentScrollView *scrollView;
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[CollectionViewHeader class]]) {
            collectionViewHeader = (CollectionViewHeader *)v;
        }
        else if ([v isKindOfClass:[ContentScrollView class]]) {
            scrollView = (ContentScrollView *)v;
        }
    }
    
    if (collectionViewHeader != nil && scrollView != nil) {
        TitleView *titleView;
        
        for (UIView *v in scrollView.subviews) {
            if ([v isKindOfClass:[TitleView class]]) {
                titleView = (TitleView *)v;
            }
            else if ([v isKindOfClass:[ContentCollectionView class]]) {
                contentCollectionView = (ContentCollectionView *)v;
            }
            
        }
        
        if (contentCollectionView != nil) {
            collectionViewHeader.protocol = self;
            contentCollectionView.protocol = self;
            
            [contentCollectionView setFrame:CGRectMake(HEADER_WIDTH, 0.0f, contentCollectionView.frame.size.width, titleView.totalHeight)];
        }
        
        [scrollView setContentSize:CGSizeMake(scrollView.frame.origin.x, titleView.totalHeight)];
        
        //將資料放進subview裡面
        if (VentRecList.count > 0) {
            NSMutableArray *timeArray = [[NSMutableArray alloc] init];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            for (VentilationData *data in VentRecList) {
                //CollectionViewHeader
                //不這樣轉會出現尾巴有+0000奇怪的格式
                NSDate *d = [dateFormatter dateFromString:data.RecordTime];
                if (d) {
                    [timeArray addObject:[dateFormatter stringFromDate:d]];
                }
                
                //ContentCollectionView
                [dataArray addObject:[self getContentCollectionData:data]];
            }
            
            if (timeArray.count > 0) {
                collectionViewHeader.timeArray = [timeArray mutableCopy];
                [timeArray removeAllObjects];
                [collectionViewHeader reloadData];
            }
            
            if (dataArray.count > 0) {
                contentCollectionView.dataArray = [dataArray mutableCopy];
                [dataArray removeAllObjects];
            }
            
            [dateFormatter stringFromDate:[NSDate date]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取得ContentCollection用的Data
- (NSArray *)getContentCollectionData:(VentilationData *)data {
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    
    /*//----------------------------------------------01
    //床號
    [ary addObject:data.BedNo];
    //治療師
    [ary addObject:data.RecordOperName];
    //呼吸器
    [ary addObject:data.VentNo];
    //Ventilation Mode
    [ary addObject:data.VentilationMode];
    //TidalVolume Set
    [ary addObject:data.TidalVolumeSet];
    
    //----------------------------------------------06
    //Tidal Volume
    [ary addObject:data.TidalVolumeMeasured];
    //Volume Target
    [ary addObject:data.VolumeTarget];
    //Ventilation Rate Set
    [ary addObject:data.VentilationRateSet];
    //Ventilation Rate Total
    [ary addObject:data.VentilationRateTotal];
    //SIMV Rate Set
    [ary addObject:data.SIMVRateSet];
    
    //----------------------------------------------11
    //InspT
    [ary addObject:data.InspT];
    //THigh
    [ary addObject:data.THigh];
    //Tlow
    [ary addObject:data.Tlow];
    //I:E Ratio
    [ary addObject:data.InspirationExpirationRatio];
    //Auto Flow
    [ary addObject:data.AutoFlow];
    
    //----------------------------------------------16
    //Flow Setting
    [ary addObject:data.FlowSetting];
    //Flow Measured
    [ary addObject:data.FlowMeasured];
    //Pattern
    [ary addObject:data.Pattern];
    //MV Set
    [ary addObject:data.MVSet];
    //Percent MinVol Set
    [ary addObject:data.PercentMinVolSet];
    
    //----------------------------------------------21
    //MV Total
    [ary addObject:data.MVTotal];
    //Peak Pressure
    [ary addObject:data.PeakPressure];
    //Plateau Pressure
    [ary addObject:data.PlateauPressure];
    //Mean Pressure
    [ary addObject:data.MeanPressure];
    //PEEP
    [ary addObject:data.PEEP];
    
    //----------------------------------------------26
    //Plow
    [ary addObject:data.Plow];
    //PHigh
    [ary  addObject:data.PHigh];
    //Pressure Support
    [ary addObject:data.PressureSupport];
    //Pressure Control
    [ary addObject:data.PressureControl];
    //FiO2 Set
    [ary addObject:data.FiO2Set];
    
    //----------------------------------------------31
    //FiO2 Measured
    [ary addObject:data.FiO2Measured];
    //Resistance
    [ary addObject:data.Resistance];
    //Compliance
    [ary addObject:data.Compliance];
    //Base Flow
    [ary addObject:data.BaseFlow];
    //Flow Sensitivity
    [ary addObject:data.FlowSensitivity];
    
    //----------------------------------------------36
    //Lower MV
    [ary addObject:data.LowerMV];
    //High Pressure Alarm
    [ary addObject:data.HighPressureAlarm];
    //Temperature
    [ary  addObject:data.Temperature];
    //Relief Pressure
    [ary addObject:data.ReliefPressure];
    //PE CO2
    [ary addObject:data.PetCo2];
    
    //----------------------------------------------41
    //SpO2
    [ary addObject:data.SpO2];
    //RR
    [ary addObject:data.RR];
    //TV
    [ary addObject:data.TV];
    //MV
    [ary addObject:data.MV];
    //Max Pi
    [ary addObject:data.MaxPi];
    
    //----------------------------------------------46
    //MVV
    [ary addObject:data.Mvv];
    //RSBI
    [ary addObject:data.Rsbi];
    //ET Size
    [ary  addObject:data.EtSize];
    //mark
    [ary addObject:data.Mark];
    //Cuff pressure
    [ary addObject:data.CuffPressure];
    
    //----------------------------------------------51
    //Breath Sounds
    [ary addObject:data.BreathSounds];
    //PR
    [ary addObject:data.Pr];
    //CVP
    [ary addObject:data.Cvp];
    //BPS
    [ary addObject:data.BpS];
    //BPD
    [ary addObject:data.BpD];
    
    //----------------------------------------------56
    //20140902新增欄位
    //Hertz
    [ary addObject:data.VentilationHertz];
    //Amplitude
    [ary  addObject:data.PressureAmplitude];
    //Tube Compensation
    [ary addObject:data.TubeCompensation];
    //Volume Assist
    [ary addObject:data.VolumeAssist];
    //Flow Assist
    [ary addObject:data.FlowAssist];
    
    //----------------------------------------------61
    //Edi Peak
    [ary addObject:data.EdiPeak];
    //Edi Min
    [ary addObject:data.EdiMin];
    //Nava Level
    [ary addObject:data.NavaLevel];
    //Edi Trigger
    [ary addObject:data.EdiTrigger];
    //NO
    [ary addObject:data._NO];
    
    //----------------------------------------------66
    //NO2(2下標)
    [ary addObject:data.NO2];
    //Cuff Leak Test
    [ary addObject:data.LeakTest];
    //B.E
    [ary addObject:data.Be];
    //HCO3
    [ary addObject:data.HCO3];
    //PA-aO2
    [ary addObject:data.PAAO2];
    
    //----------------------------------------------71
    //PaCO2
    [ary addObject:data.PaCo2];
    //PaO2
    [ary addObject:data.PaO2];
    //PEtCO2
    [ary addObject:data.PetCo2];
    //PF ratio
    [ary addObject:data.PfRatio];
    //PH
    [ary addObject:data.Ph];
    
    //----------------------------------------------76
    //SaO2
    [ary addObject:data.SaO2];
    //Shunt
    [ary addObject:data.Shunt];
    //Site
    [ary addObject:data.Site];
    //SpO2
    [ary addObject:data.SpO2];*/
    
    //床號
    [ary addObject:data.BedNo];
    //病歷號
    [ary addObject:data.ChtNo];
    //呼吸器
    [ary addObject:data.VentilatorModel];
    //Ventilation Mode
    [ary addObject:data.VentilationMode];
    //TidalVolume Set
    [ary addObject:data.TidalVolumeSet];
    //TidalVolume Measured
    [ary addObject:data.TidalVolumeMeasured];
    //Ventilation Rate Set/Total
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.VentilationRateSet, data.VentilationRateTotal]];
    //Hertz
    [ary addObject:data.VentilationHertz];
    //Flow/NO/NO2
    //Flow Set > Auto > Measured
    [ary addObject:[NSString stringWithFormat:@"%@ / %@ / %@",
                    (![data.FlowSetting isEqualToString:@""] ? data.FlowSetting : (![data.AutoFlow isEqualToString:@""] ? data.AutoFlow : (![data.FlowMeasured isEqualToString:@""] ? data.FlowMeasured : @"")))
                    , data._NO, data.NO2]];
    //Insp. T / I:E
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.InspT, data.InspirationExpirationRatio]];
    //MV Set/MinVol%/Total
    [ary addObject:[NSString stringWithFormat:@"%@ / %@ / %@", data.MVSet, data.PercentMinVolSet, data.MVTotal]];
    //Peak/Plateau
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PeakPressure, data.PlateauPressure]];
    //Mean/PEEP
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.MeanPressure, data.PEEP]];
    //P.S/P.C/amplitude
    [ary addObject:[NSString stringWithFormat:@"%@ / %@ / %@", data.PressureSupport, data.PressureControl, data.PressureAmplitude]];
    //Temp/Tube compensation
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Temperature, data.TubeCompensation]];
    //FiO2 Set/Measured
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.FiO2Set, data.FiO2Measured]];
    //Resistance/Compliance
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Resistance, data.Compliance]];
    //Base Flow/Flow sens
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.BaseFlow, data.FlowSensitivity]];
    //Volume/Flow Assist
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.VolumeAssist, data.FlowAssist]];
    //Edi peak/min
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.EdiPeak, data.EdiMin]];
    //NAVA Level/Edi trigger
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.NavaLevel, data.EdiTrigger]];
    //L. MV/ H. Pr. Alarm
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.LowerMV, data.HighPressureAlarm]];
    //Relief Pr.
    [ary addObject:data.ReliefPressure];
    //時間
    [ary addObject:data.AnalysisTime];
    //PH
    [ary addObject:data.Ph];
    //PaCO2 / PetCO2
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PaCo2, data.PetCo2]];
    //PaO2 / Site
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PaO2, data.Site]];
    //HCO3 / BE
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.HCO3, data.Be]];
    //SaO2 / SpO2
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.SaO2, data.SpO2]];
    //PA-aO2 / Shunt
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PAAO2, data.Shunt]];
    //P/F ratio
    [ary addObject:data.PfRatio];
    //RR/OI
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.RR, @""]];
    //TV/MV
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.TV, data.MV]];
    //Max Pi/Pe
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.MaxPi, data.MaxPe]];
    //MVV/VC
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Mvv, data.VC]];
    //RSBI
    [ary addObject:data.Rsbi];
    //ET Size/mark
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.EtSize, data.Mark]];
    //Cuff pressure/leak test
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.CuffPressure, data.LeakTest]];
    //Breath Sound
    [ary addObject:data.BreathSounds];
    //PR/CVP
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Pr, data.Cvp]];
    //BP(S/D)
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.BpS, data.BpD]];
    //治療師
    [ary addObject:data.RecordOperName];
    
    return ary;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ScrollingProtocol
- (void)headerDidScroll {
    CGPoint offset = contentCollectionView.contentOffset;
    
    offset.x = collectionViewHeader.contentOffset.x;
    [contentCollectionView setContentOffset:offset];
}

- (void)collectionViewDidScroll {
    CGPoint offset = collectionViewHeader.contentOffset;
    
    offset.x = contentCollectionView.contentOffset.x;
    [collectionViewHeader setContentOffset:offset];
}

#pragma mark - Method
- (void)getABGData {
    alertView = [[UIAlertView alloc] initWithTitle:@"請掃瞄或輸入治療師卡號" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"送出", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    userText = [alertView textFieldAtIndex:0];
    userText.delegate = self;
    [alertView show];
}

- (BOOL)isEqualDateString:(NSString *)dateString1 withDateString:(NSString *)dateString2 {
    if (!dateString1.length || !dateString2.length) {
        return NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    if ([[dateFormatter dateFromString:dateString1] compare:[dateFormatter dateFromString:dateString2]] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userText) {
        [self alertView:alertView clickedButtonAtIndex:1];
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([userText.text isEqualToString:@""]) {
            [ProgressHUD showError:@"治療師編號不得空白"];
            return;
        }
        
        [ProgressHUD show:@"取得驗證資料中..." Interaction:NO];
        [ws appLoginDeviceName:[DeviceStatus getDeviceVendorUUID] idNo:userText.text];
    }
}

#pragma mark - WebService Delegate
- (void)wsAppLogin:(NSString *)sessionId {
    NSLog(@"sessionId:%@", sessionId);
    if (sessionId != nil && ![sessionId isEqualToString:@""]) {
        updateRecord = [db getABGUpdateRecordByChtNo:ChtNo];
        [ws getABGDataBySessionId:sessionId ChtNo:ChtNo LastUpdateTime:updateRecord.LastUpdateTime];
    }
    else {
        [ProgressHUD showError:@"驗證失敗，請洽資訊中心確認網路是否有問" Interaction:NO];
    }
}

- (void)wsConnectionError:(NSError *)error {
    
    switch ((CFNetworkErrors)[error code]) {
        case kCFURLErrorTimedOut:
            [ProgressHUD showError:@"連線逾時，請洽資訊中心確認網路是否有問題"];
            break;
            
        case kCFURLErrorCannotConnectToHost:
            [ProgressHUD showError:@"與伺服器連線失敗，請確認網路是否暢通"];
            break;
            
        default:
            [ProgressHUD showError:[NSString stringWithFormat:@"連線錯誤(%ld)", [error code]]];
            break;
    }
    NSLog(@"連線錯誤(%ld)", [error code]);
}

- (void)wsError {
    [ProgressHUD showError:@"連線錯誤，請洽資訊中心確認網路是否有問題"];
}

- (void)wsResponseABGData:(NSMutableArray *)data {
    //更新抓到的資料
    for (DtoGetAssociatedRespCareRecRslt *rslt in data) {
        for (VentilationData *vent in VentRecList) {
            if ([self isEqualDateString:rslt.RecordTime withDateString:vent.RecordTime]) {
                BOOL hasChanged = NO;
                for (DtoRespCareCol *col in rslt.Fields) {
                    if ([col.Name caseInsensitiveCompare:@"AnalysisTime"] == NSOrderedSame) {
                        hasChanged = YES;
                        if (![col.Value isEqualToString:@"00:00"]) {
                            vent.AnalysisTime = col.Value;
                        }
                    }
                    else if ([col.Name caseInsensitiveCompare:@"Be"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.Be = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"HCO3"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.HCO3 = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"PAAO2"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.PAAO2 = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"PaCO2"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.PaCo2 = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"PaO2"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.PaO2 = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"PetCo2"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.PetCo2 = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"PfRatio"] == NSOrderedSame) {
                        hasChanged = YES;
                        if (![col.Value isEqualToString:@""]) {
                            vent.PfRatio = [NSString stringWithFormat:@"%.1f", [col.Value floatValue]];
                        }
                    }
                    else if ([col.Name caseInsensitiveCompare:@"Ph"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.Ph = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"SaO2"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.SaO2 = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"Shunt"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.Shunt = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"Site"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.Site = col.Value;
                    }
                    else if ([col.Name caseInsensitiveCompare:@"SpO2"] == NSOrderedSame) {
                        hasChanged = YES;
                        vent.SpO2 = col.Value;
                    }
                }
                
                if (hasChanged) {
                    [db saveMeasure:vent];
                }
            }
        }
    }
    
    //更新最後更新時間
    [db updateABGUpdateRecordByChtNo:ChtNo];
    
    //更新表單
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (VentilationData *data in VentRecList) {
        [dataArray addObject:[self getContentCollectionData:data]];
    }
    
    if (dataArray.count > 0) {
        contentCollectionView.dataArray = [dataArray mutableCopy];
        [dataArray removeAllObjects];
    }
    [contentCollectionView reloadData];
    [ProgressHUD dismiss];
}

@end
