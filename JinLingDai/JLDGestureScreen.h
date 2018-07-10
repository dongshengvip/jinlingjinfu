//
//  JLDGestureScreen.h
//  JinLingDai
//
//  Created by 001 on 2017/7/11.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JLDGestureScreen;
@protocol JLDGestureScreenDelegate <NSObject>

- (void)screen:(JLDGestureScreen *)screen didSetup:(NSString *)psw;
@end
@interface JLDGestureScreen : NSObject

+ (instancetype)shared;
- (void)show;
- (void)dismiss;
@end
