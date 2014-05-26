//
//  DeviceInfo.m
//  BLE
//
//  Created by Farland on 2014/3/4.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo

- (id)init {
    return [self initWithDeviceInfoByBleName:@"" DeviceType:@"NONE" BleMacAddress:@""];
}

- (id)initWithDeviceInfoByBleName:(NSString *)BleName DeviceType:(NSString *)DeviceType BleMacAddress:(NSString *)BleMacAddress {
    self = [super init];
    if (self) {
        self.BleMacAddress = BleMacAddress;
        self.BleName = BleName;
        
        if (![DeviceType caseInsensitiveCompare:@"DRAGER"]) {
            self.DeviceType = DEVICE_TYPE_DRAGER;
        }
        else if (![DeviceType caseInsensitiveCompare:@"HAMILTON"]) {
            self.DeviceType = DEVICE_TYPE_HAMILTON;
        }
        else if (![DeviceType caseInsensitiveCompare:@"SERVOI"]) {
            self.DeviceType = DEVICE_TYPE_SERVOI;
        }
        else if (![DeviceType caseInsensitiveCompare:@"NONE"]) {
            self.DeviceType = DEVICE_TYPE_NONE;
        }
        else {
            self.DeviceType = DEVICE_TYPE_UNKNOW;
        }
    }
    return self;
}

@end
