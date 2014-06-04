//
//  WebAPI.m
//  呼吸照護
//
//  Created by Farland on 2014/5/30.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "WebAPI.h"
#import "User.h"
#import "Patient.h"

#ifndef ___webapi
#define ___webapi

#define API_GET_USERS @"api/user"
#define API_GET_PATIENTS @"api/patient"
#define API_UPLOAD @"api/respiratory/"
#define API_REQUEST_TIMEOUT_INTERVAL 10. //Second

#endif

@implementation WebAPI {
    NSString *_serverPath;
}

- (id)initWithServerPath:(NSString *)serverPath {
    _serverPath = serverPath;
    return [self init];
}

- (void)dealloc {
    _delegate = nil;
}

- (void)setServerPath:(NSString *)serverPath {
    _serverPath = serverPath;
}

#pragma mark - Upload
- (void)uploadVentData:(NSData *)jsonData patientId:(NSString *)patientId measureId:(NSInteger)measureId{
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    NSURL *url = [NSURL URLWithString:[[_serverPath stringByAppendingString:API_UPLOAD] stringByAppendingString:patientId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if (data.length > 0 && connectionError == nil) {
            
        }
        else if ([httpResponse statusCode] == 200) {
            [_delegate uploadDone:measureId];
        }
        else if (connectionError) {
//            [_delegate wsConnectionError:connectionError];
        }
    }];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData length:%ld", data.length);
}

#pragma mark - User
- (void)getUserList {
    NSURL *url = [NSURL URLWithString:[_serverPath stringByAppendingString:API_GET_USERS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            
            for (NSDictionary *dict in [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]) {
                User *u = [[User alloc] init];
                u.UserIdString = [dict valueForKey:@"$id"];
                u.EmployeeId = [dict valueForKey:@"EmployeeId"] == [NSNull null] ? @"" : [dict valueForKey:@"EmployeeId"];
                u.RFID = [dict valueForKey:@"RFID"] == [NSNull null] ? @"" : [dict valueForKey:@"RFID"];
                u.BarCode = [dict valueForKey:@"BarCode"] == [NSNull null] ? @"" : [dict valueForKey:@"BarCode"];
                u.Name = [dict valueForKeyPath:@"Name"] == [NSNull null] ? @"" : [dict valueForKeyPath:@"Name"];
                
                [result addObject:u];
            }
        }
        else if ([httpResponse statusCode] == 200) {
//            [_delegate ];
        }
        else if (connectionError) {
            //            [_delegate wsConnectionError:connectionError];
        }
        [_delegate userListDelegate:result];
    }];
}

#pragma mark - Patient
- (void)getPatientList {
    NSURL *url = [NSURL URLWithString:[_serverPath stringByAppendingString:API_GET_PATIENTS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            
            for (NSDictionary *dict in [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]) {
                Patient *p = [[Patient alloc] init];
                p.PatientIdString = [dict valueForKey:@"$id"];
                p.IdentifierId = [dict valueForKey:@"IdentifierId"] == [NSNull null] ? @"" : [dict valueForKey:@"IdentifierId"];
                p.MedicalId = [dict valueForKey:@"MedicalId"] == [NSNull null] ? @"" : [dict valueForKey:@"MedicalId"];
                p.RFID = [dict valueForKey:@"RFID"] == [NSNull null] ? @"" : [dict valueForKey:@"RFID"];
                p.BarCode = [dict valueForKey:@"BarCode"] == [NSNull null] ? @"" : [dict valueForKey:@"BarCode"];
                p.Name = [dict valueForKeyPath:@"Name"] == [NSNull null] ? @"" : [dict valueForKeyPath:@"Name"];
                p.BedNo = [dict valueForKey:@"BedNo"] == [NSNull null] ? @"" : [dict valueForKey:@"BedNo"];
                p.Gender = [dict valueForKey:@"Gender"] == [NSNull null] ? @"" : [dict valueForKey:@"Gender"];
                
                [result addObject:p];
            }
        }
        else if ([httpResponse statusCode] == 200) {
            //            [_delegate ];
        }
        else if (connectionError) {
            //            [_delegate wsConnectionError:connectionError];
        }
        [_delegate patientListDelegate:result];
    }];
}

@end
