//
//  Card.h
//  ibox.pro.sdk
//
//  Created by Axon on 24.04.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

-(NSString *)iin;
-(NSString *)binID;
-(NSString *)expiration;
-(NSString *)panMasked;
-(NSString *)panEnding;

@end
