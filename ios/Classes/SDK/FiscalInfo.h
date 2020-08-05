//
//  FiscalInfo.h
//  ibox.pro.sdk
//
//  Created by Oleh Piskorskyj on 13.08.18.
//  Copyright © 2018 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    FiscalInfoStatus_NONE = 0,
    FiscalInfoStatus_CREATED = 1,
    FiscalInfoStatus_SUCCESS = 2,
    FiscalInfoStatus_FAILURE = 4
} FiscalInfoStatus;

@interface FiscalInfo : NSObject

-(FiscalInfoStatus)status;
-(NSString *)printerSerialNumber;
-(NSString *)printerRegisterNumber;
-(NSString *)printerShift;
-(NSString *)printerCryptographicVerificationCode;
-(NSString *)printerDocSerialNumber;
-(NSString *)documentNumber;
-(NSString *)documentMark;
-(NSString *)storageNumber;
-(NSString *)dateTime;
-(NSString *)message;
-(int)error;

@end
