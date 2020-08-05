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
    DescriptionProductInputType_PAYMENT = 0x00000001,
    DescriptionProductInputType_RECURRENT = 0x00000002,
    DescriptionProductInputType_NONE = 0x00000000,
    DescriptionProductInputType_ALL = 0xFFFF
} DescriptionProductInputType;

typedef enum
{
    DescriptionProductRecurrentMode_NONE = 0,
    DescriptionProductRecurrentMode_DEFAULT = 1,
    DescriptionProductRecurrentMode_MANAGED = 2
} DescriptionProductRecurrentMode;

typedef enum
{
    DescriptionProductState_DISABLED = 0,
    DescriptionProductState_ENABLED = 1
} DescriptionProductState;

@interface DescriptionProduct : NSObject

-(int)ID;
-(int)fieldsCount;
-(BOOL)preparable;
-(BOOL)preparableOptional;
-(BOOL)preparableEditable;
-(BOOL)visible;
-(DescriptionProductState)state;
-(DescriptionProductInputType)inputType;
-(DescriptionProductRecurrentMode)recurrentMode;
-(DescriptionProductField *)preparableField;
-(DescriptionProductField *)firstTextField;
-(NSString *)code;
-(NSString *)title;
-(NSString *)qrRegex;
-(NSArray *)fields;
-(NSArray *)preparableFields;

@end
