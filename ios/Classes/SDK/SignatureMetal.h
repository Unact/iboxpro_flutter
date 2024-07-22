//
//  SignatureMetal.h
//  ibox.pro.sdk
//
//  Created by Oleh Piskorskyj on 01/06/2020.
//  Copyright © 2020 ibox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface SignatureMetal : MTKView<MTKViewDelegate>

-(void)update;
-(void)updateWithOrientation:(BOOL)update;
-(BOOL)isEmpty;
-(NSData *)byteArray;
-(void)clear;

@end

