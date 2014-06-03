//
//  WebAPI.m
//  呼吸照護
//
//  Created by Farland on 2014/5/30.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "WebAPI.h"

#ifndef ___webapi
#define ___webapi

#define API_GET_USER @"api/user"
#define API_GET_PATIENT @"api/patient"
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
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            
//            [_delegate wsResponsePatientList:result];
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
- (void)getUserList:(NSData *)ventData patientId:(NSString *)patientId {
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[_serverPath stringByAppendingString:API_GET_USER]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
//    vebtData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        ventData = nil;
        
        // Inform the user that the connection failed.
    }
}

@end
