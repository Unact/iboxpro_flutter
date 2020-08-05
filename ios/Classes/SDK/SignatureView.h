#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface SignatureView : GLKView

-(void)update;
-(void)updateWithOrientation:(BOOL)update;
-(BOOL)isEmpty;
-(NSData *)getByteArray;
-(void)clear;

@end
