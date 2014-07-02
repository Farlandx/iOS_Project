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

@interface HistoryCollectionViewController () <CollectionViewHeaderProtocol, ContentCollectionViewProtocol>

@end

@implementation HistoryCollectionViewController {
    CollectionViewHeader *collectionViewHeader;
    ContentCollectionView *contentCollectionView;
}

@synthesize batchData;

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
        if (batchData != nil && batchData.VentRecList.count > 0) {
            NSMutableArray *timeArray = [[NSMutableArray alloc] init];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            for (VentilationData *data in batchData.VentRecList) {
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
                collectionViewHeader.timeArray = timeArray;
                [collectionViewHeader reloadData];
            }
            
            if (dataArray.count > 0) {
                contentCollectionView.dataArray = dataArray;
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
    
    //----------------------------------------------01
    //床號
    [ary addObject:data.BedNo];
    //治療師
    [ary addObject:data.RecordOper];
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
    [ary  addObject:data.MaxPi];
    
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
    [ary  addObject:data.BreathSounds];
    //PR
    [ary addObject:data.Pr];
    //CVP
    [ary addObject:data.Cvp];
    //BPS
    [ary addObject:data.BpS];
    //BPD
    [ary addObject:data.BpD];
    
    //----------------------------------------------56
    
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

@end
