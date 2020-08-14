//
//  HistoryItem.h
//  iboxSDK
//
//  Created by Oleg on 19.04.13.
//  Copyright (c) 2013 Devreactor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DescriptionProduct.h"
#import "ExternalPayment.h"
#import "Card.h"
#import "FiscalInfo.h"
#include "Result.h"

typedef enum
{
    TransactionInputType_MANUAL = 1,
    TransactionInputType_SWIPE = 2,
    TransactionInputType_EMV = 3,
    TransactionInputType_NFC = 4,
    TransactionInputType_OUTER_CARD = 7,
    TransactionInputType_PREPAID = 8,
    TransactionInputType_CREDIT = 9,
    TransactionInputType_CASH = 10,
    TransactionInputType_LINK = 30
} TransactionInputType;

typedef enum
{
    TransactionReverseMode_NONE = 0,
    TransactionReverseMode_RETURN = 1,
    TransactionReverseMode_RETURN_PARTIAL = 2,
    TransactionReverseMode_CANCEL = 3,
    TransactionReverseMode_CANCEL_PARTIAL = 4,
    TransactionReverseMode_CANCEL_CNP = 5,
    TransactionReverseMode_CANCEL_CNP_PARTIAL = 6,
    TransactionReverseMode_AUTO_REVERSE = 7
} TransactionReverseMode;

typedef enum
{
    TransactionItemDisplayMode_DECLINED = 0,
    TransactionItemDisplayMode_SUCCESS = 1,
    TransactionItemDisplayMode_REVERSE = 2,
    TransactionItemDisplayMode_REVERSED = 3,
    TransactionItemDisplayMode_NON_FINANCIAL = 100
} TransactionItemDisplayMode;

@interface TransactionItem : NSObject

-(Result *)result;
-(Card *)card;
-(DescriptionProduct *)customFieldsProduct;
-(ExternalPayment *)externalPayment;
-(FiscalInfo *)fiscalInfo;
-(TransactionInputType)inputType;
-(TransactionReverseMode)reverseMode;
-(TransactionItemDisplayMode)displayMode;
-(NSDictionary *)emvData;
-(NSDictionary *)auxData;
-(NSString *)ID;
-(NSString *)date;
-(NSString *)currencyID;
-(NSString *)amountFormat;
-(NSString *)amountFormatWithoutCurrency;
-(NSString *)currencySign;
-(NSString *)currencySignSafe;
-(NSString *)descriptionOfTransaction;
-(NSString *)stateDisplay;
-(NSString *)stateLine1;
-(NSString *)stateLine2;
-(NSString *)rrn;
-(NSString *)invoice;
-(NSString *)signatureURL;
-(NSString *)photoURL;
-(NSString *)scheduleID;
-(NSString *)scheduleStepID;
-(NSString *)approvalCode;
-(NSString *)operation;
-(NSString *)cardholderName;
-(NSString *)terminalName;
-(NSString *)acquirerID;
-(NSString *)extID;
-(NSArray *)products;
-(NSArray *)customFields;
-(NSArray *)purchases;
-(NSArray *)tags;
-(double)amount;
-(double)amountNetto;
-(double)amountEff;
-(double)feeTotal;
-(double)latitude;
-(double)longitude;
-(BOOL)hasSignature;
-(BOOL)hasPhoto;
-(BOOL)hasGPSData;
-(BOOL)withOrder;
-(BOOL)withCustomFields;
-(BOOL)withAuxData;
-(BOOL)withPurchases;
-(BOOL)withTags;
-(BOOL)cashPayment;
-(BOOL)acceptReverseEMV;
-(BOOL)acceptReverseNFC;
-(int)productsCount;
-(int)currencyDecimalsCount;
-(int)state;
-(int)subState;

@end
