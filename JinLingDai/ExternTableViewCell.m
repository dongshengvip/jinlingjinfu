//
//  ExternTableViewCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/7.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ExternTableViewCell.h"
#import <YYKit.h>
#import "UIView+Masonry.h"
#import "NSDate+Formatter.h"
@interface ExternTableViewCell ()

@property (strong, nonatomic)  UIView *InnerView;
//展示的三模块
@property (strong, nonatomic)  UIView *mainView;
@property (strong, nonatomic)  UIView *secondView;
@property (strong, nonatomic)  UIView *ThirdView;
@property (strong, nonatomic)  UIView *lineView;

@property (nonatomic, assign) BOOL hasShow;
//内容的控件

@property (nonatomic, strong) UIImageView *arrowImg;

@property (nonatomic, strong) UILabel *firstLabInThirdView;
@property (nonatomic, strong) UILabel *secondLabInThirdView;
@property (nonatomic, strong) UILabel *thirdLabInThirdView;
@end


@implementation ExternTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.InnerView = [UIView new];
        [self.contentView addSubview:self.InnerView];
        [self.InnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self setUI];
        
    }
    
    return self;
}

#pragma mark - UI

- (UIView *)mainView{
    
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor whiteColor];
        
        //
        self.titleLab = [UILabel new];
        self.titleLab.font = [UIFont gs_fontNum:14];
        self.titleLab.textColor = [UIColor titleColor];
        [_mainView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_mainView);
            make.left.equalTo(_mainView).offset(ChangedHeight(10));
        }];
        
//        UIButton *btn = [UIButton new];
//        [btn addTarget:self action:@selector(changedFooterType:) forControlEvents:UIControlEventTouchUpInside];
//        [_mainView addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.right.equalTo(_mainView);
//            make.width.mas_equalTo(ChangedHeight(35));
//        }];
        
        [_mainView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changedFooterType:)]];
        self.arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下划箭头"]];
        [_mainView addSubview:self.arrowImg];
        [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_mainView);
            make.right.equalTo(_mainView).offset(ChangedHeight(- 15));
//            make.width.height.mas_equalTo(ChangedHeight(12));
        }];
        
    }
    return _mainView;
}

/**
 修改footer是否展示

 @param sender 按钮
 */
- (void)changedFooterType:(UITapGestureRecognizer *)sender{
    self.hasShow = !self.hasShow;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.hasShow) {
            self.arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
        }else
            self.arrowImg.transform = CGAffineTransformMakeRotation(0);
        
    }];
    
    if (_footerhidenChangedBlock) {
        _footerhidenChangedBlock(self.hasShow);
    }
}

- (UIView *)secondView{
    if (!_secondView) {
        _secondView = [UIView new];
        _secondView.backgroundColor = [UIColor infosBackViewColor];
        
        UIView *verLine1 = [UIView new];
        verLine1.backgroundColor = [UIColor newSeparatorColor];
        [self.secondView addSubview:verLine1];
        [verLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.secondView);
            make.width.mas_equalTo(1);
        }];
        
        UIView *verLine2 = [UIView new];
        verLine2.backgroundColor = [UIColor newSeparatorColor];
        [self.secondView addSubview:verLine2];
        [verLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.secondView);
            make.width.mas_equalTo(1);
        }];
        
        [_secondView distributeSpacingHorizontallyWith:@[verLine1,verLine2]];
        
        self.firstLabInSecondView = [UILabel new];
        [_secondView addSubview:self.firstLabInSecondView];
        [self.firstLabInSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_secondView);
            make.right.equalTo(verLine1.mas_left);
        }];
        
        self.secondLabInSecondView = [UILabel new];
        [_secondView addSubview:self.secondLabInSecondView];
        [self.secondLabInSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(verLine1);
            make.right.equalTo(verLine2.mas_left);
            make.left.equalTo(verLine1.mas_right);
        }];
        
        self.thirdLabInSecondView = [UILabel new];
        [_secondView addSubview:self.thirdLabInSecondView];
        [self.thirdLabInSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_secondView);
            make.left.equalTo(verLine2.mas_right);
        }];
        self.firstLabInSecondView.numberOfLines = self.secondLabInSecondView.numberOfLines = self.thirdLabInSecondView.numberOfLines = 2;
    }
    
    return _secondView;
}

- (UIView *)ThirdView{
    if (!_ThirdView) {
        _ThirdView = [UIView new];
        _ThirdView.backgroundColor = [UIColor infosBackViewColor];
        UIView *verLine1 = [UIView new];
        verLine1.backgroundColor = [UIColor newSeparatorColor];
        [_ThirdView addSubview:verLine1];
        [verLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_ThirdView);
            make.width.mas_equalTo(1);
        }];
        
        UIView *verLine2 = [UIView new];
        verLine2.backgroundColor = [UIColor newSeparatorColor];
        [_ThirdView addSubview:verLine2];
        [verLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_ThirdView);
            make.width.mas_equalTo(1);
        }];
        
        [_ThirdView distributeSpacingHorizontallyWith:@[verLine1,verLine2]];
        
        
        self.firstLabInThirdView = [UILabel new];
        [_ThirdView addSubview:self.firstLabInThirdView];
        [self.firstLabInThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_ThirdView);
            make.right.equalTo(verLine1.mas_left);
        }];
        
        self.secondLabInThirdView = [UILabel new];
        [_ThirdView addSubview:self.secondLabInThirdView];
        [self.secondLabInThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(verLine1);
            make.right.equalTo(verLine2.mas_left);
            make.left.equalTo(verLine1.mas_right);
        }];
        
        self.thirdLabInThirdView = [UILabel new];
        [_ThirdView addSubview:self.thirdLabInThirdView];
        [self.thirdLabInThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_ThirdView);
            make.left.equalTo(verLine2.mas_right);
        }];
        self.firstLabInThirdView.numberOfLines = self.secondLabInThirdView.numberOfLines = self.thirdLabInThirdView.numberOfLines = 2;
    }
    return _ThirdView;
}

-(void)setUI{
    
    [self.contentView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(ChangedHeight(45));
    }];
    
 
    
    [self.contentView addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mainView);
        make.top.equalTo(self.mainView.mas_bottom);
        make.height.mas_equalTo(ChangedHeight(70));
    }];
    
    
    
    [self.contentView addSubview:self.ThirdView];
    [self.ThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mainView);
        make.top.equalTo(self.secondView.mas_bottom);
        make.height.mas_equalTo(ChangedHeight(70));
    }];
  
    [self.contentView bringSubviewToFront:self.mainView];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor newSeparatorColor];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.InnerView);
        make.centerY.equalTo(self.secondView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.contentView bringSubviewToFront:self.lineView];
    
    [self hiddenFooterViews:2];
    
    [self.secondView.superview layoutIfNeeded];
}


-(void)hiddenFooterViews:(NSInteger)num{
    self.secondView.hidden = YES;
    self.ThirdView.hidden = YES;
    self.lineView.hidden = YES;
    
}

-(void)showFooterViews:(NSInteger)num{
    self.secondView.hidden = NO;
    if (num > 1) {
        self.ThirdView.hidden = NO;
        self.lineView.hidden = NO;
    }
    
}

- (void)setContenView:(TouZiModel *)item{
    self.titleLab.text = @"出借详情";
    self.firstLabInSecondView.attributedText = [self getAttributeString:[NSString stringWithFormat:@"年化借款利率\n%@%%",item.borrow_interest_rate]];
    self.secondLabInSecondView.attributedText = [self getAttributeString:[NSString stringWithFormat:@"出借金额\n%@元",item.investor_capital]];
    NSString *dayStr = [item.duration_unit integerValue] == 0 ? @"天" : @"月";
    self.thirdLabInSecondView.attributedText = [self getAttributeString:[NSString stringWithFormat:@"项目期限\n%@%@",item.investor_duration,dayStr]];
    if ([item.expired_time longLongValue] == 0) {
        self.firstLabInThirdView.attributedText = [self getAttributeString:@"结束日期\n未定"];
    }else{
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item.expired_time longLongValue]];
        NSString *dateStr = [NSString stringWithFormat:@"%@",[date dateWithFormat:@"yyyy-MM-dd"]];
        self.firstLabInThirdView.attributedText = [self getAttributeString:[NSString stringWithFormat:@"结束日期\n%@",dateStr]];
    }
    
    NSString *tipStr = Nilstr2Space(item.reward).length ? [NSString stringWithFormat:@"使用优惠\n%@",Nilstr2Space(item.reward)] : @"未使用优惠";
    self.secondLabInThirdView.attributedText = [self getAttributeString:tipStr];
    self.thirdLabInThirdView.attributedText = [self getAttributeString:[NSString stringWithFormat:@"预期收入\n%@元",[NSString stringWithFormat:@"%.2f",[item.all_income floatValue]]]];
}

- (NSAttributedString *)getAttributeString:(NSString *)str{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 7;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor newSecondTextColor] range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:14] range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, str.length)];
    return attr;

}

-(void)showListwithTime:(NSArray*)times{
    
    /*rotationX
     *
     *第一次动画
     *
     */
    UIView *tmpView = [[UIView alloc]init];
    tmpView.frame = self.secondView.frame;
    tmpView.bottom = self.secondView.top;
    tmpView.backgroundColor = self.secondView.backgroundColor;
    [self.InnerView addSubview:tmpView];
    
    [UIView animateWithDuration:[times[0] floatValue] animations:^{
        tmpView.bottom = self.secondView.bottom;
        
    }completion:^(BOOL finished) {
        
        [tmpView removeFromSuperview];
        
        self.secondView.hidden = NO;
        if (times.count > 1) {
            /*
             *
             *第二次动画
             *
             */
            UIView *tmpView = [[UIView alloc]init];
            tmpView.frame = self.ThirdView.frame;
            tmpView.bottom = self.ThirdView.top;
            tmpView.backgroundColor = self.ThirdView.backgroundColor;
            [self.InnerView addSubview:tmpView];
            
            [UIView animateWithDuration:[times[1] floatValue] animations:^{
                tmpView.bottom = self.ThirdView.bottom;
            }completion:^(BOOL finished) {
                [tmpView removeFromSuperview];
                self.ThirdView.hidden = NO;
                self.lineView.hidden = NO;
            }];
        }
    }];
    
    
    
}

- (void)hidenListwithTime:(NSArray *)times{
    /*rotationX
     *
     *第1次动画
     *
     */
    __block UIView *tmpView = [[UIView alloc]init];
    tmpView.frame = times.count >1?self.ThirdView.frame:self.secondView.frame;
//    tmpView.bottom = self.secondView.top;
//    tmpView.backgroundColor = self.ThirdView.backgroundColor;
//    [self.InnerView addSubview:tmpView];
    if (times.count > 1) {
        self.lineView.hidden = YES;
        self.ThirdView.hidden = YES;
    }else{
        self.secondView.hidden = YES;
    }
    [UIView animateWithDuration:[times[0] floatValue] animations:^{
        if (times.count > 1) {
            self.ThirdView.bottom = tmpView.top;
        }else{
            self.secondView.bottom = tmpView.top;
        }
    }completion:^(BOOL finished) {
        if (times.count > 1) {
        self.ThirdView.bottom = tmpView.bottom;
            /*
             第二次动画
             */
            self.secondView.hidden = YES;
            tmpView.frame = self.secondView.frame;
            
            [UIView animateWithDuration:[times[1] floatValue] animations:^{
                self.secondView.bottom = tmpView.top;
            }completion:^(BOOL finished) {
                
                self.secondView.bottom = tmpView.bottom;
                tmpView = nil;
            }];
        }else{
            
            self.secondView.bottom = tmpView.bottom;
            tmpView = nil;
        }
    }];
}

#pragma mark - anchor point

-(void)prepareAnimation:(UIView*)targetView{
    //设置锚点，实现围绕上边界旋转
    [self setAnchorPointTo:CGPointMake(0.5, 0) view:targetView];
    
    //给containView添加偏移
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    self.InnerView.layer.sublayerTransform = transfrom3d;
}

-(void)setShadow:(UIView*)targetView{
    //阴影
    targetView.layer.shadowOpacity = 1.0;// 阴影透明度
    targetView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    targetView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    targetView.layer.shadowOffset  = CGSizeMake(3, 3);// 阴影的范围
}


- (void)setAnchorPointTo:(CGPoint)point view:(UIView*)view{
    
    /*
     
     CGRect frame = view.frame;
     frame.origin.x+=(point.x - view.layer.anchorPoint.x) * view.frame.size.width;
     frame.origin.y+=(point.y - view.layer.anchorPoint.y) * view.frame.size.height;
     view.frame = frame;
     view.layer.anchorPoint = point;
     
     */
    //和上面注销掉的代码一个意思
    view.frame = CGRectOffset(view.frame, (point.x - view.layer.anchorPoint.x) * view.frame.size.width, (point.y - view.layer.anchorPoint.y) * view.frame.size.height);
    view.layer.anchorPoint = point;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
