//
//  WebService.h
//  CommandLineTest
//
//  Created by Farland on 2014/4/17.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtoVentExchangeUploadBatch.h"
#import "DtoUploadVentDataResult.h"

@protocol WebServiceDelegate <NSObject>

- (void)wsAppLogin:(NSString *)sessionId;
- (void)wsUploadVentData:(NSMutableArray *)uploadResult DtoVentExchangeUploadBatch:(DtoVentExchangeUploadBatch *)batch;
- (void)wsResponseCurRtCardList:(NSMutableArray *)data;
- (void)wsResponseCurRtCardListVerId:(int)verId;
- (void)wsResponsePatientList:(NSMutableArray *)data;

@end

@interface WebService : NSObject

@property (assign, nonatomic) id<WebServiceDelegate> delegate;

- (void)appLoginDeviceName:(NSString *)deviceName idNo:(NSString *)idNo;
- (void)uploadVentDataBySessionId:(NSString *)sessionId DtoVentExchangeUploadBatch:(DtoVentExchangeUploadBatch *)vData;
- (void)getCurRtCardList;
- (void)getCurRtCardListVerId;
- (void)getPatientList;

@end
