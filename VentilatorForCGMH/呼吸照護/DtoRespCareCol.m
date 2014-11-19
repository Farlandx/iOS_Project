//
//  DtoRespCareCol.m
//  呼吸照護
//
//  Created by Farland on 2014/11/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DtoRespCareCol.h"

@implementation DtoRespCareCol

- (id)init {
    if (self = [super init]) {
        _Name = @"";
        _Description = @"";
        _Unit = @"";
        _Value = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DtoRespCareCol *z = [[DtoRespCareCol alloc] init];
    z.Name = _Name;
    z.Description = _Description;
    z.Unit = _Unit;
    z.Value = _Value;
    return z;
}

@end
