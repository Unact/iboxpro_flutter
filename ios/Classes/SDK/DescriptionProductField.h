//
//  DescriptionProductField.h
//  ibox.pro.sdk
//
//  Created by AxonMacMini on 29.10.14.
//  Copyright (c) 2014 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DescriptionProductFieldType_NONE = 0,
    DescriptionProductFieldType_TEXT = 1,
    DescriptionProductFieldType_IMAGE = 2,
} DescriptionProductFieldType;

typedef enum
{
    DescriptionProductFieldState_DISABLED = 0,
    DescriptionProductFieldState_ENABLED = 1
} DescriptionProductFieldState;

@interface DescriptionProductField : NSObject

-(int)ID;
-(int)parentID;
-(int)fiscalTagType;
-(DescriptionProductFieldState)state;
-(DescriptionProductFieldType)type;
-(BOOL)required;
-(BOOL)textMultiline;
-(BOOL)preparable;
-(BOOL)userVisible;
-(BOOL)receiptMail;
-(BOOL)receiptPhone;
-(BOOL)isNumeric;
-(BOOL)printing;
-(BOOL)isFiscalTag;
-(BOOL)isINNSpecialTag;
-(BOOL)isINNTag;
-(NSString *)code;
-(NSString *)title;
-(NSString *)textMask;
-(NSString *)textRegExp;
-(NSString *)defaultValue;
-(NSString *)fiscalTagCode;

-(NSString *)value;

@end
