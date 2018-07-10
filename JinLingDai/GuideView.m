//
//  GuideView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView

+ (instancetype)share{
    static dispatch_once_t once;
    static GuideView *leadViewShared;
    dispatch_once(&once, ^{
        leadViewShared = [[self alloc] init];
    });
    return leadViewShared;
}

- (instancetype)init{
    if (self = [super init]) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.backgroundColor = [UIColor blueColor];
        UIButton *tiYanBtn = [UIButton new];
        [tiYanBtn addTarget:self action:@selector(hidenGuidView) forControlEvents:UIControlEventTouchUpInside];

        UIView *lastView = nil;
        for (NSInteger i = 1; i < 4; i ++) {
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide-%@",@(i)]]];
            img.userInteractionEnabled = YES;
            [self addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(K_WIDTH, K_HEIGHT));
                if (i == 1) {
                    make.left.equalTo(self);
                }else{
                    make.left.equalTo(lastView.mas_right);
                }
                
                if (i == 3) {
                    make.right.equalTo(self);
                }
            }];
            lastView = img;
            
            if (i == 3) {
                [img addSubview:tiYanBtn];
                [tiYanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(img);
                    make.size.mas_equalTo(CGSizeMake(ChangedHeight(130), ChangedHeight(35)));
                    make.bottom.equalTo(img).offset(ChangedHeight(- 70));
                }];
            }
        }
    }
    return self;
    
}


- (void)hidenGuidView{
    if (_overGuidViewBlock) {
        _overGuidViewBlock();
    }
}
@end
