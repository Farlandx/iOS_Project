//
//  DtoGetAssociatedRespCareRecRslt.h
//  呼吸照護
//
//  Created by Farland on 2014/11/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtoGetAssociatedRespCareRecRslt : NSObject

@property (strong, nonatomic) NSString *ChtNo;
@property (strong, nonatomic) NSString *RecordTime;
@property (retain, nonatomic) NSMutableArray *Fields;

@end
