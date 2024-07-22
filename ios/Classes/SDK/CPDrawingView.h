//
//  CGDrawingView.h
//  iboxApp
//
//  Created by Oleg on 26.04.13.
//  Copyright (c) 2013 ibox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDrawingView : UIImageView
{
    CGPoint mPrevPoint;
}

@property (nonatomic) CGPoint location;

- (NSData *)getByteArray;
- (void)clear;

@end
