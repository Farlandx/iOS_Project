//
//  Patient.m
//  呼吸照護
//
//  Created by Farland on 2014/6/13.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "Patient.h"

@implementation Patient

- (id)init {
    if (self = [super init]) {
        _ChtNo = @"";
        _BedNo = @"";
    }
    return self;
}

@end
