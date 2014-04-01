//
//  MeasureViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/4/1.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NfcA1Device.h"
#import "VentilationData.h"
#import "DeviceInfo.h"
#import "BLE.h"

@interface MeasureViewController : UIViewController<UITextFieldDelegate, NfcA1ProtocolDelegate> {
    NfcA1Device* mNfcA1Device;
    UInt8 gBlockData[16];
    UInt8 gNo;
    UInt8 gTagUID[7];
    
    BLE *ble;
}

#pragma mark - Bar Button Item
- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnReadData;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorRO;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorVNO;

//紀錄時間
@property (strong, nonatomic) IBOutlet UITextField *RecordTime;
//治療師ID
@property (strong, nonatomic) IBOutlet UITextField *RecordOper;
//病歷號
@property (strong, nonatomic) IBOutlet UITextField *ChtNo;
//呼吸器代號 (XXXXXXXXXXXX**YYYYY)
@property (strong, nonatomic) IBOutlet UITextField *VentNo;

@end
