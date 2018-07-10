//
//  JiaoYiMoneyView.m
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JiaoYiMoneyView.h"
#import "BaseTextField.h"

@interface JiaoYiMoneyView ()<UITextFieldDelegate>
//{
//    UITextField *text;
//}
@property (nonatomic, strong) UILabel *tipTitleLab;
@property (nonatomic, strong) UILabel *jiaoyiMoneyLab;
@property (nonatomic, strong) NSMutableArray *labArr;
@property (nonatomic, strong) NSMutableArray *charArr;
@property (nonatomic, strong) UITextField *text;
@end

@implementation JiaoYiMoneyView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, K_WIDTH, K_HEIGHT);
        UIView *shadeView = [UIView new];
        shadeView.backgroundColor = [UIColor titleColor];
        shadeView.alpha = 0.5f;
        [self addSubview:shadeView];
        [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *tipView = [UIView new];
        tipView.backgroundColor = [UIColor whiteColor];
        tipView.layer.cornerRadius = 8;
        [self addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(250), ChangedHeight(135)));
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(ChangedHeight(140));
        }];
        
        UIButton *cancel = [UIButton new];
        [cancel setImage:[UIImage imageNamed:@"红包关闭按钮"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(hidenAlertType) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipView.mas_right);
            make.bottom.equalTo(tipView.mas_top);
            make.size.mas_equalTo(CGSizeMake(ChangedHeight(25), ChangedHeight(25)));
        }];
        
        self.tipTitleLab = [UILabel new];
        self.tipTitleLab.textAlignment = NSTextAlignmentCenter;
        self.tipTitleLab.font = [UIFont gs_fontNum:14];
        self.tipTitleLab.textColor = [UIColor titleColor];
        [tipView addSubview:self.tipTitleLab];
        [self.tipTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipView).offset(ChangedHeight(15));
            make.left.right.equalTo(tipView);
        }];
        
        self.jiaoyiMoneyLab = [UILabel new];
        self.jiaoyiMoneyLab.textAlignment = NSTextAlignmentCenter;
        self.jiaoyiMoneyLab.font = [UIFont gs_fontNum:14];
        self.jiaoyiMoneyLab.textColor = [UIColor getOrangeColor];
        [tipView addSubview:self.jiaoyiMoneyLab];
        [self.jiaoyiMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipTitleLab.mas_bottom).offset(ChangedHeight(15));
            make.left.right.equalTo(tipView);
        }];
        
        _text = [[BaseTextField alloc]init];
        _text.keyboardType = UIKeyboardTypeNumberPad;
        _text.textColor = [UIColor clearColor];
        _text.font = [UIFont systemFontOfSize:1];
        _text.tintColor = [UIColor clearColor];
        _text.delegate = self;
        [self addSubview:_text];
        [_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tipView.mas_bottom).offset(ChangedHeight(- 20));
            make.centerX.equalTo(tipView);
            make.width.mas_equalTo(ChangedHeight(200));
            make.height.mas_equalTo(ChangedHeight(25));
        }];
        
        
        self.labArr = [[NSMutableArray alloc]init];
        UILabel *last = nil;
        for (int i = 0; i < 6; i ++) {
            UILabel *lab = [UILabel new];
            lab.layer.borderWidth = 1;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.layer.borderColor = [UIColor newSeparatorColor].CGColor;
            lab.layer.cornerRadius = 3;
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_text);
                if (!last) {
                    make.left.equalTo(_text);
                }else{
                    make.left.equalTo(last.mas_right).offset(ChangedHeight(10));
                    make.width.equalTo(last);
                }
                if (i == 5) {
                    make.right.equalTo(_text);
                }
            }];
            last = lab;
            [self.labArr addObject:lab];
        }
        
        self.charArr = [NSMutableArray array];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
        [self.charArr removeLastObject];
        UILabel *lab = self.labArr[self.charArr.count];
        lab.text = @"";
    }else if(self.charArr.count < 6){
        [self.charArr addObject:string];
        UILabel *lab = self.labArr[range.location];
        lab.text = @"●";
        if (self.charArr.count == 6) {
//            [self clearText];
            [_text resignFirstResponder];
            if (_inputPassEndBlock) {
                _inputPassEndBlock([NSString stringWithFormat:@"%@%@%@%@%@%@",self.charArr[0],self.charArr[1],self.charArr[2],self.charArr[3],self.charArr[4],self.charArr[5]]);
            }
        }
        return YES;
    }else
        return NO;
    
    return YES;
}

/**
 <#Description#>
 */
- (void)showAlertType{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.hidden = NO;
    [_text becomeFirstResponder];
    
}

/**
 <#Description#>
 */
- (void)hidenAlertType{
    [_text resignFirstResponder];
    [self clearText];
//    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)clearText{
    _text.text = @"";
    [self.charArr removeAllObjects];
    [self.labArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = obj;
        lab.text = @"";
    }];
}
- (void)setMoneyStr:(NSString *)moneyStr{
    _moneyStr = moneyStr;
    self.jiaoyiMoneyLab.text = [NSString stringWithFormat:@"¥ %@",_moneyStr];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.tipTitleLab.text = _titleStr;
}
@end
