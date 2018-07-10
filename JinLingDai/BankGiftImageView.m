//
//  BankGiftImageView.m
//  JinLingDai
//
//  Created by 001 on 2017/9/14.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "BankGiftImageView.h"
#import <YYKit.h>

@interface BankGiftImageView ()

@end

@implementation BankGiftImageView

+ (instancetype)shareManage{
    static BankGiftImageView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[BankGiftImageView alloc] init];
        }
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        self.giftImage = [[UIImageView alloc] init];
        self.giftImage.animationImages = @[[UIImage imageNamed:@"gift_4"],[UIImage imageNamed:@"gift_5"],[UIImage imageNamed:@"gift_6"],[UIImage imageNamed:@"gift_7"],[UIImage imageNamed:@"gift_8"]];
        self.giftImage.animationDuration = 1.f;
        [self.giftImage startAnimating];
        [self addSubview:self.giftImage];
        [self.giftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
        }];
//        UIButton *cancel = [UIButton new];
//        [cancel setImage:[UIImage imageNamed:@"账户余额不足"] forState:UIControlStateNormal];
//        [cancel addTarget:self action:@selector(cancelActView) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancel];
//        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.top.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(ChangedHeight(20), ChangedHeight(20)));
//        }];
        self.giftImage.userInteractionEnabled = YES;
        [self.giftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankviewClicked)]];
        
        //创建一个拖动的手势
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//        [self setUserInteractionEnabled:YES];//开启图片控件的用户交互
        [self addGestureRecognizer:pan];//给图片添加手势
    }
    return self;
}
- (void)bankviewClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenBankManager object:nil];
}

- (void)cancelActView{
    self.hidden = YES;
}

#pragma mark - 手势执行的方法
-(void)handlePan:(UIPanGestureRecognizer *)rec{
    
    
    switch (rec.state) {
         case UIGestureRecognizerStateBegan:
         case UIGestureRecognizerStateChanged:
        {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
            
            //返回在横坐标上、纵坐标上拖动了多少像素
            CGPoint point=[rec translationInView:window];
            
            CGFloat centerX = rec.view.center.x+point.x;
            CGFloat centerY = rec.view.center.y+point.y;
            
            CGFloat viewHalfH = rec.view.frame.size.height/2;
            CGFloat viewhalfW = rec.view.frame.size.width/2;
            
            //确定特殊的centerY
            if (centerY - viewHalfH < 0 ) {
                centerY = viewHalfH;
            }
            if (centerY + viewHalfH > KHeight ) {
                centerY = KHeight - viewHalfH;
            }
            
            //确定特殊的centerX
            if (centerX - viewhalfW < 0){
                centerX = viewhalfW;
            }
            if (centerX + viewhalfW > KWidth){
                centerX = KWidth - viewhalfW;
            }
            
            rec.view.center=CGPointMake(centerX, centerY);
            
            //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
            [rec setTranslation:CGPointMake(0, 0) inView:window];
        }
             break;

        case UIGestureRecognizerStateEnded:{
            [UIView animateWithDuration:0.4f animations:^{
                if (self.centerX <= K_WIDTH/2) {
                    self.left = 0;
                }else
                    self.right = K_WIDTH;
            }];
        }
             break;

         case UIGestureRecognizerStateCancelled:
             break;

         case UIGestureRecognizerStateFailed:
            break;
         default:
             break;
        }
    
}


@end
