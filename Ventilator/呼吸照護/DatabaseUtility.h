//
//  DatabaseUtility.h
//  呼吸照護
//
//  Created by Farland on 2014/2/18.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "VentilationData.h"
#import "DtoVentExchangeUploadBatch.h"

@interface DatabaseUtility : NSObject {
    sqlite3 *sqliteDb;
}

@property (strong, nonatomic) NSString *databasePath;

- (void) initDatabase;

#pragma mark - MeasureData
- (BOOL) saveMeasure:(VentilationData *)measureData;
- (BOOL) deleteMeasure:(VentilationData *)measureData;
//取得尚未上傳的量測資料
- (NSMutableArray *) getMeasures;
- (VentilationData *) getMeasureDataById:(NSInteger)measureId;

#pragma mark - UploadData
- (BOOL) saveUploadData:(DtoVentExchangeUploadBatch *)uploadData;
- (NSMutableArray *) getUploadHistories;

#pragma mark - CurRtCardListVerId
- (int) getCurRtCardListVerId;
- (BOOL) saveCurRtCardListVerId:(int)Id;

#pragma mark - CurRtCardList
- (void) saveCurRtCardList:(NSArray *)data;
- (NSMutableArray *) getCurRtCardList;

@end
