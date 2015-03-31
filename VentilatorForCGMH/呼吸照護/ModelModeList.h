//
//  ModelModeList.h
//  呼吸照護
//
//  Created by Farland on 2015/3/13.
//  Copyright (c) 2015年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelModeList : NSObject

#pragma mark 型號
@property (strong, nonatomic) NSString *Model;
#pragma mark Mode清單
@property (strong, nonatomic) NSMutableArray *ModeList;

@end
