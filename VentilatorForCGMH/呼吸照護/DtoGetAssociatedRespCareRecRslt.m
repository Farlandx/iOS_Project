//
//  DtoGetAssociatedRespCareRecRslt.m
//  呼吸照護
//
//  Created by Farland on 2014/11/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DtoGetAssociatedRespCareRecRslt.h"

@implementation DtoGetAssociatedRespCareRecRslt

- (id)init {
    if (self = [super init]) {
        _ChtNo = @"";
        _RecordTime = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DtoGetAssociatedRespCareRecRslt *z = [[DtoGetAssociatedRespCareRecRslt alloc] init];
    z.ChtNo = _ChtNo;
    z.RecordTime = _RecordTime;
//    z.Fields = [_Fields copyWithZone:zone];
    z.Fields = _Fields;
    
    return z;
}

@end
