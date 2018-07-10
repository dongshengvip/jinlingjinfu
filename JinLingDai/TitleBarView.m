//
//  TitleBarView.m
//  框架整理demo
//
//  Created by 1 on 2017/1/6.
//  Copyright © 2017年 HDS. All rights reserved.
//

#import "TitleBarView.h"
#import "UIColor+Util.h"
#import "UpAndDownButton.h"
#import <YYKit.h>
#define kMaxBtnWidth 80
@interface TitleBarView ()

@property (nonatomic,strong) UIView *helperView;//标记点击的按钮
@end
@implementation TitleBarView

-(instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andNeedScroll:(BOOL)isNeedScroll{
    _isNeedScroll = isNeedScroll;
    return [self initWithFrame:frame andTitles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    
    if (self) {

        [self reloadAllButtonsOfTitleBarWithTitles:titles];
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
/**重置所有的btn*/
-(void)reloadAllButtonsOfTitleBarWithTitles:(NSArray *)titles{
    self.backgroundColor = [UIColor infosBackViewColor];
    for (UIButton *btn in _titleButtons) {
        [btn removeFromSuperview];
    }
    [_helperView removeFromSuperview];
    _currentIndex = 0;
    _titleButtons = [NSMutableArray new];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
        [button setTitle:obj forState:UIControlStateNormal];
        [_titleButtons addObject:button];
    }];
    
    [self reloadBtns:_titleButtons];
    
    
}

/**重置所有的btn(上边图片下标题)*/
- (void)reloadAllUpAndDownButtonsOfTitleBarWithTitles:(NSArray *)titles{
    for (UIButton *btn in _titleButtons) {
        [btn removeFromSuperview];
    }
    [_helperView removeFromSuperview];
    _currentIndex = 0;
    _titleButtons = [NSMutableArray new];
    
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = obj;
        UpAndDownButton *button = [UpAndDownButton new];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLab.font = [UIFont systemFontOfSize:15];
        button.titleLab.text = arr[1];
        button.icon.image = [UIImage imageNamed:arr[0]];
        [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
        //        [button setTitle:obj forState:UIControlStateNormal];
        [_titleButtons addObject:button];
    }];
    
    [self reloadBtns:_titleButtons];
}

- (void)reloadBtns:(NSArray *)titles{
    CGFloat buttonWidth = self.frame.size.width / titles.count;
    CGFloat buttonHeight = self.frame.size.height - 1;
    
    _helperView = [UIView new];
    _helperView.height = 1;
    _helperView.bottom = self.height;
//    _helperView.left = 0;
    _helperView.backgroundColor = _currentCollor?_currentCollor:[UIColor getBlueColor];
    [self addSubview:_helperView];
    
    if(titles.count * kMaxBtnWidth > self.frame.size.width){
        self.contentSize = CGSizeMake(titles.count * kMaxBtnWidth, self.frame.size.height);
        buttonWidth = kMaxBtnWidth;
    }else if(_isNeedScroll){
        self.contentSize = CGSizeMake(self.frame.size.width + 1, self.frame.size.height);
        buttonWidth = kMaxBtnWidth;
    }else{
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    }
    
    _helperView.width = buttonWidth > kMaxBtnWidth ? kMaxBtnWidth:buttonWidth;
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
        button.tag = idx;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self sendSubviewToBack:button];
    }];
//    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor clearColor];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [button setTitleColor:[UIColor colorWithHex:titleColor] forState:UIControlStateNormal];
//        [button setTitle:title forState:UIControlStateNormal];
//        
//        button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
//        button.tag = idx;
//        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [_titleButtons addObject:button];
//        [self addSubview:button];
//        [self sendSubviewToBack:button];
//    }];
    
    UIButton *firstTitle = _titleButtons[0];
    [firstTitle setTitleColor:_currentCollor?_currentCollor:[UIColor getBlueColor] forState:UIControlStateNormal];
    _helperView.centerX = firstTitle.centerX;
}

/**
 设置选中颜色

 @param currentCollor 选中颜色
 */
- (void)setCurrentCollor:(UIColor *)currentCollor{
    _currentCollor = currentCollor;
    if (!_titleButtons) {
        return;
    }
    UIButton *firstTitle = _titleButtons[0];
    if (_currentIndex) {
        firstTitle = _titleButtons[_currentIndex];
    }
    
    [firstTitle setTitleColor:currentCollor?currentCollor:[UIColor getBlueColor] forState:UIControlStateNormal];
    
    _helperView.backgroundColor = currentCollor?currentCollor:[UIColor getBlueColor];
}

- (void)onClick:(UIButton *)button
{
    if (_currentIndex != button.tag) {
        [self scrollToCenterWithIndex:button.tag];
        if (_titleButtonClicked) {
            _titleButtonClicked(button.tag);
        }
        
        [UIView animateWithDuration:0.5f animations:^{
            _helperView.centerX = button.centerX;
        }];
    }
}

- (void)scrollToCenterWithIndex:(NSInteger)index{
    UIButton *preTitle = _titleButtons[_currentIndex];
    [preTitle setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    _currentIndex = index;
    UIButton *firstTitle = _titleButtons[index];
    [firstTitle setTitleColor:self.currentCollor?self.currentCollor:[UIColor getBlueColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5f animations:^{
        _helperView.centerX = firstTitle.centerX;
    }];
    
    UIButton *button = [self viewWithTag:index];
    if (self.contentSize.width > self.frame.size.width) {
        if (CGRectGetMidX(button.frame) < self.frame.size.width / 2) {
            [self setContentOffset:CGPointZero animated:YES];
        }else if (self.contentSize.width - CGRectGetMidX(button.frame) < self.frame.size.width / 2){
            [self setContentOffset:CGPointMake(self.contentSize.width - CGRectGetWidth(self.frame), 0) animated:YES];
        }else{
            CGFloat needScrollWidth = CGRectGetMidX(button.frame) - self.contentOffset.x - self.frame.size.width / 2;
            [self setContentOffset:CGPointMake(self.contentOffset.x + needScrollWidth, 0) animated:YES];
        }
    }
}

- (void)setTitleButtonsColor
{
    for (UIButton *button in self.subviews) {
        button.backgroundColor = [UIColor titleColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
