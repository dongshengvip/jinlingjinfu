//
//  UpAndDownButton.m
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "UpAndDownButton.h"
#import <Masonry.h>

@implementation UpAndDownButton


- (instancetype)init{
    if (self = [super init]) {
        [self setIconAndTitle];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setIconAndTitle];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    self.titleLab.text = title;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    self.titleLab.textColor = color;
}

- (void)setIconAndTitle{
    self.icon = [[UIImageView alloc]init];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
//        make.width.height.equalTo(self).dividedBy(2.0);
        make.top.equalTo(self).offset(ChangedHeight(8));
    }];
    
    self.titleLab = [UILabel new];
    self.titleLab.font = [UIFont gs_fontNum:13];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor blackColor];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).offset(ChangedHeight(10));
//        make.bottom.equalTo(self).offset(-ChangedHeight(5));
    }];
}

@end
