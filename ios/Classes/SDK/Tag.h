//
//  Tag.h
//  ibox.pro.sdk.external
//
//  Created by Oleh Piskorskyj on 2/7/19.
//  Copyright © 2019 ibox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (nonatomic, retain) NSString *Code;
@property (nonatomic, retain) NSObject *Value;

-(Tag *)init;

+(NSString *)tags2JsonString:(NSArray *)tags;
+(NSArray *)tagsFromJsonString:(NSString *)jsonSring;

-(NSDictionary *)data;

@end
