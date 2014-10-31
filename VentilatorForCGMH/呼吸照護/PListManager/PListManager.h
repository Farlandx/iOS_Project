//
//  PListManager.h
//  呼吸照護
//
//  Created by Farland on 2014/9/1.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListManager : NSObject

- (void)setPListName:(NSString *)name;
- (NSString *)readStringByKey:(NSString *)key;
- (NSDictionary *)readDictionaryByKey:(NSString *)key;
- (BOOL)writeByKey:(NSString *)key value:(id)value;

- (id)initWithPListName:(NSString *)name;

@end
