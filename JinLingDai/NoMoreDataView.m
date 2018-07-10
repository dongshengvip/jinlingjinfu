//
//  NoMoreDataView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "NoMoreDataView.h"
#import "UIColor+Util.h"
#import <Masonry.h>
#import <YYKit.h>
@interface NoMoreDataView ()
@property (nonatomic, strong) UILabel *noMoreLab;
@end
@implementation NoMoreDataView

- (instancetype)init{
    if (self = [super init]) {
        self.height = ChangedHeight(70);
        self.noMoreLab = [UILabel new];
        self.noMoreLab.font = [UIFont gs_fontNum:12];
        self.noMoreLab.textColor = [UIColor borderColor];
        self.noMoreLab.textAlignment = NSTextAlignmentCenter;
        self.noMoreLab.text = @"没有更多的系统通知啦～";
        [self addSubview:self.noMoreLab];
        [self.noMoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(ChangedHeight(-20));
            
        }];
    }
    return self;
}
- (void)setTipText:(NSString *)text{
    self.noMoreLab.text = text;
}

@end
