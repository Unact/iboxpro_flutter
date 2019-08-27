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
    DescriptionProductFieldType_None = 0,
    DescriptionProductFieldType_Text = 1,
    DescriptionProductFieldType_Image = 2,
} DescriptionProductFieldType;

typedef enum
{
    DescriptionProductFieldState_Disabled = 0,
    DescriptionProductFieldState_Enabled = 1
} DescriptionProductFieldState;

@interface DescriptionProductField : NSObject

-(int)ID;
-(int)parentID;
-(DescriptionProductFieldState)state;
-(DescriptionProductFieldType)type;
-(BOOL)required;
-(BOOL)textMultiline;
-(NSString *)code;
-(NSString *)title;
-(NSString *)textMask;
-(NSString *)textRegExp;
-(NSString *)defaultValue;

-(NSString *)value;

@end
