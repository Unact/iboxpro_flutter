//
//  APIHistoryResult.h
//  ibox.pro.sdk.external
//
//  Created by Axon on 7/10/15.
//  Copyright (c) 2015 ibox. All rights reserved.
//

#import "APIResult.h"

@interface APIHistoryResult : APIResult

-(NSArray *)inProcessTransactions;
-(NSArray *)transactions;

@end
