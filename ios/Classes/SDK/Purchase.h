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

-(void)setTitle:(NSString *)title;
-(void)setTaxes:(NSArray *)taxes;
-(void)setPrice:(double)price;
-(void)setQuantity:(int)quantity;
-(NSDictionary *)data;

-(NSString *)title;
-(NSArray *)taxes;
-(double)price;
-(int)quantity;

@end
