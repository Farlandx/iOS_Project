//
//  BLE.h
//  BLE
//
//  Created by Farland on 2014/3/4.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "VentilationData.h"
#import "DeviceInfo.h"

typedef NS_ENUM(NSUInteger, BleReadStatus) {
    NONE = 0,
    CONNECTING,
    READING_DATA,
    DONE
};

@class BLE;
@protocol BleDelegate <NSObject>

@required
- (void)recievedVentilationData:(VentilationData *)data;

@optional
- (void)readStatusChange:(BleReadStatus)status;

@end

@interface BLE : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> {
    DeviceInfo *deviceInfo;
    VentilationData *ventilation;
}

@property (assign, nonatomic) id<BleDelegate> delegate;
@property (strong, nonatomic) CBCentralManager *centralMgr;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSMutableData *mData;

#pragma -mark Methods
- (void)startReadByConnectionString:(NSString *)connectString;

@end
