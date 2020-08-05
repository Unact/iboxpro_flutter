//
//  PaymentContext.h
//  ibox.pro.sdk.external
//
//  Created by Axon on 5/12/15.
//  Copyright (c) 2015 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionItem.h"

typedef enum
{
    CurrencyType_RUB,
    CurrencyType_VND
} CurrencyType;

@interface PaymentContext : NSObject

@property (nonatomic, assign) double Amount;
@property (nonatomic, assign) double AmountCash;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic, retain) NSString *ExtID;
@property (nonatomic, retain) NSString *ReceiptMail;
@property (nonatomic, retain) NSString *ReceiptPhone;
@property (nonatomic, retain) NSString *ProductCode;
@property (nonatomic, retain) NSString *Acquirer;
@property (nonatomic, retain) NSString *AuxData;
@property (nonatomic, retain) NSArray *ProductData;
@property (nonatomic, retain) NSArray *Purchases;
@property (nonatomic, retain) NSArray *Tags;
@property (nonatomic, retain) NSData *Image;
@property (nonatomic, assign) CurrencyType Currency;
@property (nonatomic, assign) TransactionInputType InputType;

@end
