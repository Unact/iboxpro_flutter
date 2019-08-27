//
//  DescriptionProduct.h
//  ibox.pro.sdk
//
//  Created by AxonMacMini on 29.10.14.
//  Copyright (c) 2014 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DescriptionProductField.h"

typedef enum
{
    DescriptionProductInputType_Payment = 0x00000001,
    DescriptionProductInputType_Recurrent = 0x00000002,
    DescriptionProductInputType_None = 0x00000000,
    DescriptionProductInputType_All = 0xFFFF
} DescriptionProductInputType;

typedef enum
{
    DescriptionProductState_Disabled = 0,
    DescriptionProductState_Enabled = 1
} DescriptionProductState;

@interface DescriptionProduct : NSObject

-(int)ID;
-(DescriptionProductState)state;
-(DescriptionProductInputType)inputType;
-(int)fieldsCount;
-(NSString *)code;
-(NSString *)title;
-(NSArray *)fields;

@end