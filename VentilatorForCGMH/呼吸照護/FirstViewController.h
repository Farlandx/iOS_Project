//
//  FirstViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/3/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FirstViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate> {
    NSString *deviceUUID;
    NSInteger bleStep;
}

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSMutableData *mData;

@property (strong, nonatomic) IBOutlet UIButton *btnReadData;

//紀錄時間
@property (strong, nonatomic) IBOutlet UITextField *RecordTime;
//治療師ID
@property (strong, nonatomic) IBOutlet UITextField *RecordOper;
//病歷號
@property (strong, nonatomic) IBOutlet UITextField *ChtNo;
//呼吸器代號 (XXXXXXXXXXXX**YYYYY)
@property (strong, nonatomic) IBOutlet UITextField *VentNo;


@end
