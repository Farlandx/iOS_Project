//
//  ModelModeList.m
//  呼吸照護
//
//  Created by Farland on 2015/3/13.
//  Copyright (c) 2015年 Farland. All rights reserved.
//

#import "ModelModeList.h"

@implementation ModelModeList

- (id)init {
    if (self = [super init]) {
        _Model = @"";
        _ModeList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
