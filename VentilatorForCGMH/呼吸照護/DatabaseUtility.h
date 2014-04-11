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

@interface DatabaseUtility : NSObject {
    sqlite3 *sqliteDb;
}

@property (strong, nonatomic) NSString *databasePath;

- (void) initDatabase;
- (BOOL) saveMeasure:(VentilationData *)measureData;
- (BOOL) deleteMeasure:(VentilationData *)measureData;
- (NSMutableArray *) getMeasures;
- (VentilationData *) getMeasureDataById:(NSInteger) measureId;

@end
