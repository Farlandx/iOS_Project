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
//#define ARRAY_TITLE @[@"床號", @"治療師", @"呼吸器", @"Ventilation Mode", @"TidalVolume Set", @"Tidal Volume", @"Volume Target", @"Ventilation Rate Set", @"Ventilation Rate Total", @"SIMV Rate Set", @"InspT", @"THigh", @"Tlow", @"I:E Ratio", @"Auto Flow", @"Flow Setting", @"Flow Measured", @"Pattern", @"MV Set", @"Percent MinVol Set", @"MV Total", @"Peak Pressure", @"Plateau Pressure", @"Mean Pressure", @"PEEP", @"Plow", @"PHigh", @"Pressure Support", @"Pressure Control", @"FiO2 Set", @"FiO2 Measured", @"Resistance", @"Compliance", @"Base Flow", @"Flow Sensitivity", @"Lower MV", @"High Pressure Alarm", @"Temperature", @"Relief Pressure", @"PE CO2", @"SpO2", @"RR", @"TV", @"MV", @"Max Pi", @"MVV", @"RSBI", @"ET Size", @"mark", @"Cuff pressure", @"Breath Sounds", @"PR", @"CVP", @"BPS", @"BPD", @"VentilationHertz", @"PressureAmplitude", @"TubeCompensation", @"VolumeAssist", @"FlowAssist", @"EdiPeak", @"EdiMin", @"NavaLevel", @"EdiTrigger", @"NO", @"NO2", @"LeakTest", @"Be", @"HCO3", @"PAAO2", @"PaCO2", @"PaO2", @"PetCo2", @"PfRatio", @"Ph", @"SaO2", @"Shunt", @"Site", @"SpO2"]
#define ARRAY_TITLE @[@"床號", @"病歷號", @"呼吸器", @"Ventilation Mode", @"TidalVolume Set", @"TidalVolume Measured", @"Resp. Rate Set/Total", @"Hertz", @"Flow/NO/NO₂(ppm)", @"Insp. T / I:E", @"MV Set/MinVol%/Total", @"Peak/Plateau", @"Mean/PEEP", @"P.S/P.C/amplitude(△P)", @"Temp/Tube compen.%", @"FiO₂ Set/Measured", @"Resistance/Compliance", @"Base Flow/Flow sens", @"Volume/Flow Assist", @"Edi peak/min", @"NAVA Level/Edi trigger", @"L. MV/ H. Pr. Alarm", @"Relief Pr.", @"時間", @"PH", @"PaCO2 / PetCO2", @"PaO₂ / Site", @"HCO₃ / BE", @"SaO₂ / SpO₂", @"PA-aO₂ / Shunt", @"P/F ratio", @"RR/OI", @"TV/MV", @"Max Pi/Pe", @"MVV/VC", @"RSBI", @"ET Size/mark", @"Cuff pressure/leak test", @"Breath Sound", @"PR/CVP", @"BP(S/D)", @"治療師"]

@interface HistoryCollectionViewController : UIViewController

@property (strong, nonatomic) NSString *ChtNo;

@end
