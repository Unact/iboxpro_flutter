//
//  PaymentOption.h
//  ibox.pro.sdk.external
//
//  Created by Axon on 10.01.18.
//  Copyright © 2018 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Acquirer.h"

@interface PaymentOption : NSObject

-(TransactionInputType)inputType;
-(Acquirer *)acquirer;

@end
