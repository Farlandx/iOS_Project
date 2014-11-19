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

- (BOOL)checkColumnExists:(NSString *)column table:(NSString *)table {
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        char *errMsg;
        
        NSString *sql_stmt = [NSString stringWithFormat:@"SELECT %@ FROM %@", column, table];
        if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)addColumn:(NSString *)column table:(NSString *)table property:(NSString *)property {
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        char *errMsg;
        
        NSString *sql_stmt = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", table, column, property];
        if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
            return YES;
        }
    }
    
    return NO;
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
            sql_stmt = [sql_stmt stringByAppendingString:@"ErrorMsg TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VentilationHertz TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PressureAmplitude TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"TubeCompensation TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VolumeAssist TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"FlowAssist TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"EdiPeak TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"EdiMin TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"NavaLevel TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"EdiTrigger TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"NO TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"NO2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"LeakTest TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"MaxPe TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"VC TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Be TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"HCO3 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PAAO2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PaCo2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PaO2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"PfRatio TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Ph TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"SaO2 TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Shunt TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"Site TEXT)"];

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
            sql_stmt = @"CREATE TABLE IF NOT EXISTS PATIENT_DATA (ChtNo TEXT PRIMARY KEY, BedNo TEXT)";
            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create PATIENT table.");
            }
            else {
                NSLog(@"PATIENT Table craeted successfully.");
            }
            
            //建立動脈血氧分析更新記錄table
            sql_stmt = @"CREATE TABLE IF NOT EXISTS ABG_UPDATE_RECORD (ChtNo TEXT PRIMARY KEY, LastUpdateTime TEXT, CreateTime TEXT)";
            if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create ABG_UPDATE_RECORD table.");
            }
            else {
                NSLog(@"ABG_UPDATE_RECORD Table craeted successfully.");
            }
            sqlite3_close(sqliteDb);
        }
        else {
            NSLog(@"Failed to open/create database.");
        }
    }
    
    //以下正式上線要刪掉
    //確認20140902新增欄位是否存在
    if (![self checkColumnExists:@"VentilationHertz" table:@"MEASURE_DATA"]) {
        [self addColumn:@"VentilationHertz" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PressureAmplitude" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"TubeCompensation" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"VolumeAssist" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"FlowAssist" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"EdiPeak" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"EdiMin" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"NavaLevel" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"EdiTrigger" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"NO" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"NO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"LeakTest" table:@"MEASURE_DATA" property:@"TEXT"];
    }
    
    //確認20141023新增欄位是否存在
    if (![self checkColumnExists:@"MaxPe" table:@"MEASURE_DATA"]) {
        [self addColumn:@"MaxPe" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"VC" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Be" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"HCO3" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PAAO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PaCo2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PaO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PfRatio" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Ph" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"SaO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Shunt" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Site" table:@"MEASURE_DATA" property:@"TEXT"];
    }
    if (![self checkColumnExists:@"Be" table:@"MEASURE_DATA"]) {
        [self addColumn:@"Be" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"HCO3" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PAAO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PaCo2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PaO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"PfRatio" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Ph" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"SaO2" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Shunt" table:@"MEASURE_DATA" property:@"TEXT"];
        [self addColumn:@"Site" table:@"MEASURE_DATA" property:@"TEXT"];
    }
    //確認20141113新增欄位是否存在
    if (![self checkColumnExists:@"AnalysisTime" table:@"MEASURE_DATA"]) {
        [self addColumn:@"AnalysisTime" table:@"MEASURE_DATA" property:@"TEXT"];
    }
    
    
    NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS ABG_UPDATE_RECORD (ChtNo TEXT PRIMARY KEY, LastUpdateTime TEXT, CreateTime TEXT)";
    if (sqlite3_exec(sqliteDb, [sql_stmt UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
    }
    else {
    }
}

#pragma mark - MeasureData
- (BOOL) saveMeasure:(VentilationData *)measureData {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        if (measureData.MeasureId > 0) {
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
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"ErrorMsg = '%@', ", measureData.ErrorMsg]];
            //20140902新增欄位
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VentilationHertz = '%@', ", measureData.VentilationHertz]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PressureAmplitude = '%@', ", measureData.PressureAmplitude]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"TubeCompensation = '%@', ", measureData.TubeCompensation]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VolumeAssist = '%@', ", measureData.VolumeAssist]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"FlowAssist = '%@', ", measureData.FlowAssist]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"EdiPeak = '%@', ", measureData.EdiPeak]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"EdiMin = '%@', ", measureData.EdiMin]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"NavaLevel = '%@', ", measureData.NavaLevel]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"EdiTrigger = '%@', ", measureData.EdiTrigger]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"NO = '%@', ", measureData._NO]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"NO2 = '%@', ", measureData.NO2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"LeakTest = '%@', ", measureData.LeakTest]];
            //20141023新增欄位
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"MaxPe = '%@', ", measureData.MaxPe]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"VC = '%@', ", measureData.VC]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Be = '%@', ", measureData.Be]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"HCO3 = '%@', ", measureData.HCO3]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PAAO2 = '%@', ", measureData.PAAO2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PaCo2 = '%@', ", measureData.PaCo2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PaO2 = '%@', ", measureData.PaO2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"PfRatio = '%@', ", measureData.PfRatio]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Ph = '%@', ", measureData.Ph]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SaO2 = '%@', ", measureData.SaO2]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Shunt = '%@', ", measureData.Shunt]];
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"Site = '%@', ", measureData.Site]];
            //20141114新增欄位
            updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"AnalysisTime = '%@'", measureData.AnalysisTime]];
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
                                   @"INSERT INTO MEASURE_DATA (ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg, VentilationHertz, PressureAmplitude, TubeCompensation, VolumeAssist, FlowAssist, EdiPeak, EdiMin, NavaLevel, EdiTrigger, NO, NO2, LeakTest, MaxPe, VC, Be, HCO3, PAAO2, PaCo2, PaO2, PfRatio, Ph, SaO2, Shunt, Site, AnalysisTime) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
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
                                   measureData.ErrorMsg,
                                   //20140902新增欄位
                                   measureData.VentilationHertz,
                                   measureData.PressureAmplitude,
                                   measureData.TubeCompensation,
                                   measureData.VolumeAssist,
                                   measureData.FlowAssist,
                                   measureData.EdiPeak,
                                   measureData.EdiMin,
                                   measureData.NavaLevel,
                                   measureData.EdiTrigger,
                                   measureData._NO,
                                   measureData.NO2,
                                   measureData.LeakTest,
                                   //20141023新增欄位
                                   measureData.MaxPe,
                                   measureData.VC,
                                   measureData.Be,
                                   measureData.HCO3,
                                   measureData.PAAO2,
                                   measureData.PaCo2,
                                   measureData.PaO2,
                                   measureData.PfRatio,
                                   measureData.Ph,
                                   measureData.SaO2,
                                   measureData.Shunt,
                                   measureData.Site,
                                   //20141113新增欄位
                                   measureData.AnalysisTime
                                   ];
            
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
        NSString *querySQL = @"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg, VentilationHertz, PressureAmplitude, TubeCompensation, VolumeAssist, FlowAssist, EdiPeak, EdiMin, NavaLevel, EdiTrigger, NO, NO2, LeakTest, MaxPe, VC, Be, HCO3, PAAO2, PaCo2, PaO2, PfRatio, Ph, SaO2, Shunt, Site, AnalysisTime FROM MEASURE_DATA WHERE UploadId IS NULL OR UploadId = ''";
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
                //20140902新增欄位
                measureData.VentilationHertz = [self getColumnString:(char *)sqlite3_column_text(statement, 68)];
                measureData.PressureAmplitude = [self getColumnString:(char *)sqlite3_column_text(statement, 69)];
                measureData.TubeCompensation = [self getColumnString:(char *)sqlite3_column_text(statement, 70)];
                measureData.VolumeAssist = [self getColumnString:(char *)sqlite3_column_text(statement, 71)];
                measureData.FlowAssist = [self getColumnString:(char *)sqlite3_column_text(statement, 72)];
                measureData.EdiPeak = [self getColumnString:(char *)sqlite3_column_text(statement, 73)];
                measureData.EdiMin = [self getColumnString:(char *)sqlite3_column_text(statement, 74)];
                measureData.NavaLevel = [self getColumnString:(char *)sqlite3_column_text(statement, 75)];
                measureData.EdiTrigger = [self getColumnString:(char *)sqlite3_column_text(statement, 76)];
                measureData._NO = [self getColumnString:(char *)sqlite3_column_text(statement, 77)];
                measureData.NO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 78)];
                measureData.LeakTest = [self getColumnString:(char *)sqlite3_column_text(statement, 79)];
                //20141023新增欄位
                measureData.MaxPe = [self getColumnString:(char *)sqlite3_column_text(statement, 80)];
                measureData.VC = [self getColumnString:(char *)sqlite3_column_text(statement, 81)];
                measureData.Be = [self getColumnString:(char *)sqlite3_column_text(statement, 82)];
                measureData.HCO3 = [self getColumnString:(char *)sqlite3_column_text(statement, 83)];
                measureData.PAAO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 84)];
                measureData.PaCo2 = [self getColumnString:(char *)sqlite3_column_text(statement, 85)];
                measureData.PaO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 86)];
                measureData.PfRatio = [self getColumnString:(char *)sqlite3_column_text(statement, 87)];
                measureData.Ph = [self getColumnString:(char *)sqlite3_column_text(statement, 88)];
                measureData.SaO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 89)];
                measureData.Shunt = [self getColumnString:(char *)sqlite3_column_text(statement, 90)];
                measureData.Site = [self getColumnString:(char *)sqlite3_column_text(statement, 91)];
                //20141113新增欄位
                measureData.AnalysisTime = [self getColumnString:(char *)sqlite3_column_text(statement, 92)];
                
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
                              @"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg, VentilationHertz, PressureAmplitude, TubeCompensation, VolumeAssist, FlowAssist, EdiPeak, EdiMin, NavaLevel, EdiTrigger, NO, NO2, LeakTest, MaxPe, VC, Be, HCO3, PAAO2, PaCo2, PaO2, PfRatio, Ph, SaO2, Shunt, Site, AnalysisTime FROM MEASURE_DATA FROM MEASURE_DATA WHERE MeasureId = %d", (int)measureId];
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
                //20140902新增欄位
                measureData.VentilationHertz = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 68)];
                measureData.PressureAmplitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 69)];
                measureData.TubeCompensation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 70)];
                measureData.VolumeAssist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 71)];
                measureData.FlowAssist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 72)];
                measureData.EdiPeak = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 73)];
                measureData.EdiMin = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 74)];
                measureData.NavaLevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 75)];
                measureData.EdiTrigger = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 76)];
                measureData._NO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 77)];
                measureData.NO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 78)];
                measureData.LeakTest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 79)];
                //20141023新增欄位
                measureData.MaxPe = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 80)];
                measureData.VC = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 81)];
                measureData.Be = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 82)];
                measureData.HCO3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 83)];
                measureData.PAAO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 84)];
                measureData.PaCo2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 85)];
                measureData.PaO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 86)];
                measureData.PfRatio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 87)];
                measureData.Ph = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 88)];
                measureData.SaO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 89)];
                measureData.Shunt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 90)];
                measureData.Site = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 91)];
                //20141113新增欄位
                measureData.AnalysisTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 92)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return measureData;
}

- (VentilationData *)getMeasureDataByRecordTime:(NSString *)recordTime {
    VentilationData *measureData = [[VentilationData alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg, VentilationHertz, PressureAmplitude, TubeCompensation, VolumeAssist, FlowAssist, EdiPeak, EdiMin, NavaLevel, EdiTrigger, NO, NO2, LeakTest, MaxPe, VC, Be, HCO3, PAAO2, PaCo2, PaO2, PfRatio, Ph, SaO2, Shunt, Site, AnalysisTime FROM MEASURE_DATA WHERE RecordTime = '%@'", recordTime];
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
                //20140902新增欄位
                measureData.VentilationHertz = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 68)];
                measureData.PressureAmplitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 69)];
                measureData.TubeCompensation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 70)];
                measureData.VolumeAssist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 71)];
                measureData.FlowAssist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 72)];
                measureData.EdiPeak = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 73)];
                measureData.EdiMin = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 74)];
                measureData.NavaLevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 75)];
                measureData.EdiTrigger = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 76)];
                measureData._NO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 77)];
                measureData.NO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 78)];
                measureData.LeakTest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 79)];
                //20141023新增欄位
                measureData.MaxPe = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 80)];
                measureData.VC = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 81)];
                measureData.Be = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 82)];
                measureData.HCO3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 83)];
                measureData.PAAO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 84)];
                measureData.PaCo2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 85)];
                measureData.PaO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 86)];
                measureData.PfRatio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 87)];
                measureData.Ph = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 88)];
                measureData.SaO2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 89)];
                measureData.Shunt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 90)];
                measureData.Site = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 91)];
                //20141113新增欄位
                measureData.AnalysisTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 92)];
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
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    //刪除過期資料
    @try {
        [self deleteExpiredHistories];
        [self deleteExpiredABGRecords];
    }
    @catch (NSException *e) {
        
    }
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        //取得上傳記錄
        NSString *querySQL = @"SELECT b.UploadId, b.UploadOper, b.UploadIp, b.UploadTime, b.Device, b.ClientVersion, a.BedNo, a.ChtNo FROM MEASURE_DATA a JOIN UPLOAD_DATA b ON a.UploadId = b.UploadId GROUP BY BedNo, ChtNo ORDER BY BedNo";
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
                batch.BedNo = [self getColumnString:(char *)sqlite3_column_text(statement, 6)];
                batch.ChtNo = [self getColumnString:(char *)sqlite3_column_text(statement, 7)];
                
                [batchList addObject:batch];
            }
        }
        
        for (int i = 0;i < batchList.count; i++) {
            NSMutableArray *measureList = [[NSMutableArray alloc] init];
            querySQL = [NSString stringWithFormat:@"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg, VentilationHertz, PressureAmplitude, TubeCompensation, VolumeAssist, FlowAssist, EdiPeak, EdiMin, NavaLevel, EdiTrigger, NO, NO2, LeakTest, MaxPe, VC, Be, HCO3, PAAO2, PaCo2, PaO2, PfRatio, Ph, SaO2, Shunt, Site, AnalysisTime FROM measure_data WHERE uploadid IS NOT NULL AND uploadid <> '' AND BedNo = '%@' AND ChtNo = '%@' ORDER BY BedNo ASC, RecordTime DESC", ((DtoVentExchangeUploadBatch *)batchList[i]).BedNo, ((DtoVentExchangeUploadBatch *)batchList[i]).ChtNo];
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
                    //20140902新增欄位
                    measureData.VentilationHertz = [self getColumnString:(char *)sqlite3_column_text(statement, 68)];
                    measureData.PressureAmplitude = [self getColumnString:(char *)sqlite3_column_text(statement, 69)];
                    measureData.TubeCompensation = [self getColumnString:(char *)sqlite3_column_text(statement, 70)];
                    measureData.VolumeAssist = [self getColumnString:(char *)sqlite3_column_text(statement, 71)];
                    measureData.FlowAssist = [self getColumnString:(char *)sqlite3_column_text(statement, 72)];
                    measureData.EdiPeak = [self getColumnString:(char *)sqlite3_column_text(statement, 73)];
                    measureData.EdiMin = [self getColumnString:(char *)sqlite3_column_text(statement, 74)];
                    measureData.NavaLevel = [self getColumnString:(char *)sqlite3_column_text(statement, 75)];
                    measureData.EdiTrigger = [self getColumnString:(char *)sqlite3_column_text(statement, 76)];
                    measureData._NO = [self getColumnString:(char *)sqlite3_column_text(statement, 77)];
                    measureData.NO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 78)];
                    measureData.LeakTest = [self getColumnString:(char *)sqlite3_column_text(statement, 79)];
                    //20141023新增欄位
                    measureData.MaxPe = [self getColumnString:(char *)sqlite3_column_text(statement, 80)];
                    measureData.VC = [self getColumnString:(char *)sqlite3_column_text(statement, 81)];
                    measureData.Be = [self getColumnString:(char *)sqlite3_column_text(statement, 82)];
                    measureData.HCO3 = [self getColumnString:(char *)sqlite3_column_text(statement, 83)];
                    measureData.PAAO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 84)];
                    measureData.PaCo2 = [self getColumnString:(char *)sqlite3_column_text(statement, 85)];
                    measureData.PaO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 86)];
                    measureData.PfRatio = [self getColumnString:(char *)sqlite3_column_text(statement, 87)];
                    measureData.Ph = [self getColumnString:(char *)sqlite3_column_text(statement, 88)];
                    measureData.SaO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 89)];
                    measureData.Shunt = [self getColumnString:(char *)sqlite3_column_text(statement, 90)];
                    measureData.Site = [self getColumnString:(char *)sqlite3_column_text(statement, 91)];
                    //20141113新增欄位
                    measureData.AnalysisTime = [self getColumnString:(char *)sqlite3_column_text(statement, 92)];
                    
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

- (NSMutableArray *) getUploadHistoriesByChtNo:(NSString *)ChtNo {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *measureList = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT MeasureId, ChtNo, RecordTime, RecordIp, RecordOper, RecordDevice, RecordClientVersion, VentNo, RawData, VentilationMode, TidalVolumeSet, VolumeTarget, TidalVolumeMeasured, VentilationRateSet, SIMVRateSet, VentilationRateTotal, InspT, THigh, InspirationExpirationRatio, Tlow, AutoFlow, FlowSetting, FlowMeasured, Pattern, MVSet, PercentMinVolSet, MVTotal, PeakPressure, PlateauPressure, MeanPressure, PEEP, Plow, PressureSupport, PressureControl, PHigh, FiO2Set, FiO2Measured, Resistance, Compliance, BaseFlow, FlowSensitivity, LowerMV, HighPressureAlarm, Temperature, ReliefPressure, PetCo2, SpO2, RR, TV, MV, MaxPi, Mvv, Rsbi, EtSize, Mark, CuffPressure, BreathSounds, Pr, Cvp, BpS, BpD, Xrem, AutoPEEP, PlateauTimeSetting, RecordOperName, VentilatorModel, BedNo, ErrorMsg, VentilationHertz, PressureAmplitude, TubeCompensation, VolumeAssist, FlowAssist, EdiPeak, EdiMin, NavaLevel, EdiTrigger, NO, NO2, LeakTest, MaxPe, VC, Be, HCO3, PAAO2, PaCo2, PaO2, PfRatio, Ph, SaO2, Shunt, Site, AnalysisTime FROM measure_data WHERE uploadid IS NOT NULL AND uploadid <> '' AND ChtNo = '%@' ORDER BY BedNo ASC, RecordTime DESC", ChtNo];
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
                //20140902新增欄位
                measureData.VentilationHertz = [self getColumnString:(char *)sqlite3_column_text(statement, 68)];
                measureData.PressureAmplitude = [self getColumnString:(char *)sqlite3_column_text(statement, 69)];
                measureData.TubeCompensation = [self getColumnString:(char *)sqlite3_column_text(statement, 70)];
                measureData.VolumeAssist = [self getColumnString:(char *)sqlite3_column_text(statement, 71)];
                measureData.FlowAssist = [self getColumnString:(char *)sqlite3_column_text(statement, 72)];
                measureData.EdiPeak = [self getColumnString:(char *)sqlite3_column_text(statement, 73)];
                measureData.EdiMin = [self getColumnString:(char *)sqlite3_column_text(statement, 74)];
                measureData.NavaLevel = [self getColumnString:(char *)sqlite3_column_text(statement, 75)];
                measureData.EdiTrigger = [self getColumnString:(char *)sqlite3_column_text(statement, 76)];
                measureData._NO = [self getColumnString:(char *)sqlite3_column_text(statement, 77)];
                measureData.NO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 78)];
                measureData.LeakTest = [self getColumnString:(char *)sqlite3_column_text(statement, 79)];
                //20141023新增欄位
                measureData.MaxPe = [self getColumnString:(char *)sqlite3_column_text(statement, 80)];
                measureData.VC = [self getColumnString:(char *)sqlite3_column_text(statement, 81)];
                measureData.Be = [self getColumnString:(char *)sqlite3_column_text(statement, 82)];
                measureData.HCO3 = [self getColumnString:(char *)sqlite3_column_text(statement, 83)];
                measureData.PAAO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 84)];
                measureData.PaCo2 = [self getColumnString:(char *)sqlite3_column_text(statement, 85)];
                measureData.PaO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 86)];
                measureData.PfRatio = [self getColumnString:(char *)sqlite3_column_text(statement, 87)];
                measureData.Ph = [self getColumnString:(char *)sqlite3_column_text(statement, 88)];
                measureData.SaO2 = [self getColumnString:(char *)sqlite3_column_text(statement, 89)];
                measureData.Shunt = [self getColumnString:(char *)sqlite3_column_text(statement, 90)];
                measureData.Site = [self getColumnString:(char *)sqlite3_column_text(statement, 91)];
                //20141113新增欄位
                measureData.AnalysisTime = [self getColumnString:(char *)sqlite3_column_text(statement, 92)];
                [measureList addObject:measureData];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    
    return measureList;
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
                deleteSQL = [NSString stringWithFormat:@"DELETE FROM MEASURE_DATA WHERE UploadId = ?"];
                
                delete_stmt = [deleteSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
                sqlite3_bind_int(statement, 1, [uploadId intValue]);
                foo = sqlite3_step(statement);
                if (foo != SQLITE_DONE) {
                    NSLog(@"Error. %s", __func__);
                }
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
            
            sqlite3_exec(sqliteDb, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
            
            for (NSString *str in data) {
                NSString *insertSQL = [NSString stringWithFormat:
                                       @"INSERT INTO CARD_NO (CardNo) VALUES ('%@')", str];
                
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
                int sqliteState = sqlite3_step(statement);
            }
            
            sqlite3_exec(sqliteDb, "COMMIT TRANSACTION", 0, 0, 0);
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

#pragma mark - Patient
- (void) savePatient:(NSArray *)data {
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (data.count > 0) {
        [self deletePatients];
        if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
            
            sqlite3_exec(sqliteDb, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
            
            for (Patient *p in data) {
                NSString *insertSQL = [NSString stringWithFormat:
                                       @"INSERT INTO PATIENT_DATA (ChtNo, BedNo) VALUES ('%@', '%@')", p.ChtNo, p.BedNo];
                
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
                int sqliteState = sqlite3_step(statement);
                NSLog(@"%s", __func__);
            }
            
            sqlite3_exec(sqliteDb, "COMMIT TRANSACTION", 0, 0, 0);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
}

- (BOOL) deletePatients {
    BOOL isSuccess = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        //刪掉所有資料
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM PATIENT_DATA"];
        
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

- (NSMutableArray *) getPatientList {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = @"SELECT ChtNo, BedNo FROM PATIENT_DATA";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Patient *p = [[Patient alloc] init];
                p.ChtNo = [self getColumnString:(char *)sqlite3_column_text(statement, 0)];
                p.BedNo = [self getColumnString:(char *)sqlite3_column_text(statement, 1)];
                [result addObject:p];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return result;
}

- (Patient *) getPatientByChtNo:(NSString *)chtNo {
    Patient *result = [[Patient alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ChtNo, BedNo FROM PATIENT_DATA WHERE ChtNo = '%@'", chtNo];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                result.ChtNo = [self getColumnString:(char *)sqlite3_column_text(statement, 0)];
                result.BedNo = [self getColumnString:(char *)sqlite3_column_text(statement, 1)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return result;
}

#pragma mark - ABG
- (ABGUpdateRecord *) getABGUpdateRecordByChtNo:(NSString *)ChtNo {
    ABGUpdateRecord *record = [[ABGUpdateRecord alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ChtNo, LastUpdateTime FROM ABG_UPDATE_RECORD WHERE ChtNo = '%@'", ChtNo];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                record.ChtNo = [self getColumnString:(char *)sqlite3_column_text(statement, 0)];
                record.LastUpdateTime = [self getColumnString:(char *)sqlite3_column_text(statement, 1)];
                break;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqliteDb);
    }
    
    return record;
}

- (BOOL) updateABGUpdateRecordByChtNo:(NSString *)ChtNo {
    ABGUpdateRecord *record = [[ABGUpdateRecord alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    BOOL isSuccess = false;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ChtNo, LastUpdateTime, CreateTime FROM ABG_UPDATE_RECORD WHERE ChtNo = '%@'", ChtNo];
        const char *query_stmt = [querySQL UTF8String];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *nowTime = [dateFormatter stringFromDate:[NSDate date]];
        
        if (sqlite3_prepare_v2(sqliteDb, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            //有資料就做Update
            if (sqlite3_step(statement) == SQLITE_ROW) {
                record.ChtNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.LastUpdateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *updateSQL = @"UPDATE ABG_UPDATE_RECORD ";
                updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"SET LastUpdateTime = '%@' ", nowTime]];
                
                //結尾
                updateSQL = [updateSQL stringByAppendingString:[NSString stringWithFormat:@"WHERE ChtNo = '%@'", record.ChtNo]];
                
                const char *update_stmt = [updateSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, update_stmt, -1, &statement, NULL);
                sqlite3_bind_null(statement, 1);
                if(sqlite3_step(statement)) {
                    isSuccess = true;
                }
            }
            else {
                //沒資料新增一筆
                NSString *insertSQL = [NSString stringWithFormat:
                                       @"INSERT INTO ABG_UPDATE_RECORD (ChtNo, LastUpdateTime, CreateTime) VALUES (\"%@\",\"%@\",\"%@\")",
                                       ChtNo,
                                       nowTime,
                                       nowTime];
                
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(sqliteDb, insert_stmt, -1, &statement, NULL);
                int sqliteState = sqlite3_step(statement);
                if (sqliteState == SQLITE_DONE) {
                    isSuccess = true;
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
    return isSuccess;
}

- (void) deleteExpiredABGRecords {
    NSMutableArray *ChtNoArray = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &sqliteDb) == SQLITE_OK) {
        NSDateComponents *dateComponets = [[NSDateComponents alloc] init];
        [dateComponets setDay:-3];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM ABG_UPDATE_RECORD WHERE CreateTime < '%@'", [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]]];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(sqliteDb, delete_stmt, -1, &statement, NULL);
        sqlite3_bind_null(statement, 1);
        int foo = sqlite3_step(statement);
        if (foo != SQLITE_DONE) {
            NSLog(@"Error. %@ (%s)", deleteSQL, __func__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(sqliteDb);
    }
}

@end
