//
//  ExternalPayment.h
//  ibox.pro.sdk
//
//  Created by Axon on 04.09.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QRData.h"

typedef enum
{
    ExternalPaymentType_LINK = 1,
    ExternalPaymentType_QR = 2
} ExternalPaymentType;

@interface ExternalPayment : NSObject

-(ExternalPaymentType)type;
-(NSArray *)data;

@end
