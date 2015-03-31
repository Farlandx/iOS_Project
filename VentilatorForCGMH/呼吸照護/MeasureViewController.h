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
#import "NameTextField.h"
#import "ModelModeList.h"

@protocol MeasureViewControllerDelegate <NSObject>

- (void)measureViewControllerDismissed:(VentilationData *)measureData recordOper:(NSString *)recordOper;
- (void)measureViewControllerCancled;

@end

@interface MeasureViewController : UIViewController<UITextFieldDelegate, NfcA1ProtocolDelegate, BleDelegate> {
    NfcA1Device* mNfcA1Device;
    UInt8 gBlockData[16];
    UInt8 gNo;
    UInt8 gTagUID[7];
    
    BLE *ble;
}

#pragma mark - Bar Button Item
- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnTitleViewButton;
@property (strong, nonatomic) IBOutlet UIButton *btnTest1;
@property (strong, nonatomic) IBOutlet UIButton *btnTest2;
@property (strong, nonatomic) NSMutableArray *modelModeList;
@property (strong, nonatomic) IBOutlet UILabel *lblVent;

//基隆、高雄院區用
@property (strong, nonatomic) IBOutlet UISwitch *rememberRecordOper;
@property (strong, nonatomic) IBOutlet NSString *rememberRecordOperString;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorRO;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorVNO;

@property (strong, nonatomic) VentilationData *myMeasureData;
@property (nonatomic) BOOL viewMode;
@property (nonatomic) BOOL editMode;
@property (strong, nonatomic) NSString *VentilatorModel;
@property (assign, nonatomic) id<MeasureViewControllerDelegate> delegate;

//儲存按鈕
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSave;
//紀錄時間
@property (strong, nonatomic) IBOutlet UITextField *RecordTime;
//治療師ID
@property (strong, nonatomic) IBOutlet NameTextField *RecordOper;
//病歷號
@property (strong, nonatomic) IBOutlet NameTextField *ChtNo;
//呼吸器代號 (XXXXXXXXXXXX**YYYYY)
@property (strong, nonatomic) IBOutlet UITextField *VentNo;

- (void)setViewMode;
- (void)setEditMode;

@end
