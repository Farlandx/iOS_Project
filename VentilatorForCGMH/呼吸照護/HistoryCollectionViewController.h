//
//  HistoryCollectionViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/20.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtoVentExchangeUploadBatch.h"

#define HEADER_HEIGHT 25
#define HEADER_WIDTH 200
#define ARRAY_TITLE @[@"床號", @"治療師", @"呼吸器", @"Ventilation Mode", @"TidalVolume Set", @"Tidal Volume", @"Volume Target", @"Ventilation Rate Set", @"Ventilation Rate Total", @"SIMV Rate Set", @"InspT", @"THigh", @"Tlow", @"I:E Ratio", @"Auto Flow", @"Flow Setting", @"Flow Measured", @"Pattern", @"MV Set", @"Percent MinVol Set", @"MV Total", @"Peak Pressure", @"Plateau Pressure", @"Mean Pressure", @"PEEP", @"Plow", @"PHigh", @"Pressure Support", @"Pressure Control", @"FiO2 Set", @"FiO2 Measured", @"Resistance", @"Compliance", @"Base Flow", @"Flow Sensitivity", @"Lower MV", @"High Pressure Alarm", @"Temperature", @"Relief Pressure", @"PE CO2", @"SpO2", @"RR", @"TV", @"MV", @"Max Pi", @"MVV", @"RSBI", @"ET Size", @"mark", @"Cuff pressure", @"Breath Sounds", @"PR", @"CVP", @"BPS", @"BPD"]

@interface HistoryCollectionViewController : UIViewController

@property (strong, nonatomic) DtoVentExchangeUploadBatch *batchData;

@end
