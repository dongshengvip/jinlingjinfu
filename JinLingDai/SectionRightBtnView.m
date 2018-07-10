//
//  SectionRightBtnView.m
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "SectionRightBtnView.h"
#import <Masonry.h>

@implementation SectionRightBtnView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLab = [UILabel new];
        self.titleLab.font = [UIFont gs_fontNum:12];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ChangedHeight(10));
            make.centerY.equalTo(self.contentView);
            
        }];
        
        self.rightBtn = [UIButton new];
    
        [self.contentView addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ChangedHeight(-10));
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(self.contentView).offset(ChangedHeight(-15));
            make.width.equalTo(self.rightBtn.mas_height).dividedBy(0.5);
        }];
        [self.rightBtn addTarget:self action:@selector(rightbtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)rightbtnClicked{
    if (_robBuyBtnClick) {
        _robBuyBtnClick();
    }
}
@end
