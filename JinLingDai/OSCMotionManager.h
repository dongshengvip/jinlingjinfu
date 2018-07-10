//
//  OSCMotionManager.h
//  iosapp
//
//  Created by Graphic-one on 16/10/18.
//  Copyright © 2016年 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>
//获取
@class CMMotionManager;
@interface OSCMotionManager : NSObject

+ (OSCMotionManager* )shareMotionManager;
@property (nonatomic, assign) BOOL canShake;
@property (nonatomic, assign) BOOL isShaking;

- (UIImage *)createCurrentImage;
@end
