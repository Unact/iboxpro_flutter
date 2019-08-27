//
//  QRData.h
//  ibox.pro.sdk
//
//  Created by Axon on 28.09.17.
//  Copyright © 2017 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRData : NSObject
{
@private NSDictionary *mData;
@private NSString *mTitle;
@private NSString *mValue;
}

-(QRData *)init;
-(QRData *)initWithDictionary:(NSDictionary *)data;

-(void)setTitle:(NSString *)title;
-(void)setValue:(NSString *)value;
-(NSString *)title;
-(NSString *)value;

@end
