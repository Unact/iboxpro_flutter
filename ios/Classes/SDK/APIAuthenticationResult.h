//
//  APIAuthenticationResult.h
//  ibox.pro.sdk.external
//
//  Created by Axon on 24.10.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import "APIResult.h"
#import "Account.h"

@interface APIAuthenticationResult : APIResult

-(APIAuthenticationResult *)init;
-(APIAuthenticationResult *)initWithResponseString:(NSString *)responseStrin;

-(Account *)account;
-(NSArray *)products;

@end
