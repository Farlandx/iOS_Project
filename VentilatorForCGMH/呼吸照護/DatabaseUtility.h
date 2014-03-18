//
//  DatabaseUtility.h
//  呼吸照護
//
//  Created by Farland on 2014/2/18.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MeasureData.h"

@interface DatabaseUtility : NSObject {
    sqlite3 *sqliteDb;
}

@property (strong, nonatomic) NSString *databasePath;

- (void) initDatabase;
- (BOOL) saveMeasure:(MeasureData *)measureData;
- (BOOL) deleteMeasure:(MeasureData *)measureData;
- (NSMutableArray *) getMeasures;
- (MeasureData *) getMeasureDataById:(NSInteger) measureId;

@end
