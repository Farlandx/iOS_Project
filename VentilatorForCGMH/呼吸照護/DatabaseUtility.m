//
//  DatabaseUtility.m
//  呼吸照護
//
//  Created by Farland on 2014/2/18.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DatabaseUtility.h"

@implementation DatabaseUtility

@synthesize databasePath;

- (id)init {
    self = [super init];
    if (self) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0]; //dirPaths[0]
        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent:@"measuredata.db"]];
    }
    return self;
}

#pragma mark - Private Methods
- (NSString *)getColumnString:(const char*)text {
    if (text == nil) {
        return @"";
    }
    return [NSString stringWithUTF8String:text];
}

#pragma mark - Public Methods
- (void) initDatabase {
//    NSString *docsDir;
//    NSArray *dirPaths;
//    
//    // Get the documents directory
//    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = [dirPaths objectAtIndex:0]; //dirPaths[0]
//    
//    // Build the path to the database file
//    databasePath = [[NSString alloc] initWithString:
//                    [docsDir stringByAppendingPathComponent:@"measuredata.db"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //the file will not be there when we load the application for the first time
    //so this will create the database table
    if ([fileManager fileExistsAtPath:databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
            char *errMsg;
            //建立量測資料table
            NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS MEASURE_DATA (";
            sql_stmt = [sql_stmt stringByAppendingString:@"MeasureId INTEGER PRIMARY KEY AUTOINCREMENT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"UploadId INTEGER, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"ChtNo TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RecordTime TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RecordIp TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RecordOper TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RecordDevice TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RecordClientVersion TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VentNo TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RawData TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VentilationMode TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"TidalVolumeSet TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VolumeTarget TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"TidalVolumeMeasured TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VentilationRateSet TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"SIMVRateSet TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VentilationRateTotal TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"InspT TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"THigh TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"InspirationExpirationRatio TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Tlow TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"AutoFlow TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"FlowSetting TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"FlowMeasured TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Pattern TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"MVSet TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PercentMinVolSet TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"MVTotal TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PeakPressure TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PlateauPressure TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"MeanPressure TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PEEP TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Plow TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PressureSupport TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PressureControl TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PHigh TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"FiO2Set TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"FiO2Measured TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Resistance TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Compliance TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"BaseFlow TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"FlowSensitivity TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"LowerMV TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"HighPressureAlarm TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Temperature TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"ReliefPressure TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PetCo2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"SpO2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RR TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"TV TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"MV TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"MaxPi TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Mvv TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Rsbi TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"EtSize TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Mark TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"CuffPressure TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"BreathSounds TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Pr TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Cvp TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"BpS TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"BpD TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Xrem TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"AutoPEEP TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PlateauTimeSetting TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"RecordOperName TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VentilatorModel TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"BedNo TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"ErrorMsg TEXT)"];

            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create MEASURE_DATA table.");
            }
            else {
                NSLog(@"MEASURE_DATA Table craeted successfully.");
            }
            
            //建立上傳資料table
            sql_stmt = @"CREATE TABLE IF NOT EXISTS UPLOAD_DATA (";
            sql_stmt = [sql_stmt stringByAppendingString:@"UploadId INTEGER PRIMARY KEY AUTOINCREMENT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"UploadOper TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"UploadIp TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"UploadTime TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Device TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"ClientVersion TEXT)"];
            
            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create UPLOAD_DATA table.");
            }
            else {
                NSLog(@"UPLOAD_DATA Table craeted successfully.");
            }
            
            //建立治療師卡號版本table
            sql_stmt = @"CREATE TABLE IF NOT EXISTS CARD_NO_VER_ID (Version INTEGER PRIMARY KEY)";
            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create CARD_NO_VER_ID table.");
            }
            else {
                NSLog(@"CARD_NO_VER_ID Table craeted successfully.");
            }
            
            //建立治療師卡號table
            sql_stmt = @"CREATE TABLE IF NOT EXISTS CARD_NO (CardNo TEXT PRIMARY KEY)";
            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create CardNo table.");
            }
            else {
                NSLog(@"CardNo Table craeted successfully.");
            }
            
            //建立病患table
            sql_stmt = @"CREATE TABLE IF NOT EXISTS PATIENT (ChtNo TEXT PRIMARY KEY, BedNo TEXT)";
            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create PATIENT table.");
            }
            else {
                NSLog(@"PATIENT Table craeted successfully.");
            }

            sqlite3_close(sqliteDb);
        }
        else {
            NSLog(@"Failed to open/create database.");
        }
    }
}

#pragma mark - MeasureData
- (BOOL) saveMeasure:(VentilationData *)measureData {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        if (measureData.MeasureId > 0) {
            NSLog(@"Existing data, Update.");
            NSString *updateSQL = @"UPDATE MEASURE_DATA ";
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET ChtNo = '%@', ", measureData.ChtNo]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordTime = '%@', ", measureData.RecordTime]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordIp = '%@', ", measureData.RecordIp]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordOper = '%@', ", measureData.RecordOper]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordDevice = '%@', ", measureData.RecordDevice]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordClientVersion = '%@', ", measureData.RecordClientVersion]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentNo = '%@', ", measureData.VentNo]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RawData = '%@', ", measureData.RawData]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentilationMode = '%@', ", measureData.VentilationMode]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"TidalVolumeSet = '%@', ", measureData.TidalVolumeSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VolumeTarget = '%@', ", measureData.VolumeTarget]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"TidalVolumeMeasured = '%@', ", measureData.TidalVolumeMeasured]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentilationRateSet = '%@', ", measureData.VentilationRateSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SIMVRateSet = '%@', ", measureData.SIMVRateSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentilationRateTotal = '%@', ", measureData.VentilationRateTotal]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"InspT = '%@', ", measureData.InspT]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"THigh = '%@', ", measureData.THigh]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"InspirationExpirationRatio = '%@', ", measureData.InspirationExpirationRatio]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Tlow = '%@', ", measureData.Tlow]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"THigh = '%@', ", measureData.THigh]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"FlowSetting = '%@', ", measureData.FlowSetting]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"FlowMeasured = '%@', ", measureData.FlowMeasured]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Pattern = '%@', ", measureData.Pattern]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"MVSet = '%@', ", measureData.MVSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PercentMinVolSet = '%@', ", measureData.PercentMinVolSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"MVTotal = '%@', ", measureData.MVTotal]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PeakPressure = '%@', ", measureData.PeakPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PlateauPressure = '%@', ", measureData.PlateauPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"MeanPressure = '%@', ", measureData.MeanPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PEEP = '%@', ", measureData.PEEP]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Plow = '%@', ", measureData.Plow]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PressureSupport = '%@', ", measureData.PressureSupport]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PressureControl = '%@', ", measureData.PressureControl]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PHigh = '%@', ", measureData.PHigh]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"FiO2Set = '%@', ", measureData.FiO2Set]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"FiO2Measured = '%@', ", measureData.FiO2Measured]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Resistance = '%@', ", measureData.Resistance]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Compliance = '%@', ", measureData.Compliance]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"BaseFlow = '%@', ", measureData.BaseFlow]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"FlowSensitivity = '%@', ", measureData.FlowSensitivity]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"LowerMV = '%@', ", measureData.LowerMV]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"HighPressureAlarm = '%@', ", measureData.HighPressureAlarm]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Temperature = '%@', ", measureData.Temperature]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"ReliefPressure = '%@', ", measureData.ReliefPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PetCo2 = '%@', ", measureData.PetCo2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SpO2 = '%@', ", measureData.SpO2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RR = '%@', ", measureData.RR]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"TV = '%@', ", measureData.TV]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"MV = '%@', ", measureData.MV]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"MaxPi = '%@', ", measureData.MaxPi]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Mvv = '%@', ", measureData.Mvv]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Rsbi = '%@', ", measureData.Rsbi]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"EtSize = '%@', ", measureData.EtSize]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Mark = '%@', ", measureData.Mark]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"CuffPressure = '%@', ", measureData.CuffPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"BreathSounds = '%@', ", measureData.BreathSounds]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Pr = '%@', ", measureData.Pr]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Cvp = '%@', ", measureData.Cvp]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"BpS = '%@', ", measureData.BpS]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"BpD = '%@', ", measureData.BpD]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Xrem = '%@', ", measureData.Xrem]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"AutoPEEP = '%@', ", measureData.AutoPEEP]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PlateauTimeSetting = '%@', ", measureData.PlateauTimeSetting]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordOperName = '%@', ", measureData.RecordOperName]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentilatorModel = '%@', ", measureData.VentilatorModel]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"BedNo = '%@', ", measureData.BedNo]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"ErrorMsg = '%@' ", measureData.ErrorMsg]];
            //結尾
            updateSQL = [updateSQL stringByAppendingString:@"WHERE MeasureId = ?"];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(sqliteDb, update_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, (int)measureData.MeasureId);
            if (sqlite3_step(statement)) {
                isSuccess = true;
            }
        }
        else {
            NSLog(@"New data, Insert.");
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO MEASURE_DATA (ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                   measureData.ChtNo,
                                   measureData.RecordTime,
                                   measureData.RecordIp,
                                   measureData.RecordOper,
                                   measureData.RecordDevice,
                                   measureData.RecordClientVersion,
                                   measureData.VentNo,
                                   measureData.RawData,
                                   measureData.VentilationMode,
                                   measureData.TidalVolumeSet,
                                   measureData.VolumeTarget,
                                   measureData.TidalVolumeMeasured,
                                   measureData.VentilationRateSet,
                                   measureData.SIMVRateSet,
                                   measureData.VentilationRateTotal,
                                   measureData.InspT,
                                   measureData.THigh,
                                   measureData.InspirationExpirationRatio,
                                   measureData.Tlow,
                                   measureData.AutoFlow,
                                   measureData.FlowSetting,
                                   measureData.FlowMeasured,
                                   measureData.Pattern,
                                   measureData.MVSet,
                                   measureData.PercentMinVolSet,
                                   measureData.MVTotal,
                                   measureData.PeakPressure,
                                   measureData.PlateauPressure,
                                   measureData.MeanPressure,
                                   measureData.PEEP,
                                   measureData.Plow,
                                   measureData.PressureSupport,
                                   measureData.PressureControl,
                                   measureData.PHigh,
                                   measureData.FiO2Set,
                                   measureData.FiO2Measured,
                                   measureData.Resistance,
                                   measureData.Compliance,
                                   measureData.BaseFlow,
                                   measureData.FlowSensitivity,
                                   measureData.LowerMV,
                                   measureData.HighPressureAlarm,
                                   measureData.Temperature,
                                   measureData.ReliefPressure,
                                   measureData.PetCo2,
                                   measureData.SpO2,
                                   measureData.RR,
                                   measureData.TV,
                                   measureData.MV,
                                   measureData.MaxPi,
                                   measureData.Mvv,
                                   measureData.Rsbi,
                                   measureData.EtSize,
                                   measureData.Mark,
                                   measureData.CuffPressure,
                                   measureData.BreathSounds,
                                   measureData.Pr,
                                   measureData.Cvp,
                                   measureData.BpS,
                                   measureData.BpD,
                                   measureData.Xrem,
                                   measureData.AutoPEEP,
                                   measureData.PlateauTimeSetting,
                                   measureData.RecordOperName,
                                   measureData.VentilatorModel,
                                   measureData.BedNo,
                                   measureData.ErrorMsg];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
            int sqliteState = sqlite3_step(statement);
            if (sqliteState == SQLITE_DONE) {
                isSuccess = true;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return isSuccess;
}

- (NSMutableArray *) getMeasures {
    NSMutableArray *measureList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = @"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg FROM MEASURE_DATA WHERE UploadId IS NULL OR UploadId = ''";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                VentilationData *measureData = [[VentilationData alloc] init];
                measureData.MeasureId = sqlite3_column_int(statement, 0);
                measureData.ChtNo = [self getColumnString:(char *)sqlite3_column_text(statement, 1)];
                measureData.RecordTime = [self getColumnString:(char *)sqlite3_column_text(statement, 2)];
                measureData.RecordIp = [self getColumnString:(char *)sqlite3_column_text(statement, 3)];
                measureData.RecordOper = [self getColumnString:(char *)sqlite3_column_text(statement, 4)];
                measureData.RecordDevice = [self getColumnString:(char *)sqlite3_column_text(statement, 5)];
                measureData.RecordClientVersion = [self getColumnString:(char *)sqlite3_column_text(statement, 6)];
                measureData.VentNo = [self getColumnString:(char *)sqlite3_column_text(statement, 7)];
                measureData.RawData = [self getColumnString:(char *)sqlite3_column_text(statement, 8)];
                measureData.VentilationMode = [self getColumnString:(char *)sqlite3_column_text(statement, 9)];
                measureData.TidalVolumeSet = [self getColumnString:(char *)sqlite3_column_text(statement, 10)];
                measureData.VolumeTarget = [self getColumnString:(char *)sqlite3_column_text(statement, 11)];
                measureData.TidalVolumeMeasured = [self getColumnString:(char *)sqlite3_column_text(statement, 12)];
                measureData.VentilationRateSet = [self getColumnString:(char *)sqlite3_column_text(statement, 13)];
                measureData.SIMVRateSet = [self getColumnString:(char *)sqlite3_column_text(statement, 14)];
                measureData.VentilationRateTotal = [self getColumnString:(char *)sqlite3_column_text(statement, 15)];
                measureData.InspT = [self getColumnString:(char *)sqlite3_column_text(statement, 16)];
                measureData.THigh = [self getColumnString:(char *)sqlite3_column_text(statement, 17)];
                measureData.InspirationExpirationRatio = [self getColumnString:(char *)sqlite3_column_text(statement, 18)];
                measureData.Tlow = [self getColumnString:(char *)sqlite3_column_text(statement, 19)];
                measureData.AutoFlow = [self getColumnString:(char *)sqlite3_column_text(statement, 20)];
                measureData.FlowSetting = [self getColumnString:(char *)sqlite3_column_text(statement, 21)];
                measureData.FlowMeasured = [self getColumnString:(char *)sqlite3_column_text(statement, 22)];
                measureData.Pattern = [self getColumnString:(char *)sqlite3_column_text(statement, 23)];
                measureData.MVSet = [self getColumnString:(char *)sqlite3_column_text(statement, 24)];
                measureData.PercentMinVolSet = [self getColumnString:(char *)sqlite3_column_text(statement, 25)];
                measureData.MVTotal = [self getColumnString:(char *)sqlite3_column_text(statement, 26)];
                measureData.PeakPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 27)];
                measureData.PlateauPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 28)];
                measureData.MeanPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 29)];
                measureData.PEEP = [self getColumnString:(char *)sqlite3_column_text(statement, 30)];
                measureData.Plow = [self getColumnString:(char *)sqlite3_column_text(statement, 31)];
                measureData.PressureSupport = [self getColumnString:(char *)sqlite3_column_text(statement, 32)];
                measureData.PressureControl = [self getColumnString:(char *)sqlite3_column_text(statement, 33)];
                measureData.PHigh = [self getColumnString:(char *)sqlite3_column_text(statement, 34)];
                measureData.FiO2Set = [self getColumnString:(char *)sqlite3_column_text(statement, 35)];
                measureData.FiO2Measured = [self getColumnString:(char *)sqlite3_column_text(statement, 36)];
                measureData.Resistance = [self getColumnString:(char *)sqlite3_column_text(statement, 37)];
                measureData.Compliance = [self getColumnString:(char *)sqlite3_column_text(statement, 38)];
                measureData.BaseFlow = [self getColumnString:(char *)sqlite3_column_text(statement, 39)];
                measureData.FlowSensitivity = [self getColumnString:(char *)sqlite3_column_text(statement, 40)];
                measureData.LowerMV = [self getColumnString:(char *)sqlite3_column_text(statement, 41)];
                measureData.HighPressureAlarm = [self getColumnString:(char *)sqlite3_column_text(statement, 42)];
                measureData.Temperature = [self getColumnString:(char *)sqlite3_column_text(statement, 43)];
                measureData.ReliefPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 44)];
                measureData.PetCo2 = [self getColumnString:(char *)sqlite3_column_text(statement, 45)];
                measureData.SpO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 46)];
                measureData.RR = [self getColumnString:(char *)sqlite3_column_text(statement, 47)];
                measureData.TV = [self getColumnString:(char *)sqlite3_column_text(statement, 48)];
                measureData.MV = [self getColumnString:(char *)sqlite3_column_text(statement, 49)];
                measureData.MaxPi = [self getColumnString:(char *)sqlite3_column_text(statement, 50)];
                measureData.Mvv = [self getColumnString:(char *)sqlite3_column_text(statement, 51)];
                measureData.Rsbi = [self getColumnString:(char *)sqlite3_column_text(statement, 52)];
                measureData.EtSize = [self getColumnString:(char *)sqlite3_column_text(statement, 53)];
                measureData.Mark = [self getColumnString:(char *)sqlite3_column_text(statement, 54)];
                measureData.CuffPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 55)];
                measureData.BreathSounds = [self getColumnString:(char *)sqlite3_column_text(statement, 56)];
                measureData.Pr = [self getColumnString:(char *)sqlite3_column_text(statement, 57)];
                measureData.Cvp = [self getColumnString:(char *)sqlite3_column_text(statement, 58)];
                measureData.BpS = [self getColumnString:(char *)sqlite3_column_text(statement, 59)];
                measureData.BpD = [self getColumnString:(char *)sqlite3_column_text(statement, 60)];
                measureData.Xrem = [self getColumnString:(char *)sqlite3_column_text(statement, 61)];
                measureData.AutoPEEP = [self getColumnString:(char *)sqlite3_column_text(statement, 62)];
                measureData.PlateauTimeSetting = [self getColumnString:(char *)sqlite3_column_text(statement, 63)];
                measureData.RecordOperName = [self getColumnString:(char *)sqlite3_column_text(statement, 64)];
                measureData.VentilatorModel = [self getColumnString:(char *)sqlite3_column_text(statement, 65)];
                measureData.BedNo = [self getColumnString:(char *)sqlite3_column_text(statement, 66)];
                measureData.ErrorMsg = [self getColumnString:(char *)sqlite3_column_text(statement, 67)];
                [measureList addObject:measureData];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return measureList;
}

- (VentilationData *) getMeasureDataById:(NSInteger)measureId {
    VentilationData *measureData = [[VentilationData alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM MEASURE_DATA WHERE MeasureId = %d", (int)measureId];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                measureData.MeasureId = sqlite3_column_int(statement, 0);
                measureData.ChtNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                measureData.RecordTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                measureData.RecordIp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                measureData.RecordOper = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                measureData.RecordDevice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                measureData.RecordClientVersion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                measureData.VentNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                measureData.RawData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                measureData.VentilationMode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                measureData.TidalVolumeSet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                measureData.VolumeTarget = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                measureData.TidalVolumeMeasured = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                measureData.VentilationRateSet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                measureData.SIMVRateSet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                measureData.VentilationRateTotal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                measureData.InspT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                measureData.THigh = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                measureData.InspirationExpirationRatio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                measureData.Tlow = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                measureData.AutoFlow = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                measureData.FlowSetting = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                measureData.FlowMeasured = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                measureData.Pattern = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                measureData.MVSet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                measureData.PercentMinVolSet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                measureData.MVTotal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                measureData.PeakPressure = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                measureData.PlateauPressure = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                measureData.MeanPressure = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                measureData.PEEP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
                measureData.Plow = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                measureData.PressureSupport = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)];
                measureData.PressureControl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)];
                measureData.PHigh = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)];
                measureData.FiO2Set = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                measureData.FiO2Measured = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                measureData.Resistance = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                measureData.Compliance = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)];
                measureData.BaseFlow = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)];
                measureData.FlowSensitivity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)];
                measureData.LowerMV = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)];
                measureData.HighPressureAlarm = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)];
                measureData.Temperature = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)];
                measureData.ReliefPressure = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 44)];
                measureData.PetCo2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 45)];
                measureData.SpO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 46)];
                measureData.RR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 47)];
                measureData.TV = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)];
                measureData.MV = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)];
                measureData.MaxPi = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 50)];
                measureData.Mvv = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 51)];
                measureData.Rsbi = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 52)];
                measureData.EtSize = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 53)];
                measureData.Mark = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 54)];
                measureData.CuffPressure = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 55)];
                measureData.BreathSounds = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 56)];
                measureData.Pr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 57)];
                measureData.Cvp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 58)];
                measureData.BpS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 59)];
                measureData.BpD = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 60)];
                measureData.Xrem = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 61)];
                measureData.AutoPEEP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 62)];
                measureData.PlateauTimeSetting = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 63)];
                measureData.RecordOperName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 64)];
                measureData.VentilatorModel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 65)];
                measureData.BedNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 66)];
                measureData.ErrorMsg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 67)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return measureData;
}

- (BOOL) deleteMeasure:(VentilationData *)measureData {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        if (measureData.MeasureId > 0) {
            NSLog(@"Existing data, Delete.");
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM MEASURE_DATA WHERE MeasureId = ?"];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, (int)measureData.MeasureId);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                isSuccess = true;
            }
        }
        else {
            NSLog(@"New data, nothing to delete.");
            isSuccess = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return isSuccess;
}

- (void) deleteMeasuresByUploadId:(int)uploadId {
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM MEASURE_DATA WHERE UploadId = ?"];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
        sqlite3_bind_int(statement, 1, uploadId);
        int foo = sqlite3_step(statement);
        if (foo != SQLITE_DONE) {
            NSLog(@"Error. %s", __func__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
}

#pragma mark - UploadData
- (BOOL)saveUploadData:(DtoVentExchangeUploadBatch *)uploadData {
    if (uploadData.VentRecList.count == 0) {
        return false;
    }
    BOOL isSuccess = false;
    BOOL isUpdateAllSuccess = true;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSLog(@"New upload data, Insert.");
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO UPLOAD_DATA (UploadOper, UploadIp, UploadTime, Device, ClientVersion) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                               uploadData.UploadOper,
                               uploadData.UploadIp,
                               uploadData.UploadTime,
                               uploadData.Device,
                               uploadData.ClientVersion];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
        int sqliteState = sqlite3_step(statement);
        if (sqliteState == SQLITE_DONE) {
            isSuccess = true;
        }
        
        if (isSuccess) {
            long long int lastRowId = sqlite3_last_insert_rowid(sqliteDb);
            
            for (VentilationData *vData in uploadData.VentRecList) {
                if (vData.MeasureId > 0) {
                    NSString *updateSQL = @"UPDATE MEASURE_DATA ";
                    updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET UploadId = '%lld', ", lastRowId]];
                    updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"RecordOperName = '%@', ", vData.RecordOperName]];
                    updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentilatorModel = '%@', ", vData.VentilatorModel]];
                    updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"BedNo = '%@' ", vData.BedNo]];
                    
                    //結尾
                    updateSQL = [updateSQL stringByAppendingString:@"WHERE MeasureId = ?"];
                    
                    const char *update_stmt = [updateSQL UTF8String];
                    sqlite3_prepare_v2(sqliteDb, update_stmt, -1, &statement, NULL);
                    sqlite3_bind_int(statement, 1, (int)vData.MeasureId);
                    if(!sqlite3_step(statement)) {
                        isUpdateAllSuccess = false;
                    }
                }
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(sqliteDb);
    
    return isSuccess || isUpdateAllSuccess;
}

- (NSMutableArray *) getUploadHistories {
    NSMutableArray *batchList = [[NSMutableArray alloc] init];
    NSMutableArray *measureList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    //刪除過期資料
    [self deleteExpiredHistories];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        //取得上傳記錄
        NSString *querySQL = @"SELECT UploadId, UploadOper, UploadIp, UploadTime, Device, ClientVersion FROM UPLOAD_DATA ORDER BY UploadTime";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                DtoVentExchangeUploadBatch *batch = [[DtoVentExchangeUploadBatch alloc] init];
                batch.UploadId = sqlite3_column_int(statement, 0);
                batch.UploadOper = [self getColumnString:(char *)sqlite3_column_text(statement, 1)];
                batch.UploadIp = [self getColumnString:(char *)sqlite3_column_text(statement, 2)];
                batch.UploadTime =  [self getColumnString:(char *)sqlite3_column_text(statement, 3)];
                batch.Device = [self getColumnString:(char *)sqlite3_column_text(statement, 4)];
                batch.ClientVersion = [self getColumnString:(char *)sqlite3_column_text(statement, 5)];
                
                [batchList addObject:batch];
            }
        }
        
        for (int i = 0;i < batchList.count; i++) {
            querySQL = [NSString stringWithFormat:@"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg FROM MEASURE_DATA WHERE UploadId = %ld ORDER BY RecordTime DESC", ((DtoVentExchangeUploadBatch *)batchList[i]).UploadId];
            query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    VentilationData *measureData = [[VentilationData alloc] init];
                    measureData.MeasureId = sqlite3_column_int(statement, 0);
                    measureData.ChtNo = [self getColumnString:(char *)sqlite3_column_text(statement, 1)];
                    measureData.RecordTime = [self getColumnString:(char *)sqlite3_column_text(statement, 2)];
                    measureData.RecordIp = [self getColumnString:(char *)sqlite3_column_text(statement, 3)];
                    measureData.RecordOper = [self getColumnString:(char *)sqlite3_column_text(statement, 4)];
                    measureData.RecordDevice = [self getColumnString:(char *)sqlite3_column_text(statement, 5)];
                    measureData.RecordClientVersion = [self getColumnString:(char *)sqlite3_column_text(statement, 6)];
                    measureData.VentNo = [self getColumnString:(char *)sqlite3_column_text(statement, 7)];
                    measureData.RawData = [self getColumnString:(char *)sqlite3_column_text(statement, 8)];
                    measureData.VentilationMode = [self getColumnString:(char *)sqlite3_column_text(statement, 9)];
                    measureData.TidalVolumeSet = [self getColumnString:(char *)sqlite3_column_text(statement, 10)];
                    measureData.VolumeTarget = [self getColumnString:(char *)sqlite3_column_text(statement, 11)];
                    measureData.TidalVolumeMeasured = [self getColumnString:(char *)sqlite3_column_text(statement, 12)];
                    measureData.VentilationRateSet = [self getColumnString:(char *)sqlite3_column_text(statement, 13)];
                    measureData.SIMVRateSet = [self getColumnString:(char *)sqlite3_column_text(statement, 14)];
                    measureData.VentilationRateTotal = [self getColumnString:(char *)sqlite3_column_text(statement, 15)];
                    measureData.InspT = [self getColumnString:(char *)sqlite3_column_text(statement, 16)];
                    measureData.THigh = [self getColumnString:(char *)sqlite3_column_text(statement, 17)];
                    measureData.InspirationExpirationRatio = [self getColumnString:(char *)sqlite3_column_text(statement, 18)];
                    measureData.Tlow = [self getColumnString:(char *)sqlite3_column_text(statement, 19)];
                    measureData.AutoFlow = [self getColumnString:(char *)sqlite3_column_text(statement, 20)];
                    measureData.FlowSetting = [self getColumnString:(char *)sqlite3_column_text(statement, 21)];
                    measureData.FlowMeasured = [self getColumnString:(char *)sqlite3_column_text(statement, 22)];
                    measureData.Pattern = [self getColumnString:(char *)sqlite3_column_text(statement, 23)];
                    measureData.MVSet = [self getColumnString:(char *)sqlite3_column_text(statement, 24)];
                    measureData.PercentMinVolSet = [self getColumnString:(char *)sqlite3_column_text(statement, 25)];
                    measureData.MVTotal = [self getColumnString:(char *)sqlite3_column_text(statement, 26)];
                    measureData.PeakPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 27)];
                    measureData.PlateauPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 28)];
                    measureData.MeanPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 29)];
                    measureData.PEEP = [self getColumnString:(char *)sqlite3_column_text(statement, 30)];
                    measureData.Plow = [self getColumnString:(char *)sqlite3_column_text(statement, 31)];
                    measureData.PressureSupport = [self getColumnString:(char *)sqlite3_column_text(statement, 32)];
                    measureData.PressureControl = [self getColumnString:(char *)sqlite3_column_text(statement, 33)];
                    measureData.PHigh = [self getColumnString:(char *)sqlite3_column_text(statement, 34)];
                    measureData.FiO2Set = [self getColumnString:(char *)sqlite3_column_text(statement, 35)];
                    measureData.FiO2Measured = [self getColumnString:(char *)sqlite3_column_text(statement, 36)];
                    measureData.Resistance = [self getColumnString:(char *)sqlite3_column_text(statement, 37)];
                    measureData.Compliance = [self getColumnString:(char *)sqlite3_column_text(statement, 38)];
                    measureData.BaseFlow = [self getColumnString:(char *)sqlite3_column_text(statement, 39)];
                    measureData.FlowSensitivity = [self getColumnString:(char *)sqlite3_column_text(statement, 40)];
                    measureData.LowerMV = [self getColumnString:(char *)sqlite3_column_text(statement, 41)];
                    measureData.HighPressureAlarm = [self getColumnString:(char *)sqlite3_column_text(statement, 42)];
                    measureData.Temperature = [self getColumnString:(char *)sqlite3_column_text(statement, 43)];
                    measureData.ReliefPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 44)];
                    measureData.PetCo2 = [self getColumnString:(char *)sqlite3_column_text(statement, 45)];
                    measureData.SpO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 46)];
                    measureData.RR = [self getColumnString:(char *)sqlite3_column_text(statement, 47)];
                    measureData.TV = [self getColumnString:(char *)sqlite3_column_text(statement, 48)];
                    measureData.MV = [self getColumnString:(char *)sqlite3_column_text(statement, 49)];
                    measureData.MaxPi = [self getColumnString:(char *)sqlite3_column_text(statement, 50)];
                    measureData.Mvv = [self getColumnString:(char *)sqlite3_column_text(statement, 51)];
                    measureData.Rsbi = [self getColumnString:(char *)sqlite3_column_text(statement, 52)];
                    measureData.EtSize = [self getColumnString:(char *)sqlite3_column_text(statement, 53)];
                    measureData.Mark = [self getColumnString:(char *)sqlite3_column_text(statement, 54)];
                    measureData.CuffPressure = [self getColumnString:(char *)sqlite3_column_text(statement, 55)];
                    measureData.BreathSounds = [self getColumnString:(char *)sqlite3_column_text(statement, 56)];
                    measureData.Pr = [self getColumnString:(char *)sqlite3_column_text(statement, 57)];
                    measureData.Cvp = [self getColumnString:(char *)sqlite3_column_text(statement, 58)];
                    measureData.BpS = [self getColumnString:(char *)sqlite3_column_text(statement, 59)];
                    measureData.BpD = [self getColumnString:(char *)sqlite3_column_text(statement, 60)];
                    measureData.Xrem = [self getColumnString:(char *)sqlite3_column_text(statement, 61)];
                    measureData.AutoPEEP = [self getColumnString:(char *)sqlite3_column_text(statement, 62)];
                    measureData.PlateauTimeSetting = [self getColumnString:(char *)sqlite3_column_text(statement, 63)];
                    measureData.RecordOperName = [self getColumnString:(char *)sqlite3_column_text(statement, 64)];
                    measureData.VentilatorModel = [self getColumnString:(char *)sqlite3_column_text(statement, 65)];
                    measureData.BedNo = [self getColumnString:(char *)sqlite3_column_text(statement, 66)];
                    measureData.ErrorMsg = [self getColumnString:(char *)sqlite3_column_text(statement, 67)];
                    [measureList addObject:measureData];
                }
            }
            ((DtoVentExchangeUploadBatch *)batchList[i]).VentRecList = measureList;
        }
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return batchList;
}

- (void) deleteUploadHistoryByUploadId:(int)uploadId {
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM UPLOAD_DATA WHERE UploadId = ?"];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
        sqlite3_bind_int(statement, 1, uploadId);
        int foo = sqlite3_step(statement);
        if (foo != SQLITE_DONE) {
            NSLog(@"Error. %s", __func__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
}

- (void) deleteExpiredHistories {
    NSMutableArray *uploadIdArray = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        //取得三天前的上傳記錄
        NSDateComponents *dateComponets = [[NSDateComponents alloc] init];
        [dateComponets setDay:-3];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT UploadId FROM UPLOAD_DATA WHERE UploadTime < '%@'", [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]]];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [uploadIdArray addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)]];
            }
        }
        
        if (uploadIdArray.count) {
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM UPLOAD_DATA WHERE UploadId = ?"];
            
            for (NSNumber *uploadId in uploadIdArray) {
                //Delete UploadHistory
                const char *delete_stmt = [deleteSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
                sqlite3_bind_int(statement, 1, [uploadId intValue]);
                int foo = sqlite3_step(statement);
                if (foo != SQLITE_DONE) {
                    NSLog(@"Error. %@ (%s)", deleteSQL, __func__);
                }
                
                //Delete MeasureData
                [self deleteMeasuresByUploadId:[uploadId intValue]];
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
}

#pragma mark - CurRtCardListVerId
- (int) getCurRtCardListVerId {
    int result = -1;    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = @"SELECT Version FROM CARD_NO_VER_ID";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                result = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return result;
}

- (BOOL) deleteCurRtCardListVerId {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        //刪掉所有的ID資料
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM CARD_NO_VER_ID"];
        
//        const char *delete_stmt = [deleteSQL UTF8String];
//        sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
//        sqlite3_bind_int(statement, 1, (int)measureData.MeasureId);
//        if (sqlite3_step(statement) == SQLITE_DONE) {
//            isSuccess = true;
//        }
        char *errMsg;
        if (sqlite3_exec(sqliteDb, [deleteSQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = true;
        }
        else {
            NSLog(@"Delete Error:%s", errMsg);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return isSuccess;
}

- (BOOL) saveCurRtCardListVerId:(int)Id {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    [self deleteCurRtCardListVerId];
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CARD_NO_VER_ID (Version) VALUES (%d)", Id];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
        int sqliteState = sqlite3_step(statement);
        if (sqliteState == SQLITE_DONE) {
            isSuccess = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return isSuccess;
}

#pragma mark - CurRtCardList
- (void) saveCurRtCardList:(NSArray *)data {
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (data.count > 0) {
        [self deleteCurRtCardList];
        if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
            for (NSString *str in data) {
                NSString *insertSQL = [NSString stringWithFormat:
                                       @"INSERT INTO CARD_NO (CardNo) VALUES ('%@')", str];
                
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
                int sqliteState = sqlite3_step(statement);
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
}

- (BOOL) deleteCurRtCardList {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        //刪掉所有資料
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM CARD_NO"];
        
        char *errMsg;
        if (sqlite3_exec(sqliteDb, [deleteSQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            isSuccess = true;
        }
        else {
            NSLog(@"Delete Error:%s", errMsg);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return isSuccess;
}


- (NSMutableArray *) getCurRtCardList {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = @"SELECT Version FROM CARD_NO_VER_ID";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [result addObject:[self getColumnString:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return result;
}

@end
