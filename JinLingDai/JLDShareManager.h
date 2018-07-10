//
//  JLDShareManager.h
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareModel ;
@class JLDShareManager;




@interface JLDShareManager : NSObject

+ (instancetype)shareManager;

- (void)showShareBoardWithModel:(ShareModel *)model;
- (void)hiddenShareBoard;
+ (BOOL)canShareToFriendds;
@end

#pragma mark --- OSCShareBoard



@interface JLDShareBoard : UIView

@property (strong, nonatomic)  UIView *contentView;
@property (strong, nonatomic)  UIView *bgView;

+ (instancetype)shareBoardWithModel:(ShareModel *)model;


//+ (instancetype)shareBoardWithImage:(UIImage *)image;

@end

@interface ShareModel :NSObject
typedef NS_ENUM(NSInteger,ShareType) {
    WebShareType,//网页
    TextShareType,//wenben
    ImageShareType,//图片
    VideoShareType//视频
};
@property (nonatomic, copy) NSString *title;//
@property (nonatomic, copy) NSString *href;//lianjie
@property (nonatomic, copy) NSString *descString;//jieshao
@property (nonatomic, assign) BOOL isImag;//
@property (nonatomic, strong) UIImage *logoImage;//
@property (nonatomic, strong) UIImage *shareImage;//
@property (nonatomic, strong) NSString* resourceUrl;//
@property (nonatomic, strong) NSString* videoStreamUrl;//视频流
@property (nonatomic, assign) ShareType type;
@end
