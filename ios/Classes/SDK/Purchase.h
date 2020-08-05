//
//  Purchase.h
//  ibox.pro.sdk
//
//  Created by Axon on 17.08.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purchase : NSObject

-(Purchase *)init;

+(NSString *)purchases2JsonString:(NSArray *)purchases;
+(NSArray *)purchasesFromJsonString:(NSString *)jsonSring;

-(void)setTitle:(NSString *)title;
-(void)setTaxes:(NSArray *)taxes;
-(void)setTags:(NSArray *)tags;
-(void)setQuantity:(double)quantity;
-(void)setPrice:(double)price;
-(NSDictionary *)data;

-(NSString *)title;
-(NSArray *)taxes;
-(NSArray *)tags;
-(double)quantity;
-(double)price;

@end
