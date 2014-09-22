//
//  BLETrans.m
//  PC傳輸測試
//
//  Created by Farland on 2014/7/28.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "BLETrans.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "VentilationData.h"
#import "GZIP.h"

#define SERVICE_UUID @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
#define NOTIFY_UUID @"49535343-1E4D-4BD9-BA61-23C647249616"
#define WRITE_UUID @"49535343-8841-43F4-A8D4-ECBE34729BB3"

#define NOTIFY_MTU 90

@interface BLETrans() <CBCentralManagerDelegate, CBPeripheralDelegate>

@end

@implementation BLETrans {
    CBCentralManager *_centralMgr;
    CBPeripheral *_peripheral;
    CBCharacteristic *_notifyCharacteristic;
    CBCharacteristic *_writeCharacteristic;
    NSTimer *timeoutTimer;
    BOOL isFindDevice;
    
    DtoVentExchangeUploadBatch *batch;
    
    NSData *dataToSend;
    NSData *SOH;
    NSData *ETX;
    NSData *EOT;
    NSInteger sendDataIndex;
    NSString *stringData;
}

- (id)init {
    if (self = [super init]) {
        isFindDevice = NO;
        SOH = [@"\x01\x01\x01" dataUsingEncoding:NSUTF8StringEncoding];
        ETX = [@"\x03\x03\x03" dataUsingEncoding:NSUTF8StringEncoding];
        EOT = [@"\x04\x04\x04" dataUsingEncoding:NSUTF8StringEncoding];
        
        stringData = @"";
    }
    return self;
}

- (void)dealloc {
    [self disconnect];
    _delegate = nil;
}

#pragma mark - Public Method
- (void)SendBatchData:(DtoVentExchangeUploadBatch *)batchData {
    if (batchData == nil || batchData.VentRecList.count == 0) {
        return;
    }
    
    isFindDevice = NO;
    batch = batchData;
    
    sendDataIndex = 0;
    NSMutableData *data = [[NSMutableData alloc] init];
    
    [data appendData:SOH];
    [data appendData:[[self getTransferData] gzippedData]];
    [data appendData:EOT];
    
    dataToSend = data;
    
    if (!_centralMgr) {
        _centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    else {
        [self scanDevices];
    }
}

- (void)CancelTrans {
    [self disconnect];
}

#pragma mark - Private Method
- (void)scanDevices {
    [_centralMgr scanForPeripheralsWithServices:nil options:nil];
}

- (void)scanBLETransStop:(NSTimer*)timer {
    if (_centralMgr != nil){
        [_centralMgr stopScan];
    }else{
        NSLog(@"_centralMgr is Null!");
    }
}

- (void)sendStop:(NSTimer*)timer {
    [self disconnect];
}

- (NSData *)getTransferData {
    NSString *soapMessage = @"<DtoVentExchangeUploadBatch>"
    "<UploadOper>%@</UploadOper>"
    "<UploadIp>%@</UploadIp>"
    "<UploadTime>%@</UploadTime>"
    "<Device>%@</Device>"
    "<ClientVersion>%@</ClientVersion>"
    "<VentRecList>";
    soapMessage = [NSString stringWithFormat:soapMessage,
                   batch.UploadOper,
                   batch.UploadIp,
                   batch.UploadTime,
                   batch.Device,
                   batch.ClientVersion];
    
    if ([batch.VentRecList count] > 0) {
        for (VentilationData *ventData in batch.VentRecList) {
            NSString *tmp = @"<DtoVentExchangeUpload>";
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<ChtNo>%@</ChtNo>", ventData.ChtNo]];
            tmp = [tmp stringByAppendingString:@"<RawData></RawData>"];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordIp>%@</RecordIp>", ventData.RecordIp]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordOper>%@</RecordOper>", ventData.RecordOper]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordTime>%@</RecordTime>", ventData.RecordTime]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VentNo>%@</VentNo>", ventData.VentNo]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordDevice>%@</RecordDevice>", ventData.RecordDevice]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordClientVersion>%@</RecordClientVersion>", ventData.RecordClientVersion]];
            
            tmp = [tmp stringByAppendingString:@"<VentRecord>"];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<AutoFlow>%@</AutoFlow>", ![ventData.AutoFlow caseInsensitiveCompare:@"Yes"] ? @"1" : @"0"]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<BaseFlow>%@</BaseFlow>", ventData.BaseFlow]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Compliance>%@</Compliance>", ventData.Compliance]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<FiO2Measured>%@</FiO2Measured>", ventData.FiO2Measured]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<FiO2Set>%@</FiO2Set>", ventData.FiO2Set]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<FlowMeasured>%@</FlowMeasured>", ventData.FlowMeasured]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<FlowSensitivity>%@</FlowSensitivity>", ventData.FlowSensitivity]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<FlowSetting>%@</FlowSetting>", ventData.FlowSetting]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<HighPressureAlarm>%@</HighPressureAlarm>", ventData.HighPressureAlarm]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<InspirationExpirationRatio>%@</InspirationExpirationRatio>", ventData.InspirationExpirationRatio]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<InspT>%@</InspT>", ventData.InspT]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<LowerMV>%@</LowerMV>", ventData.LowerMV]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<MeanPressure>%@</MeanPressure>", ventData.MeanPressure]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<MVSet>%@</MVSet>", ventData.MVSet]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<MVTotal>%@</MVTotal>", ventData.MVTotal]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Pattern>%@</Pattern>", ventData.Pattern]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PeakPressure>%@</PeakPressure>", ventData.PeakPressure]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PEEP>%@</PEEP>", ventData.PEEP]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PercentMinVolSet>%@</PercentMinVolSet>", ventData.PercentMinVolSet]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PHigh>%@</PHigh>", ventData.PHigh]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PlateauPressure>%@</PlateauPressure>", ventData.PlateauPressure]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Plow>%@</Plow>", ventData.Plow]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PressureControl>%@</PressureControl>", ventData.PressureControl]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PressureSupport>%@</PressureSupport>", ventData.PressureSupport]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<ReliefPressure>%@</ReliefPressure>", ventData.ReliefPressure]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Resistance>%@</Resistance>", ventData.Resistance]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<SIMVRateSet>%@</SIMVRateSet>", ventData.SIMVRateSet]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Temperature>%@</Temperature>", ventData.Temperature]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<THigh>%@</THigh>", ventData.THigh]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<TidalVolumeMeasured>%@</TidalVolumeMeasured>", ventData.TidalVolumeMeasured]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<TidalVolumeSet>%@</TidalVolumeSet>", ventData.TidalVolumeSet]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Tlow>%@</Tlow>", ventData.Tlow]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VentilationMode>%@</VentilationMode>", ventData.VentilationMode]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VentilationRateSet>%@</VentilationRateSet>", ventData.VentilationRateSet]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VentilationRateTotal>%@</VentilationRateTotal>", ventData.VentilationRateTotal]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VolumeTarget>%@</VolumeTarget>", ventData.VolumeTarget]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PetCo2>%@</PetCo2>", ventData.PetCo2]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<SpO2>%@</SpO2>", ventData.SpO2]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RR>%@</RR>", ventData.RR]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<TV>%@</TV>", ventData.TV]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<MV>%@</MV>", ventData.MV]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<MaxPi>%@</MaxPi>", ventData.MaxPi]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Mvv>%@</Mvv>", ventData.Mvv]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Rsbi>%@</Rsbi>", ventData.Rsbi]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<EtSize>%@</EtSize>", ventData.EtSize]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Mark>%@</Mark>", ventData.Mark]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<CuffPressure>%@</CuffPressure>", ventData.CuffPressure]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<BreathSounds>%@</BreathSounds>", ventData.BreathSounds]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Pr>%@</Pr>", ventData.Pr]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Cvp>%@</Cvp>", ventData.Cvp]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<BpS>%@</BpS>", ventData.BpS]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<BpD>%@</BpD>", ventData.BpD]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<Xrem>%@</Xrem>", ventData.Xrem]];
            //20140902新增欄位
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VentilationHertz>%@</VentilationHertz>", ventData.VentilationHertz]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<PressureAmplitude>%@</PressureAmplitude>", ventData.PressureAmplitude]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<TubeCompensation>%@</TubeCompensation>", ventData.TubeCompensation]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VolumeAssist>%@</VolumeAssist>", ventData.VolumeAssist]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<FlowAssist>%@</FlowAssist>", ventData.FlowAssist]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<EdiPeak>%@</EdiPeak>", ventData.EdiPeak]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<EdiMin>%@</EdiMin>", ventData.EdiMin]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<NavaLevel>%@</NavaLevel>", ventData.NavaLevel]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<EdiTrigger>%@</EdiTrigger>", ventData.EdiTrigger]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<NO>%@</NO>", ventData._NO]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<NO2>%@</NO2>", ventData.NO2]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<LeakTest>%@</LeakTest>", ventData.LeakTest]];
            tmp = [tmp stringByAppendingString:@"</VentRecord>"];
            
            tmp = [tmp stringByAppendingString:@"</DtoVentExchangeUpload>"];
            
            soapMessage = [soapMessage stringByAppendingString:tmp];
        }
    }

    soapMessage = [soapMessage stringByAppendingString:@"</VentRecList>"
                                                        "</DtoVentExchangeUploadBatch>"];
    
    return [soapMessage dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)sendData {
    const char *bytes = [dataToSend bytes];
    NSInteger dataLength = (int)[dataToSend length];
    [timeoutTimer invalidate];
    if (sendDataIndex < dataLength) {
        NSInteger size = (dataLength - sendDataIndex);
        BOOL hasETX = NO;
        
        if (size > NOTIFY_MTU) {
            hasETX = YES;
            size = NOTIFY_MTU;
            
            timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sendStop:) userInfo:nil repeats:NO];
        }
        
        NSMutableData *buffer =[[NSMutableData alloc] initWithData:[NSData dataWithBytes:bytes + sendDataIndex length:size]];
        
        if (hasETX) {
            [buffer appendData:ETX];
        }
        else {
            NSLog(@"NO ETX");
        }
        
        [_peripheral writeValue:buffer forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        
        sendDataIndex += size;
        
    }
    
//    NSLog(@"%ld / %ld", sendDataIndex, dataLength);
    NSLog(@"%@", [NSString stringWithFormat:@"%.1f%%", (float)sendDataIndex / (float)dataLength * 100]);
    [_delegate UploadProgress:(float)sendDataIndex / (float)dataLength];
}

- (void)disconnect {
    if (_peripheral && _peripheral.state != CBPeripheralStateDisconnected) {
        [_centralMgr cancelPeripheralConnection:_peripheral];
        _notifyCharacteristic = nil;
        _writeCharacteristic = nil;
        isFindDevice = NO;
    }
}

#pragma mark - CBCentralManagerDelegate
//檢查設備是否支持BLE
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self scanDevices];
    }
}

//掃到設備
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *peripheralName = [peripheral.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"Discovered %@, UUID:%@, RSSI:%@", peripheralName, [[peripheral identifier] UUIDString], RSSI);
    
    if ([peripheralName isEqualToString:BLE_DEVICE_NAME] && !isFindDevice) {
        [timeoutTimer invalidate];
        isFindDevice = YES;
        stringData = @"";
        
        NSArray *ary = [_centralMgr retrievePeripheralsWithIdentifiers:@[peripheral.identifier]];
        
        if (ary == nil || ary.count == 0) {
            return;
        }
        _peripheral = [ary objectAtIndex:0];
        [_centralMgr connectPeripheral:_peripheral options:nil];
    }
    else if (!isFindDevice){
        [timeoutTimer invalidate];
        timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scanBLETransStop:) userInfo:nil repeats:NO];
    }
}

//中斷連線
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (_peripheral) {
        _peripheral = nil;
        
        NSLog(@"Disconnected.");
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@ connected.", peripheral.name);
    
    if(_peripheral != nil) {
        peripheral.delegate = self;
        
        //執行"discoverService"功能去尋找可用的Service
        [peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];//藍牙棒Service UUID
    }
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        return;
    }
    
    for (CBService *service in peripheral.services) {
        if (service.characteristics) {
            [self peripheral:peripheral didDiscoverCharacteristicsForService:service error:nil]; //already discovered characteristic before, DO NOT do it again
        }
        else {
            [peripheral discoverCharacteristics:nil forService:service]; //need to discover characteristics
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:NOTIFY_UUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            _notifyCharacteristic = characteristic;
            NSLog(@"[notify]didDiscoverCharacteristicsForService");
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_UUID]]) {
            [peripheral setNotifyValue:NO forCharacteristic:characteristic];
            _writeCharacteristic = characteristic;
            NSLog(@"[write]didDiscoverCharacteristicsForService");
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    if (_peripheral.state != CBPeripheralStateDisconnected && _notifyCharacteristic != nil && _writeCharacteristic != nil) {
        [self sendData];
    }
}

//收到資料
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"peripheral error");
        return;
    }
    
    if (characteristic.value) {
        NSString *value = [NSString stringWithUTF8String:[characteristic.value bytes]];
        if ([value isEqualToString:@"n"]) {
            [self sendData];
        }
        else {
            stringData = [stringData stringByAppendingString:value];
            NSLog(@"%@", value);
        }
        
        unsigned char* bytes =  (unsigned char*)[characteristic.value bytes];
        for (int i = 0; i < [characteristic.value length]; i++) {
            if (bytes[i] == 0x04) {
                stringData = [stringData stringByReplacingOccurrencesOfString:@"\x04" withString:@""];
                [self disconnect];
                [_delegate BLETransUploadDone:stringData];
                return;
            }
        }
    }
}
@end
