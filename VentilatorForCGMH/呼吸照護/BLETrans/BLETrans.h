//
//  BLETrans.h
//  PC傳輸測試
//
//  Created by Farland on 2014/7/28.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtoVentExchangeUploadBatch.h"

#define BLE_DEVICE_NAME @"BLE_PC"

@class BLETrans;
@protocol BLETransDelegate <NSObject>

@required
- (void)BLETransUploadDone:(NSString *)data;

@optional
- (void)UploadProgress:(float)progressStatus;

@end

@interface BLETrans : NSObject

@property (assign, nonatomic) id<BLETransDelegate> delegate;
- (void)SendBatchData:(DtoVentExchangeUploadBatch *)batchData;
- (void)CancelTrans;

@end
