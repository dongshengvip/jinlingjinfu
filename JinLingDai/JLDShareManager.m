//
//  JLDShareManager.m
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JLDShareManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MBProgressHUD+NetWork.h"
#import "UpAndDownButton.h"

//#import "JLDGestureScreen.h"
@interface JLDShareManager ()
{
    __weak JLDShareBoard* _curShareBoard;
}
@end
#define ShareArr @[@"朋友圈", @"微信", @"QQ", @"空间"]
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SHAREBOARD_HEIGHT curShareBoard.bounds.size.height
#define SHAREBOARD_WIDTH curShareBoard.bounds.size.width
@implementation JLDShareManager

static JLDShareManager* _shareManager ;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [JLDShareManager new];
    });
    return _shareManager;
}

+ (BOOL)canShareToFriendds{
    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] || [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
}

- (void)showShareBoardWithModel:(ShareModel *)model{
    if (_curShareBoard) { _curShareBoard = nil;}
    
    JLDShareBoard *curShareBoard = [JLDShareBoard shareBoardWithModel:model];
    //    curShareBoard.isi
    _curShareBoard = curShareBoard;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:curShareBoard];
    [curShareBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    //背景蒙层的动画：alpha值从0.0变化到0.5
    [curShareBoard.bgView setAlpha:0.0];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [curShareBoard.bgView setAlpha:0.5];
    } completion:^(BOOL finished) { }];
    
    //分享面板的动画：从底部向上滚动弹出来
    [curShareBoard.contentView setFrame:CGRectMake(0, SCREEN_HEIGHT , SHAREBOARD_WIDTH, SHAREBOARD_HEIGHT )];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [curShareBoard.contentView setFrame:CGRectMake(0,SCREEN_HEIGHT - SHAREBOARD_HEIGHT,SHAREBOARD_WIDTH,SHAREBOARD_HEIGHT)];
    } completion:^(BOOL finished) {}];
}

- (void)hiddenShareBoard
{
    if (_curShareBoard.superview) {
        [_curShareBoard removeFromSuperview];
    }
}


@end


#pragma mark --- OSCShareBoard
@interface JLDShareBoard ()

//@property (nonatomic, copy) NSString *title;//
//@property (nonatomic, copy) NSString *href;//
//@property (nonatomic, copy) NSString *descString;//
//
//@property (nonatomic, strong) UIImage *logoImage;//
//@property (nonatomic, strong) NSString* resourceUrl;//

@property (nonatomic, strong) ShareModel *contenModel;
@property (nonatomic, assign) BOOL isImage;

@end

@implementation JLDShareBoard{
    BOOL _touchTrack;
}

+ (instancetype)shareBoardWithModel:(ShareModel *)model
{
    JLDShareBoard *curShareBoard = [[JLDShareBoard alloc] init];
    curShareBoard.contenModel = model;
    curShareBoard.isImage = model.isImag;
    //    [curShareBoard settingShareType:infomationType model:model];
    return curShareBoard;
}

- (instancetype)init{
    if (self = [super init]) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor blackColor];
        [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelfFromSup)]];
        self.bgView.alpha = 0.6;
        self.bgView.opaque = NO;
        [self addSubview:_bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(ChangedHeight(170));
        }];
    }
    return self;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLab = [UILabel new];
        tipLab.text = @"分享给好友";
        tipLab.textColor = [UIColor titleColor];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.font = [UIFont gs_fontNum:15];
        [_contentView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.top.equalTo(_contentView).offset(ChangedHeight(8));
            make.height.mas_equalTo(ChangedHeight(25));
        }];
        UIView *lastView = nil;
        NSInteger startNum = 0;
        NSInteger endNum = ShareArr.count;
        if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            startNum = 2;
        }
        if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
            endNum = ShareArr.count - 2;
        }
        for (NSInteger i = startNum; i < endNum; i ++) {
            
            UpAndDownButton *btn = [UpAndDownButton new];
            btn.icon.image = [UIImage imageNamed:ShareArr[i]];
            btn.tag = i + 1;
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLab.text = ShareArr[i];
            [_contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tipLab.mas_bottom);
                make.bottom.equalTo(_contentView).offset(ChangedHeight(- 50));
                make.width.equalTo(_contentView).dividedBy(ShareArr.count * 1.0);
                if (i == startNum) {
                    make.left.equalTo(_contentView);
                }else{
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(lastView);
                }
                
            }];
            lastView = btn;
            
        }
        UIButton *cancelBtn = [UIButton new];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_contentView);
            make.height.mas_equalTo(ChangedHeight(40));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor newSeparatorColor];
        [_contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.bottom.equalTo(cancelBtn.mas_top);
            make.height.mas_equalTo(1);
        }];
        
    }
    return _contentView;
}
- (void)cancleAction:(id)sender {
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (void)removeSelfFromSup{
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (void)buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    UIViewController* curViewController = [self topViewControllerForViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    
    switch (button.tag) {
            
        case 1: //Wechat Timeline
        {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        
        break;
        }
        case 2: //WechatSession
        {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        
        break;
        }
        case 3: //qq
        {
        
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        
        
        break;
        }
        case 4: //brower
        {
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        
        break;
        
        break;
        }
        case 6: //copy url
        {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@", self.contenModel.href];
        MBProgressHUD *HUD = [MBProgressHUD createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.label.text = @"已复制到剪切板";
        if (self.superview) {
            [self removeFromSuperview];
        }
        [HUD hideAnimated:YES afterDelay:1];
        
        break;
        }
        case 7:  //more
        {
        if (self.superview) {
            [self removeFromSuperview];
        }
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSString stringWithFormat:@"%@ %@",self.contenModel.title,self.contenModel.href]] applicationActivities:nil];
        if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
            activityViewController.popoverPresentationController.sourceView = self;
        }
        
        [curViewController presentViewController:activityViewController animated:YES completion:nil];
        
        break;
        }
            
        default:
            break;
    }
}

- (UIViewController *)topViewControllerForViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerForViewController:navigationController.visibleViewController];
    }
    
    if (rootViewController.presentedViewController) {
        return [self topViewControllerForViewController:rootViewController.presentedViewController];
    }
    
    return rootViewController;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [self setMessagesShareObject];
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        [self cancelGesterView];
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            [MBProgressHUD showSuccess:@"分享成功"];
        }
        
        //        [self alertWithError:error];
    }];
}

- (UMSocialMessageObject *)setMessagesShareObject{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    switch (self.contenModel.type) {
        case TextShareType:
        {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = self.contenModel.descString;
        }
            break;
            
        case ImageShareType:
        {
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = self.contenModel.logoImage;
        [shareObject setShareImage:self.contenModel.shareImage];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        }
            break;
        case WebShareType:
        {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.contenModel.title descr:self.contenModel.descString thumImage:self.contenModel.logoImage];
        //设置网页地址
        shareObject.webpageUrl = self.contenModel.href;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        }
            break;
            
        default:{//video
            //创建视频内容对象
            UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:self.contenModel.title descr:self.contenModel.descString thumImage:self.contenModel.logoImage];
            if (self.contenModel.videoStreamUrl) {
                //             @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
                shareObject.videoStreamUrl = self.contenModel.videoStreamUrl;
                shareObject.videoUrl = self.contenModel.videoStreamUrl;
            }else{
                //设置视频网页播放地址
                shareObject.videoUrl = self.contenModel.href;
            }
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
        }
            break;
    }
    return messageObject;
}
- (void)cancelGesterView{
    [self removeSelfFromSup];
    //    [[JLDGestureScreen shared] dismiss];
}
@end

@implementation ShareModel



@end
