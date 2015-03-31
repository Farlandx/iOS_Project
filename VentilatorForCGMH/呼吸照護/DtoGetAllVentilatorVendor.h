//
//  DtoGetAllVentilatorVendor.h
//  呼吸照護
//
//  Created by Farland on 2015/3/12.
//  Copyright (c) 2015年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtoGetAllVentilatorVendor : NSObject

#pragma mark 廠牌代號
@property (strong, nonatomic) NSString *VendorId;
#pragma mark 廠牌名稱
@property (strong, nonatomic) NSString *VendorName;

@end
