#import <Foundation/Foundation.h>

@interface APIResult : NSObject

-(BOOL)valid;
-(int)errorCode;
-(NSString *)errorMessage;

@end
