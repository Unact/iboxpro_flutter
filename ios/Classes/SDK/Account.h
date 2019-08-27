//
//  Account.h
//  ibox.pro.sdk.external
//
//  Created by Axon on 23.08.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentOption.h"

@interface Account : NSObject

-(Acquirer *)acquirerWithCode:(NSString *)code;
-(NSString *)pkString;
-(NSString *)name;
-(NSString *)email;
-(NSString *)phone;
-(NSString *)web;
-(NSString *)accountDescription;
-(NSString *)bankName;
-(NSString *)clientLegalAddress;
-(NSString *)clientRealAddress;
-(NSString *)clientID;
-(NSString *)clientName;
-(NSString *)clientLegalName;
-(NSString *)clientPhone;
-(NSString *)clientWeb;
-(NSString *)branchID;
-(NSString *)branchName;
-(NSString *)branchPhone;
-(NSString *)branchAdress;
-(NSString *)finstID;
-(NSString *)currencyID;
-(NSString *)currencyCode;
-(NSString *)currencySign;
-(NSString *)currencySignSafe;
-(NSString *)amountFormat;
-(NSString *)amountFormatWithoutCurrency;
-(NSString *)amountCulture;
-(NSString *)phonePrefix;
-(NSString *)homeUrl;
-(NSString *)qrUrl;
-(NSString *)languageID;
-(NSString *)countryID;
-(NSString *)terminalName;
-(NSString *)taxID;
-(NSString *)printerID;
-(NSString *)avatarUrl;
-(NSString *)avatarStamp;
-(NSString *)transactionsFilter;
-(NSString *)schedulesFilter;
-(NSString *)lastActivity;
-(NSString *)inventoryUpdated;
-(NSArray *)linkedCards;
-(NSArray *)inputTypes;
-(NSArray *)paymentOptions;
-(BOOL)usesServerFiscalization;
-(BOOL)allowLinkCards;
-(BOOL)hasAvatar;
-(BOOL)canViewPrinterBlock;
-(BOOL)canEditTax;
-(BOOL)canEditPrinter;
-(BOOL)printerUsed;
-(BOOL)taxUsed;
-(BOOL)useBarcodeScanner;
-(BOOL)gpsRequired;
-(BOOL)singleStepAuthMode;
-(BOOL)supportsBalanceInquiry;
-(int)pk;
-(int)allowedLinkedCardsCount;
-(int)state;
-(int)type;
-(int)taxCalcMode;
-(int)currencyDecimals;

@end
