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
#define DICT_TITLE @{@1:@"床號", @2:@"治療師", @3:@"呼吸器", @4:@"Ventilation Mode", @5:@"TidalVolume Set", @6:@"Tidal Volume", @7:@"Volume Target", @8:@"Ventilation Rate Set", @9:@"Ventilation Rate Total", @10:@"SIMV Rate Set", @11:@"InspT", @12:@"THigh", @13:@"Tlow", @14:@"I:E Ratio", @15:@"Auto Flow", @16:@"Flow Setting", @17:@"Flow Measured", @18:@"Pattern", @19:@"MV Set", @20:@"Percent MinVol Set", @21:@"MV Total", @22:@"Peak Pressure", @23:@"Plateau Pressure", @24:@"Mean Pressure", @25:@"PEEP", @26:@"Plow", @27:@"PHigh", @28:@"Pressure", @29:@"Support", @30:@"Pressure Control", @31:@"FiO2 Set", @32:@"FiO2 Measured", @33:@"Resistance", @34:@"Compliance", @35:@"Base Flow", @36:@"Flow Sensitivity", @37:@"Lower MV", @38:@"High Pressure Alarm", @39:@"Temperature", @40:@"Relief Pressure", @41:@"PE CO2", @42:@"SpO2", @43:@"RR", @44:@"TV", @45:@"MV", @46:@"Max Pi", @47:@"MVV", @48:@"RSBI", @49:@"ET Size", @50:@"mark", @51:@"Cuff pressure", @52:@"Breath Sounds", @53:@"PR", @54:@"CVP", @55:@"BPS", @56:@"BPD"}
#define ARRAY_TITLE @[@"床號", @"治療師", @"呼吸器", @"Ventilation Mode", @"TidalVolume Set", @"Tidal Volume", @"Volume Target", @"Ventilation Rate Set", @"Ventilation Rate Total", @"SIMV Rate Set", @"InspT", @"THigh", @"Tlow", @"I:E Ratio", @"Auto Flow", @"Flow Setting", @"Flow Measured", @"Pattern", @"MV Set", @"Percent MinVol Set", @"MV Total", @"Peak Pressure", @"Plateau Pressure", @"Mean Pressure", @"PEEP", @"Plow", @"PHigh", @"Pressure Support", @"Pressure Control", @"FiO2 Set", @"FiO2 Measured", @"Resistance", @"Compliance", @"Base Flow", @"Flow Sensitivity", @"Lower MV", @"High Pressure Alarm", @"Temperature", @"Relief Pressure", @"PE CO2", @"SpO2", @"RR", @"TV", @"MV", @"Max Pi", @"MVV", @"RSBI", @"ET Size", @"mark", @"Cuff pressure", @"Breath Sounds", @"PR", @"CVP", @"BPS", @"BPD"]

@interface HistoryCollectionViewController : UIViewController

@property (strong, nonatomic) DtoVentExchangeUploadBatch *batchData;

@end
