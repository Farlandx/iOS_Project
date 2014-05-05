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

#ifndef ___webservice
#define ___webservice
#define WS_NAMESPACE @"http://cgmh.org.tw/g27/"
//#define WS_URL @"http://172.30.1.119:8883/VentDataExchangeSvc.asmx"
#define WS_URL @"http://10.30.11.54/webwork/resp/VentDataExchangeSvc.asmx"

#define WS_GET_CUR_RT_CARD_LIST @"GetCurRtCardList"
#define WS_GET_CUR_RT_CARD_LIST_VER_ID @"GetCurRtCardListVerId"
#define WS_APPLOGIN @"AppLogin"
#define WS_GET_PATIENT_LIST @"GetPatientList"

#endif

@implementation WebService

- (void)dealloc {
    _delegate = nil;
}

#pragma mark - Private Method
/*- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}*/

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
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%@", WS_URL, swString];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}

- (NSMutableURLRequest *) getMutableURLRequestByWSString:(NSString *) swString {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%@", WS_URL, swString];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSMutableURLRequest requestWithURL:url];
}

- (NSMutableURLRequest *) getSOAPRequestByWSString:(NSString *) swString soapMessage:(NSString *)soapMessage {
    NSURL *url = [NSURL URLWithString:WS_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
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
    if (deviceName == nil || [deviceName isEqualToString:@""] || idNo == nil || [idNo isEqualToString:@""]) {
        return;
    }
    
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
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<RecordTime>%@</RecordTime>", [self getSOAPDateStringByNSString:ventData.RecordTime]]];
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
            tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"<VentilationMode>%@</VentilationMode>", @"IPPV"]];
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
    
    NSMutableURLRequest *request = [self getSOAPRequestByWSString: WS_APPLOGIN soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSLog(@"upload:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSDictionary *dtoUploadVentDataResult in [xmlDictionary valueForKeyPath:@"Envelope.Body.UploadVentDataResponse.UploadVentDataResult.DtoUploadVentDataResult"]) {
                DtoUploadVentDataResult *tmp = [[DtoUploadVentDataResult alloc] init];
                tmp.ChtNo = [dtoUploadVentDataResult valueForKeyPath:@"ChtNo.text"];
                tmp.RecordTime = [dtoUploadVentDataResult valueForKeyPath:@"RecordTime.text"];
                tmp.Success = [[dtoUploadVentDataResult valueForKeyPath:@"Success.text"] boolValue];
                tmp.Message = [dtoUploadVentDataResult valueForKeyPath:@"Message.text"];
                if (tmp.Success) {
                    tmp.RecordOperName = [dtoUploadVentDataResult valueForKeyPath:@"RecordOperName.text"];
                    tmp.UploadOperName = [dtoUploadVentDataResult valueForKeyPath:@"UploadOperName.text"];
                    tmp.VentilatorModel = [dtoUploadVentDataResult valueForKeyPath:@"VentilatorModel.text"];
                    tmp.BedNo = [[dtoUploadVentDataResult valueForKeyPath:@"BedNo.text"] stringValue];
                }
                [result addObject:tmp];
            }
            
            [_delegate wsUploadVentData:result DtoVentExchangeUploadBatch:(DtoVentExchangeUploadBatch *)batch];
        }
    }];
}

- (void)getCurRtCardList {
//    NSURLRequest *request = [self getURLRequestByWSString: WS_GET_CUR_RT_CARD_LIST];
    
    
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
    soapMessage = [NSString stringWithFormat:soapMessage];
    
    NSMutableURLRequest *request = [self getSOAPRequestByWSString: WS_GET_CUR_RT_CARD_LIST soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            NSDictionary *cardDictionary = [xmlDictionary objectForKey:@"ArrayOfDtoRtCard"];
            for (NSDictionary *card in [cardDictionary objectForKey:@"DtoRtCard"]) {
                NSDictionary *cNo = [card objectForKey:@"CardNo"];
                [result addObject:[cNo objectForKey:@"text"]];
            }
            
            [_delegate wsResponseCurRtCardList:result];
        }
    }];
}

- (void)getCurRtCardListVerId {
    NSURLRequest *request = [self getURLRequestByWSString: WS_GET_CUR_RT_CARD_LIST_VER_ID];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            int result = [[xmlDictionary valueForKeyPath:@"int.text"] intValue];
            
            [_delegate wsResponseCurRtCardListVerId:result];
        }
    }];
}

- (void)getPatientList {
    NSURLRequest *request = [self getURLRequestByWSString: WS_GET_PATIENT_LIST];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            NSDictionary *patientDictionary = [xmlDictionary objectForKey:@"ArrayOfDtoVentExchangeGetPatient"];
            for (NSDictionary *card in [patientDictionary objectForKey:@"DtoVentExchangeGetPatient"]) {
                [result addObject:card];
            }
            
            [_delegate wsResponsePatientList:result];
        }
    }];}

@end
