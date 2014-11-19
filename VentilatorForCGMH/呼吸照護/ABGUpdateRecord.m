//
//  ABGUpdateRecord.m
//  呼吸照護
//
//  Created by Farland on 2014/11/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "ABGUpdateRecord.h"

@implementation ABGUpdateRecord

- (id)init {
    if (self = [super init]) {
        _ChtNo = @"";
        _LastUpdateTime = @"";
        _CreateTime = @"";
    }
    return self;
}

@end
