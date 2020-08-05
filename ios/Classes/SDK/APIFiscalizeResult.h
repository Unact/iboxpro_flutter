//
//  APIFiscalizeResult.h
//  ibox.pro.sdk.external
//
//  Created by Oleh Piskorskyj on 19/03/2020.
//  Copyright © 2020 ibox. All rights reserved.
//

#import "APIResult.h"
#import "TransactionItem.h"

@interface APIFiscalizeResult : APIResult

-(TransactionItem *)transaction;

@end
