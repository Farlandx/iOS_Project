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


#pragma mark - Private Methods

#pragma mark - Public Methods
- (void) initDatabase {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0]; //dirPaths[0]
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingString:@"measuredata.db"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //the file will not be there when we load the application for the first time
    //so this will create the database table
    if ([fileManager fileExistsAtPath:databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
            char *errMsg;
            NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS MEASURE_DATA (";
            sql_stmt = [sql_stmt stringByAppendingString:@"MeasureId INTEGER PROMARY KEY AUTOINCREMENT, "];
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
                NSLog(@"Failed to create table.");
            }
            else {
                NSLog(@"MEASURE_DATA Table craeted successfully.");
            }

            sqlite3_close(sqliteDb);
        }
        else {
            NSLog(@"Failed to open/create database.");
        }
    }
}

- (BOOL) saveMeasure:(MeasureData *)measureData {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        if (measureData.MeasureId > 0) {
            NSLog(@"Existing data, Update.");
            NSString *updateSQL = @"UPDATE MEASURE_DATA ";
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET ChtNo = %@, ", measureData.ChtNo]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RecordTime = %@, ", measureData.RecordTime]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RecordIp = %@, ", measureData.RecordIp]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RecordOper = %@, ", measureData.RecordOper]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RecordDevice = %@, ", measureData.RecordDevice]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RecordClientVersion = %@, ", measureData.RecordClientVersion]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET VentNo = %@, ", measureData.VentNo]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RawData = %@, ", measureData.RawData]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET VentilationMode = %@, ", measureData.VentilationMode]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET TidalVolumeSet = %@, ", measureData.TidalVolumeSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET VolumeTarget = %@, ", measureData.VolumeTarget]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET TidalVolumeMeasured = %@, ", measureData.TidalVolumeMeasured]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET VentilationRateSet = %@, ", measureData.VentilationRateSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET SIMVRateSet = %@, ", measureData.SIMVRateSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET VentilationRateTotal = %@, ", measureData.VentilationRateTotal]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET InspT = %@, ", measureData.InspT]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET THigh = %@, ", measureData.THigh]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET InspirationExpirationRatio = %@, ", measureData.InspirationExpirationRatio]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Tlow = %@, ", measureData.Tlow]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET THigh = %@, ", measureData.THigh]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET FlowSetting = %@, ", measureData.FlowSetting]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET FlowMeasured = %@, ", measureData.FlowMeasured]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Pattern = %@, ", measureData.Pattern]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET MVSet = %@, ", measureData.MVSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PercentMinVolSet = %@, ", measureData.PercentMinVolSet]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET MVTotal = %@, ", measureData.MVTotal]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PeakPressure = %@, ", measureData.PeakPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PlateauPressure = %@, ", measureData.PlateauPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET MeanPressure = %@, ", measureData.MeanPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PEEP = %@, ", measureData.PEEP]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Plow = %@, ", measureData.Plow]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PressureSupport = %@, ", measureData.PressureSupport]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PressureControl = %@, ", measureData.PressureControl]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PHigh = %@, ", measureData.PHigh]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET FiO2Set = %@, ", measureData.FiO2Set]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET FiO2Measured = %@, ", measureData.FiO2Measured]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Resistance = %@, ", measureData.Resistance]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Compliance = %@, ", measureData.Compliance]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET BaseFlow = %@, ", measureData.BaseFlow]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET FlowSensitivity = %@, ", measureData.FlowSensitivity]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET LowerMV = %@, ", measureData.LowerMV]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET HighPressureAlarm = %@, ", measureData.HighPressureAlarm]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Temperature = %@, ", measureData.Temperature]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET ReliefPressure = %@, ", measureData.ReliefPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PetCo2 = %@, ", measureData.PetCo2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET SpO2 = %@, ", measureData.SpO2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RR = %@, ", measureData.RR]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET TV = %@, ", measureData.TV]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET MV = %@, ", measureData.MV]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET MaxPi = %@, ", measureData.MaxPi]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Mvv = %@, ", measureData.Mvv]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Rsbi = %@, ", measureData.Rsbi]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET EtSize = %@, ", measureData.EtSize]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Mark = %@, ", measureData.Mark]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET CuffPressure = %@, ", measureData.CuffPressure]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET BreathSounds = %@, ", measureData.BreathSounds]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Pr = %@, ", measureData.Pr]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Cvp = %@, ", measureData.Cvp]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET BpS = %@, ", measureData.BpS]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET BpD = %@, ", measureData.BpD]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET Xrem = %@, ", measureData.Xrem]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET AutoPEEP = %@, ", measureData.AutoPEEP]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET PlateauTimeSetting = %@, ", measureData.PlateauTimeSetting]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET RecordOperName = %@, ", measureData.RecordOperName]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET VentilatorModel = %@, ", measureData.VentilatorModel]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET BedNo = %@, ", measureData.BedNo]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET ErrorMsg = %@, ", measureData.ErrorMsg]];
            //結尾
            updateSQL = [updateSQL stringByAppendingString:@"WHERE MeasureId = ?"];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(sqliteDb, update_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, measureData.MeasureId);
            if (sqlite3_step(statement)) {
                isSuccess = true;
            }
        }
        else {
            NSLog(@"New data, Insert.");
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO MEASURE_DATA (ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRa, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg), VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
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
            if (sqlite3_step(statement) == SQLITE_DONE) {
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
        NSString *querySQL = @"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRa, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg FROM MEASURE_DATA";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                MeasureData *measureData = [[MeasureData alloc] init];
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
                [measureList addObject:measureData];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return measureList;
}

- (MeasureData *) getMeasureDataById:(NSInteger)measureId {
    MeasureData *measureData = [[MeasureData alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM MEASURE_DATA WHERE MeasureId = %d", measureId];
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

- (BOOL) deleteMeasure:(MeasureData *)measureData {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        if (measureData.MeasureId > 0) {
            NSLog(@"Existing data, Delete.");
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM MEASURE_DATA WHERE id = ?"];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, measureData.MeasureId);
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

@end
