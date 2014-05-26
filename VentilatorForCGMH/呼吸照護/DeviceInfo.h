//
//  DeviceInfo.h
//  BLE
//
//  Created by Farland on 2014/3/4.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE_DEVICE_TYPE.h"

@interface DeviceInfo : NSObject

@property (strong, nonatomic) NSString *BleMacAddress;
@property (strong, nonatomic) NSString *BleName;
@property (nonatomic) DEVICE_TYPE DeviceType;

- (id)initWithDeviceInfoByBleName:(NSString *)BleName DeviceType:(NSString *)DeviceType BleMacAddress:(NSString *)BleMacAddress;

@end
