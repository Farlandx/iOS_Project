//
//  MeasureViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/4/1.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "MeasureViewController.h"
#import "MeasureTabBarViewController.h"
#import "VentilatorDataViewController.h"
#import "OtherDataViewController.h"
#import "DatabaseUtility.h"
#import "DeviceStatus.h"
#import "ProgressHUD.h"

@interface MeasureViewController ()

@end

@implementation MeasureViewController {
    DatabaseUtility *db;
    
    BOOL isStartListeningThread, isFocusOnRecordOper, isFocusOnVentNo;
    NSString *mac_address;
}

@synthesize viewMode;
@synthesize myMeasureData;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        viewMode = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //這是測試用按鈕
    _btnTest1.hidden = YES;
    _btnTest2.hidden = YES;
    
    [_RecordOper addTarget:self action:@selector(recordOperTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_ChtNo addTarget:self action:@selector(chtNoTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_VentNo addTarget:self action:@selector(ventNoTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _RecordOper.delegate = self;
    _VentNo.delegate = self;
    _ChtNo.delegate = self;
    
    isStartListeningThread = NO;
    isFocusOnRecordOper = NO;
    isFocusOnVentNo = NO;
    
    mac_address = @"";
    
    ble = [[BLE alloc] init];
    ble.delegate = self;
    
    db = [[DatabaseUtility alloc] init];
    [db initDatabase];
    
    if (myMeasureData != nil) {
        _RecordTime.text = myMeasureData.RecordTime;
        _RecordOper.text = myMeasureData.RecordOper;
        _ChtNo.text = myMeasureData.ChtNo;
        _VentNo.text = myMeasureData.VentNo;
        
        if (viewMode) {
            _RecordOper.enabled = NO;
            _ChtNo.enabled = NO;
            _VentNo.enabled = NO;
            
            for (UIViewController *child in self.childViewControllers) {
                if ([child isKindOfClass:[MeasureTabBarViewController class]]) {
                    for (UIViewController *v in ((MeasureTabBarViewController *)child).viewControllers) {
                        if ([v isKindOfClass:[VentilatorDataViewController class]]) {
                            VentilatorDataViewController *vc = (VentilatorDataViewController *)v;
                            vc.viewMode = YES;
                        }
                        else if ([v isKindOfClass:[OtherDataViewController class]]) {
                            OtherDataViewController *vc = (OtherDataViewController *)v;
                            vc.viewMode = YES;
                        }
                    }
                    
                }
            }
        }
    }
}

- (void)dealloc {
    _delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnStart:(id)sender {
//    _peripheral = [self getPeripheralByCode:@"2D1A5856-8987-F8C9-771E-5683182BF5F0"];
//    [_centralManager connectPeripheral:_peripheral options:nil];
}

- (void)recordOperTextFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
    [_ChtNo becomeFirstResponder];
}

- (void)chtNoTextFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
    [_VentNo becomeFirstResponder];
}

- (void)ventNoTextFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
    
    if (![_VentNo.text isEqualToString:@""]) {
        [ble setConnectionString:_VentNo.text];
        [ble startRead];
    }
    //[self btnStart:_btnReadData];
}

- (IBAction)testClick:(id)sender {
    //[ble startReadByConnectionString:@"CD8FC44D-4407-197A-068E-119EBD891976**HAMILTON"];
    [ble setConnectionString:@"000150671100**DRAGER"];
    [ble startRead];
}

- (IBAction)testDisconnect:(id)sender {
    [ble disconnect];
}


#pragma mark - NFC Dongle
- (BOOL)isHeadsetPluggedIn
{
    NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

- (void) hexStringToData:(NSString *)str
                    Data: (void *) data
{
    int len = (int)[str length] / 2;    // Target length
    
    unsigned char *whole_byte = data;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < len; i++)
    {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
}

- (NSString *) hexDataToString:(UInt8 *)data
                        Length:(int)len
{
    NSString *tmp = @"";
    NSString *str = @"";
    for(int i = 0; i < len; ++i)
    {
        tmp = [NSString stringWithFormat:@"%02X",data[i]];
        str = [str stringByAppendingString:tmp];
    }
    return str;
}

- (NSString *) sectorHexDataToString:(UInt8 *)data
                              Length:(int)len
{
    NSData *nData = [NSData dataWithBytes:data length:len];
    NSString *str = [[NSString alloc] initWithData:nData encoding:NSUTF8StringEncoding];
    return str;
}

- (void)listeningRecordOper {
    [self initAudioPlayer];
    if([mNfcA1Device readerGetTagUID] == NO) {
        NSLog(@"readerGetTagUID false");
    }
}

- (void)listeningVentNo {
    [self initAudioPlayer];
    if([mNfcA1Device readerReadTagSectorData:3] == NO) {
        NSLog(@"readerReadTagSectorData false");
    }
}

- (void) initAudioPlayer {
    if(!mNfcA1Device) {
        mNfcA1Device = [[NfcA1Device alloc] init];
        mNfcA1Device.delegate = self;
    }
}

- (void)receivedMessage:(SInt32)type Result:(Boolean)result Data:(void *)data {
    switch (type) {
        case MESSAGE_READER_GET_TAG_UID:
            if (result)
            {
                MSG_INFORM_DATA *infrom_data = data;
                
                NSString *tagUID =
                [self hexDataToString: infrom_data->data Length: 7];
                memcpy(gTagUID,infrom_data->data,sizeof(gTagUID));
                
                _RecordOper.text = tagUID;//[tagUID substringWithRange:NSMakeRange(0, 8)];
                
                NSString *strStatus =[NSString stringWithFormat:@"%02X",infrom_data->status];
                
                NSLog(@"tagUID:%@", [NSString stringWithFormat:@"Tag UID:%@,%@",tagUID,strStatus]);
                
                isStartListeningThread = NO;
                isFocusOnRecordOper = NO;
                [self indicatorROStop];
                [_RecordOper resignFirstResponder];
            }
            break;
            
        case MESSAGE_READER_READ_TAG_SECTOR_DATA:
            if (result) {
                MSG_INFORM_DATA *infrom_data = data;
                
                NSString *blockData =
                [self sectorHexDataToString: infrom_data->data Length: 48];
                
                _VentNo.text = [blockData componentsSeparatedByString:@"**"][0];
                
                NSString *strStatus =[NSString stringWithFormat:@"%02X",infrom_data->status];
                
                NSLog(@"SectorData:%@", [NSString stringWithFormat:@"Read Tag Sector Data:\n%@,%@",blockData,strStatus]);
                
                isStartListeningThread = NO;
                isFocusOnVentNo = NO;
                [self indicatorVNOStop];
                [_VentNo resignFirstResponder];
                
                [ble setConnectionString:blockData];
                [ble startRead];
            }
            break;
            
        default:
            break;
    }
    
    //持續listening直到讀到資料為止
    if (isStartListeningThread) {
        if (isFocusOnRecordOper) {
            NSLog(@"FocusOnRecordOper");
            if([mNfcA1Device readerGetTagUID] == YES) {
                
            }
            else {
                NSLog(@"readerGetTagUID false");
            }
        }
        else if (isFocusOnVentNo) {
            NSLog(@"FocusOnVentNo");
            if([mNfcA1Device readerReadTagSectorData:3] == YES) {
                
            }
            else {
                NSLog(@"readerReadTagSectorData false");
            }
        }
        else {
            NSLog(@"stop listening.");
            isStartListeningThread = NO;
        }
    }
}

- (void)indicatorROStart {
    [_RecordOper setPlaceholder:@"讀取中......"];
    [_indicatorRO startAnimating];
}

- (void)indicatorROStop {
    [_RecordOper setPlaceholder:@"點選開始掃瞄治療師卡號"];
    [_indicatorRO stopAnimating];
}

- (void)indicatorVNOStart {
    [_VentNo setPlaceholder:@"讀取中......"];
    [_indicatorVNO startAnimating];
}

- (void)indicatorVNOStop {
    [_VentNo setPlaceholder:@"點選開始掃瞄儀器ID"];
    [_indicatorVNO stopAnimating];
}

#pragma mark - BLE
- (void)recievedVentilationDataAndReadStatus:(VentilationData *)data readStatus:(BleReadStatus)status {
    switch (status) {
        case BLE_READ_DONE: {
            [ProgressHUD dismiss];
            //取的目前時間
            _RecordTime.text = [DeviceStatus getSystemTime];
            
            //取得非量測值
            myMeasureData.ChtNo = _ChtNo.text;
            myMeasureData.RecordTime = _RecordTime.text;
            myMeasureData.RecordIp = [DeviceStatus getCurrentIPAddress];
            myMeasureData.RecordOper = _RecordOper.text;
            myMeasureData.RecordDevice = [DeviceStatus getDeviceVendorUUID];
            myMeasureData.VentNo = _VentNo.text;
            myMeasureData.RecordClientVersion = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
            //取得量測值
            myMeasureData = data;
            
            //將數據顯示出來
            for (UIViewController *child in self.childViewControllers) {
                if ([child isKindOfClass:[MeasureTabBarViewController class]]) {
                    for (UIViewController *v in ((MeasureTabBarViewController *)child).viewControllers) {
                        if ([v isKindOfClass:[VentilatorDataViewController class]]) {
                            if ([v isViewLoaded]) {
                                VentilatorDataViewController *vc = (VentilatorDataViewController *)v;
                                [vc setMeasureData:myMeasureData];
                            }
                        }
                    }
                    
                }
            }
            NSLog(@"BLE Read Done.");
            break;
        }
            
        case BLE_SCANNING:
            [ProgressHUD show:@"尋找設備中..." Interaction:NO];
            break;
            
        case BLE_READING_DATA:
            [ProgressHUD show:@"讀取中..." Interaction:NO];
            break;
            
        case BLE_SCAN_TIMEOUT:
            [ProgressHUD showError:@"找不到設備"];
            break;
            
        case BLE_READ_ERROR:
            [ProgressHUD dismiss];
            NSLog(@"BLE Read Error!");
            break;
            
        case BLE_CONNECTING:
            [ProgressHUD show:@"連接設備中..." Interaction:NO];
            NSLog(@"BLE Connecting.");
            break;
            
        case BLE_CONNECT_ERROR:
            [ProgressHUD showError:@"連接失敗！" Interaction:NO];
            NSLog(@"BLE Connect Error.");
            break;
            
        case BLE_DISCONNECTED:
            [ProgressHUD dismiss];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (![self isHeadsetPluggedIn]) {
        isStartListeningThread = NO;
        isFocusOnRecordOper = NO;
        isFocusOnVentNo = NO;
        return;
    }
    
    if (!isStartListeningThread) {
        if (textField == _RecordOper && !isFocusOnRecordOper) {
            NSLog(@"RecordOper");
            isStartListeningThread = YES;
            isFocusOnRecordOper = YES;
            isFocusOnVentNo = NO;
            [self indicatorROStart];
            [self listeningRecordOper];
        }
        else if(textField == _VentNo && !isFocusOnVentNo) {
            NSLog(@"VentNo");
            isStartListeningThread = YES;
            isFocusOnRecordOper = NO;
            isFocusOnVentNo = YES;
            [self indicatorVNOStart];
            [self listeningVentNo];
        }
    }
    else {
        if (textField == _RecordOper && !isFocusOnRecordOper) {
            isStartListeningThread = YES;
            isFocusOnRecordOper = YES;
            isFocusOnVentNo = NO;
            [self indicatorROStart];
        }
        else if(textField == _VentNo && !isFocusOnVentNo) {
            isStartListeningThread = YES;
            isFocusOnRecordOper = NO;
            isFocusOnVentNo = YES;
            [self indicatorVNOStart];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _RecordOper) {
        isFocusOnRecordOper = NO;
        [self indicatorROStop];
        NSLog(@"RecordOper leave");
    }
    else if(textField == _VentNo) {
        NSLog(@"VentNo leave");
        [self indicatorVNOStop];
        isFocusOnVentNo = NO;
    }
}

- (BOOL)validTextIsAllEmpty:(NSArray *)textAry {
    for (NSString *str in textAry) {
        if ([str isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == _RecordOper || textField == _ChtNo || textField == _VentNo) {
        _btnSave.enabled = NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isModeEmpty = [myMeasureData.VentilationMode isEqualToString:@""];
    
    if (textField == _RecordOper) {
        _btnSave.enabled = newString.length && _ChtNo.text.length && _VentNo.text.length && !isModeEmpty;
    }
    else if (textField == _ChtNo) {
        _btnSave.enabled = _RecordOper.text.length && newString.length && _VentNo.text.length && !isModeEmpty;
    }
    else if (textField == _VentNo) {
        _btnSave.enabled = _RecordOper.text.length && _ChtNo.text.length && newString.length && !isModeEmpty;
    }
    
    return YES;
}

#pragma mark - Methods
- (IBAction)btnSaveClick:(id)sender {
    if (myMeasureData == nil) {
        myMeasureData = [[VentilationData alloc] init];
    }
    
    for (UIViewController *child in self.childViewControllers) {
        if ([child isKindOfClass:[MeasureTabBarViewController class]]) {
            for (UIViewController *v in ((MeasureTabBarViewController *)child).viewControllers) {
                if ([v isKindOfClass:[VentilatorDataViewController class]]) {
                    if ([v isViewLoaded]) {
                        VentilatorDataViewController *vc = (VentilatorDataViewController *)v;
                        [vc getMeasureData:myMeasureData];
                    }
                }
                else if ([v isKindOfClass:[OtherDataViewController class]]) {
                    if ([v isViewLoaded]) {
                        OtherDataViewController *vc = (OtherDataViewController *)v;
                        [vc getMeasureData:myMeasureData];
                    }
                }
            }
            
        }
    }
    
    //insert data to database
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//    myMeasureData.RecordTime = [dateFormatter stringFromDate:[NSDate date]];
    myMeasureData.RecordOper = _RecordOper.text;
    myMeasureData.RecordDevice = [DeviceStatus getDeviceVendorUUID];
    myMeasureData.ChtNo = _ChtNo.text;
    myMeasureData.VentNo = _VentNo.text;
    
    if (![db saveMeasure:myMeasureData]) {
        NSLog(@"Save fail.");
    }
    else {
        [_delegate measureViewControllerDismissed:myMeasureData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)btnCancleClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setViewMode {
    viewMode = YES;
    
    [_btnSave setEnabled:NO];
}


@end
