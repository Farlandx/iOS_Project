//
//  PListManager.h
//  呼吸照護
//
//  Created by Farland on 2014/9/1.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PListManagerDelegate <NSObject>

@optional
- (void)careSortChanged;

@end

@interface PListManager : NSObject

@property (assign, nonatomic) id<PListManagerDelegate> delegate;

- (void)setPListName:(NSString *)name;
- (NSDictionary *)readDictionaryByKey:(NSString *)key;
- (NSDictionary *)getHospital;
- (NSDictionary *)getCareSort;
- (NSString *)getAdminPwd;

- (BOOL)writeByKey:(NSString *)key value:(id)value;
- (BOOL)writeCareSortValue:(id)value;

- (id)initWithPListName:(NSString *)name;

@end
