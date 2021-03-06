//
//  PListManager.m
//  呼吸照護
//
//  Created by Farland on 2014/9/1.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "PListManager.h"

@implementation PListManager {
    NSString *dictionaryFullPath;
    NSDictionary* dict;
}

- (id)initWithPListName:(NSString *)name {
    if(self = [super init]) {
        if (name.length) {
            [self setPListName:name];
        }
    }
    return self;
}

- (void)setPListName:(NSString *)name {
    if (name.length) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dictionaryFullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.plist", name]];
        dict = [NSDictionary dictionaryWithContentsOfFile:dictionaryFullPath];
    }
}

- (void)dealloc {
    _delegate = nil;
}

#pragma mark - Read
- (NSString *)readByKey:(NSString *)key {
    if (dict) {
        NSString *value = [dict objectForKey:key];
        if (value) {
            return value;
        }
    }
    return @"";
}

- (NSDictionary *)readDictionaryByKey:(NSString *)key {
    if (dict) {
        NSDictionary *dictValue = [dict objectForKey:key];
        if (dictValue) {
            return dictValue;
        }
    }
    return nil;
}

- (NSDictionary *)getHospital {
    if (dict) {
        NSDictionary *dictValue = [dict objectForKey:@"Hospital"];
        if (dictValue) {
            return dictValue;
        }
        //預設值
        dictValue = [[NSDictionary alloc] initWithObjects:@[@"", @""] forKeys:@[@"Name", @"IpAddress"]];
        
        [self writeByKey:@"Hospital" value:dictValue];
        
        return dictValue;
    }
    return nil;
}

- (NSDictionary *)getCareSort {
    if (dict) {
        NSDictionary *dictValue = [dict objectForKey:@"CareSort"];
        if (dictValue) {
            return dictValue;
        }
        //預設值
        dictValue = [[NSDictionary alloc] initWithObjects:@[@"", [NSNumber numberWithBool:NO]] forKeys:@[@"Key", @"Ascending"]];
        
        [self writeByKey:@"CareSort" value:dictValue];
        
        return dictValue;
    }
    return nil;
}

- (NSString *)getAdminPwd {
    if (dict) {
        NSString *stringValue = [dict objectForKey:@"AdminPwd"];
        if (stringValue.length) {
            return stringValue;
        }
    }
    return @"";
}


#pragma mark - Write
- (BOOL)writeByKey:(NSString *)key value:(id)value {
    if (dict) {
        NSMutableDictionary *newDict = [dict mutableCopy];
        [newDict setValue:value forKey:key];
        if ([newDict writeToFile:dictionaryFullPath atomically:YES]) {
            dict = newDict;
            return YES;
        }
    }
    return NO;
}

- (BOOL)writeCareSortValue:(id)value {
    if (dict && [self writeByKey:@"CareSort" value:value]) {
        [_delegate careSortChanged];
        return YES;
    }
    return NO;
}

@end
