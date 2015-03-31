//
//  DtoGetModelModeListItem.m
//  呼吸照護
//
//  Created by Farland on 2015/3/12.
//  Copyright (c) 2015年 Farland. All rights reserved.
//

#import "DtoGetModelModeListItem.h"

@implementation DtoGetModelModeListItem

- (id)init {
    if (self = [super init]) {
        _VendorId = @"";
        _Model = @"";
        _ModeList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
