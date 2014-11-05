//
//  WebService.m
//  CommandLineTest
//
//  Created by Farland on 2014/4/17.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>
#import "WebService.h"
#import "XMLReader.h"
#import "VentilationData.h"
#import "DeviceStatus.h"
#import "Patient.h"
#import "PListManager.h"

#ifndef ___webservice
#define ___webservice
#define WS_NAMESPACE @"http://cgmh.org.tw/g27/"
//#define WS_URL @"http://172.30.1.119:8883/VentDataExchangeSvc.asmx"

//林口
//#define WS_URL @"http://10.30.11.54/webwork/resp/VentDataExchangeSvc.asmx"
//高雄
//#define WS_URL @"http://10.40.11.21/webwork/resp/VentDataExchangeSvc.asmx"
//嘉義
//#define WS_URL @"http://10.48.11.10/webwork/resp/VentDataExchangeSvc.asmx"

#define WS_GET_CUR_RT_CARD_LIST @"GetCurRtCardList"
#define WS_GET_CUR_RT_CARD_LIST_VER_ID @"GetCurRtCardListVerId"
#define WS_APPLOGIN @"AppLogin"
#define WS_GET_PATIENT_LIST @"GetPatientList"
#define WS_UPLOAD_VENT_DATA @"UploadVentData"
#define WS_REQUEST_TIMEOUT_INTERVAL 10 //Second

#endif

@implementation WebService {
    PListManager *plManager;
    NSDictionary *hospital;
    NSString *WS_URL;
}

- (void)dealloc {
    _delegate = nil;
    
    plManager = [[PListManager alloc] initWithPListName:@"Properties"];
    hospital = [plManager getHospital];
    WS_URL = @"";
}

#pragma mark - Private Method
- (NSString *)getHospitalIpAddress {
    NSString *hospitalName = [hospital objectForKey:@"Name"];
    if ([hospitalName isEqualToString:@""]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"http://%@/webwork/resp/VentDataExchangeSvc.asmx", hospitalName];
}

- (NSString *)getSOAPDateStringByNSString:(NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    // get NSDate from old string format
    NSDate *date = [dateFormatter dateFromString:dateString ];
    
    // get string in new date format
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

- (NSURLRequest *) getURLRequestByWSString:(NSString *) swString {
    WS_URL = [self getHospitalIpAddress];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", WS_URL, swString];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}

- (NSMutableURLRequest *) getMutableURLRequestByWSString:(NSString *) swString {
    WS_URL = [self getHospitalIpAddress];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", WS_URL, swString];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSMutableURLRequest requestWithURL:url];
}

- (NSMutableURLRequest *) getSOAPRequestByWSString:(NSString *) swString soapMessage:(NSString *)soapMessage {
    WS_URL = [self getHospitalIpAddress];
    NSURL *url = [NSURL URLWithString:WS_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WS_REQUEST_TIMEOUT_INTERVAL];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    
    [request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: swString forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - WebService Method
- (void)appLoginDeviceName:(NSString *)deviceName idNo:(NSString *)idNo {
    
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                            "<soap12:Body>"
                            "<AppLogin xmlns=\"http://cgmh.org.tw/g27/\">"
                            "<deviceName>%@</deviceName>"
                            "<app>CYH_Ventilator</app>"
                            "<appPwd>jkh3$kl52</appPwd>"
                            "<idNo>%@</idNo>"
                            "</AppLogin>"
                            "</soap12:Body>"
                            "</soap12:Envelope>";
    soapMessage = [NSString stringWithFormat:soapMessage, deviceName, idNo];
    
    NSMutableURLRequest *request = [self getSOAPRequestByWSString: WS_APPLOGIN soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            NSString *sessionId = [xmlDictionary valueForKeyPath:@"Envelope.Body.AppLoginResponse.AppLoginResult.text"];
            
            [_delegate wsAppLogin:sessionId];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
        else {
            [_delegate wsError];
        }
    }];
}

- (void)uploadVentDataBySessionId:(NSString *)sessionId  DtoVentExchangeUploadBatch:(DtoVentExchangeUploadBatch *)batch {

    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                                 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                                 "<soap12:Body>"
                                 "<UploadVentData xmlns=\"http://cgmh.org.tw/g27/\">"
                                 "<data>"
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
//            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordTime>%@</RecordTime>", [self getSOAPDateStringByNSString:ventData.RecordTime]]];
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
            //20141023新增欄位
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<MaxPe>%@</MaxPe>", ventData.MaxPe]];
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VC>%@</VC>", ventData.VC]];
            tmp = [tmp stringByAppendingString:@"</VentRecord>"];
            
            tmp = [tmp stringByAppendingString:@"</DtoVentExchangeUpload>"];
            
            soapMessage = [soapMessage stringByAppendingString:tmp];
        }
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</VentRecList>"
                                                                                  "</data>"
                                                                                  "<sessionId>%@</sessionId>"
                                                                                  "</UploadVentData>"
                                                                                  "</soap12:Body>"
                                                                                  "</soap12:Envelope>", sessionId]];
    
    NSMutableURLRequest *request = [self getSOAPRequestByWSString: WS_UPLOAD_VENT_DATA soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSLog(@"upload:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            
            NSMutableArray *uploadSuccess = [[NSMutableArray alloc] init];
            NSMutableArray *uploadFailed = [[NSMutableArray alloc] init];
            int index = 0;
            NSDictionary *dtoUploadVentDataResultList = [xmlDictionary valueForKeyPath:@"Envelope.Body.UploadVentDataResponse.UploadVentDataResult.DtoUploadVentDataResult"];
            if (batch.VentRecList.count > 1) {
                //多筆
                for (NSDictionary *dtoUploadVentDataResult in dtoUploadVentDataResultList) {
                    DtoUploadVentDataResult *tmp = [[DtoUploadVentDataResult alloc] init];
                    tmp.ChtNo = [dtoUploadVentDataResult valueForKeyPath:@"ChtNo.text"];
                    tmp.RecordTime = [dtoUploadVentDataResult valueForKeyPath:@"RecordTime.text"];
                    tmp.Success = [[dtoUploadVentDataResult valueForKeyPath:@"Success.text"] boolValue];
                    tmp.Message = [dtoUploadVentDataResult valueForKeyPath:@"Message.text"];
                    if (tmp.Success) {
                        tmp.RecordOperName = [dtoUploadVentDataResult valueForKeyPath:@"RecordOperName.text"];
                        tmp.UploadOperName = [dtoUploadVentDataResult valueForKeyPath:@"UploadOperName.text"];
                        tmp.VentilatorModel = [dtoUploadVentDataResult valueForKeyPath:@"VentilatorModel.text"];
                        tmp.BedNo = [dtoUploadVentDataResult valueForKeyPath:@"BedNo.text"];
                        
                        ((VentilationData *)batch.VentRecList[index]).RecordOperName = tmp.RecordOperName;
                        ((VentilationData *)batch.VentRecList[index]).VentilatorModel = tmp.VentilatorModel;
                        ((VentilationData *)batch.VentRecList[index]).BedNo = tmp.BedNo;
                        [uploadSuccess addObject:batch.VentRecList[index]];
                    }
                    else {
                        ((VentilationData *)batch.VentRecList[index]).ErrorMsg = tmp.Message;
                        [uploadFailed addObject:batch.VentRecList[index]];
                        
                    }
                    index++;
                }
                
            }
            else {
                //單筆
                DtoUploadVentDataResult *tmp = [[DtoUploadVentDataResult alloc] init];
                tmp.ChtNo = [dtoUploadVentDataResultList valueForKeyPath:@"ChtNo.text"];
                tmp.RecordTime = [dtoUploadVentDataResultList valueForKeyPath:@"RecordTime.text"];
                tmp.Success = [[dtoUploadVentDataResultList valueForKeyPath:@"Success.text"] boolValue];
                tmp.Message = [dtoUploadVentDataResultList valueForKeyPath:@"Message.text"];
                if (tmp.Success) {
                    tmp.RecordOperName = [dtoUploadVentDataResultList valueForKeyPath:@"RecordOperName.text"];
                    tmp.UploadOperName = [dtoUploadVentDataResultList valueForKeyPath:@"UploadOperName.text"];
                    tmp.VentilatorModel = [dtoUploadVentDataResultList valueForKeyPath:@"VentilatorModel.text"];
                    tmp.BedNo = [dtoUploadVentDataResultList valueForKeyPath:@"BedNo.text"];
                    
                    ((VentilationData *)batch.VentRecList[index]).RecordOperName = tmp.RecordOperName;
                    ((VentilationData *)batch.VentRecList[index]).VentilatorModel = tmp.VentilatorModel;
                    ((VentilationData *)batch.VentRecList[index]).BedNo = tmp.BedNo;
                    [uploadSuccess addObject:batch.VentRecList[index]];
                }
                else {
                    ((VentilationData *)batch.VentRecList[index]).ErrorMsg = tmp.Message;
                    [uploadFailed addObject:batch.VentRecList[index]];
                    
                }
            }
            
            [_delegate wsUploadVentDataSuccess:uploadSuccess uploadFailed:uploadFailed DtoVentExchangeUploadBatch:batch];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
        else {
            [_delegate wsError];
        }
    }];
}

- (void)getCurRtCardList {
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
    "<soap12:Body>"
    "<GetCurRtCardList xmlns=\"http://cgmh.org.tw/g27/\" />"
    "</soap12:Body>"
    "</soap12:Envelope>";
    
    NSMutableURLRequest *request = [self getSOAPRequestByWSString: WS_GET_CUR_RT_CARD_LIST soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            for (NSDictionary *card in [xmlDictionary valueForKeyPath:@"Envelope.Body.GetCurRtCardListResponse.GetCurRtCardListResult.DtoRtCard"]) {
                [result addObject:[card valueForKeyPath:@"CardNo.text"]];
            }
            
            [_delegate wsResponseCurRtCardList:result];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
    }];
}

- (void)getCurRtCardListVerId {
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
    "<soap12:Body>"
    "<GetCurRtCardListVerId xmlns=\"http://cgmh.org.tw/g27/\" />"
    "</soap12:Body>"
    "</soap12:Envelope>";
    
    NSURLRequest *request = [self getSOAPRequestByWSString:WS_GET_CUR_RT_CARD_LIST_VER_ID soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            int result = [[xmlDictionary valueForKeyPath:@"Envelope.Body.GetCurRtCardListVerIdResponse.GetCurRtCardListVerIdResult.text"] intValue];
            
            [_delegate wsResponseCurRtCardListVerId:result];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
        else {
            [_delegate wsError];
        }
    }];
}

- (void)getPatientList {
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
    "<soap12:Body>"
    "<GetPatientList xmlns=\"http://cgmh.org.tw/g27/\" />"
    "</soap12:Body>"
    "</soap12:Envelope>";
    
    NSURLRequest *request = [self getSOAPRequestByWSString:WS_GET_PATIENT_LIST soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            for (NSDictionary *card in [xmlDictionary valueForKeyPath:@"Envelope.Body.GetPatientListResponse.GetPatientListResult.DtoVentExchangeGetPatient"]) {
                Patient *p = [[Patient alloc] init];
                p.ChtNo = [card valueForKeyPath:@"ChtNo.text"];
                p.BedNo = [card valueForKeyPath:@"BedNo.text"];
                [result addObject:p];
            }
            
            [_delegate wsResponsePatientList:result];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
        else {
            [_delegate wsError];
        }
    }];
}

@end
