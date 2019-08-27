//
//  Acquirer.h
//  ibox.pro.sdk
//
//  Created by Axon on 01.09.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionItem.h"

@interface Acquirer : NSObject
{
@private NSDictionary *mData;
}

-(Acquirer *)init;
-(Acquirer *)initWithDictionary:(NSDictionary *)data;

-(TransactionInputType)inputType;
-(NSString *)ID;
-(NSString *)code;
-(NSString *)name;
-(NSString *)imageUrl;

@end
