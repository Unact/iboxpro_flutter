//
//  TransactionProduct.h
//  SDK
//
//  Created by AxonMacMini on 12.06.14.
//  Copyright (c) 2014 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionProduct : NSObject

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *PriceName;
@property (nonatomic, retain) NSString *CategoryName;
@property (nonatomic, retain) NSString *ImageURLTN;
@property (nonatomic, retain) NSString *AmountFormat;
@property (nonatomic, retain) NSString *CurrencySign;
@property (nonatomic) double Price;
@property (nonatomic) double UnitPrice;
@property (nonatomic) int Count;
@property (nonatomic) BOOL HasImage;

@end
