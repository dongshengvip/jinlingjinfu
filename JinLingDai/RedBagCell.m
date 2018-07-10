//
//  RedBagCell.m
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RedBagCell.h"
#import "JiangLiModel.h"
#import "UseableRedbagModel.h"
#import "NSString+formatFloat.h"
@interface RedBagCell ()
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *selectedRedBag;
@property (nonatomic, strong) UIView *lastSelectView;
@end

@implementation RedBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.scroll = [[UIScrollView alloc] init];
        [self.contentView addSubview:self.scroll];
        [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.selectedRedBag = [[NSMutableArray alloc]init];
    }
    return  self;
}

- (void)setContenView:(NSArray *)redBags click:(BOOL)canClick{
    [self.selectedRedBag removeAllObjects];
    [self.scroll.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!canClick) {
        __block UIView *last = nil;
        [redBags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RedBagModel *model = obj;
//            NSString *imgStr = model.st
            UIImageView *redBagImg = [[UIImageView alloc]init];
            redBagImg.image = [UIImage imageNamed:[model.status integerValue] == 2?@"已过期红包":@"未用红包"];
            redBagImg.tag = idx;
            [redBagImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedToKnowDetail:)]];
            redBagImg.userInteractionEnabled = YES;
            [self.scroll addSubview:redBagImg];
            [redBagImg mas_makeConstraints:^(MASConstraintMaker *make) {
                //            make.size.mas_equalTo(CGSizeMake(ChangedHeight(85), ChangedHeight(80)));
                make.top.equalTo(self.scroll).offset(ChangedHeight(13));
                if (idx) {
                    make.left.equalTo(last.mas_right).offset(ChangedHeight(15));
                }else
                    make.left.equalTo(self.scroll).offset(ChangedHeight(15));
                if (idx == redBags.count - 1) {
                    make.right.equalTo(self.scroll).offset(ChangedHeight(- 10));
                }
            }];
            last = redBagImg;
            
            
            UILabel *moneyLab = [UILabel new];
            moneyLab.text = model.money;
            moneyLab.textColor = [model.status integerValue] == 2?[UIColor whiteColor]:[UIColor colorWithHex:0xfbf300];
            moneyLab.font = [UIFont gs_fontNum:16 weight:UIFontWeightBold];
            moneyLab.textAlignment = NSTextAlignmentCenter;
            [redBagImg addSubview:moneyLab];
            [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(redBagImg);
                make.centerY.equalTo(redBagImg);
            }];
            
            UILabel *nameLab = [UILabel new];
            nameLab.text = model.name;
            nameLab.textColor = [model.status integerValue] == 2?[UIColor whiteColor]:[UIColor colorWithHex:0xfbf300];
            nameLab.font = [UIFont gs_fontNum:8 weight:UIFontWeightBold];
            nameLab.textAlignment = NSTextAlignmentCenter;
            [redBagImg addSubview:nameLab];
            [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(redBagImg);
                make.bottom.equalTo(redBagImg).offset(ChangedHeight(-8));
            }];
            
            
            UIImageView *usedImg = [[UIImageView alloc]init];

            usedImg.image = [UIImage imageNamed:@"已使用"];
            usedImg.hidden = [model.status integerValue] != 4;
            [redBagImg addSubview:usedImg];
            [usedImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(redBagImg);
                make.bottom.equalTo(redBagImg).offset(ChangedHeight( - 10));
                make.width.equalTo(redBagImg).offset(ChangedHeight(-6));
                make.height.equalTo(usedImg.mas_width);
            }];
        }];
    }else{
        self.modelArr = [redBags copy];
        __block UIView *last = nil;
        [redBags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UseableRedbagModel *model = obj;
            UIImageView *redBagImg = [[UIImageView alloc]init];
            redBagImg.tag = idx;
            redBagImg.image = [model.reward_type integerValue] == 1 ? [UIImage imageNamed:@"勾选红包"] : [UIImage imageNamed:@"勾选加息"];
//            redBagImg.image = [UIImage imageNamed:@"勾选红包"];
            redBagImg.userInteractionEnabled = YES;
            [redBagImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedRedBag:)]];
            [self.scroll addSubview:redBagImg];
            [redBagImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scroll).offset(ChangedHeight(13));
                if (idx) {
                    make.left.equalTo(last.mas_right).offset(ChangedHeight(15));
                }else
                    make.left.equalTo(self.scroll).offset(ChangedHeight(15));
                if (idx == redBags.count - 1) {
                    make.right.equalTo(self.scroll).offset(ChangedHeight(- 10));
                }
            }];
            last = redBagImg;
            
            UILabel *moneyLab = [UILabel new];
            moneyLab.text = [model.reward_type integerValue] == 1 ? [NSString formatFloat:[model.money floatValue]]: [NSString stringWithFormat:@"%@%%",[NSString formatFloat:[model.money floatValue]]];
            moneyLab.textColor = [model.reward_type integerValue] == 1 ? [UIColor colorWithHex:0xfbf300] : [UIColor colorWithHex:0xf95348];
            moneyLab.font = [UIFont gs_fontNum:16];
            moneyLab.textAlignment = NSTextAlignmentCenter;
            [redBagImg addSubview:moneyLab];
            [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(redBagImg);
                make.centerY.equalTo(redBagImg).offset(ChangedHeight(4));
            }];
            
            UILabel *nameLab = [UILabel new];
            nameLab.text = model.name;
            nameLab.textColor = [model.reward_type integerValue] == 1 ? [UIColor colorWithHex:0xfbf300] : [UIColor colorWithHex:0xf95348];
            nameLab.font = [UIFont gs_fontNum:8];
            nameLab.textAlignment = NSTextAlignmentCenter;
            [redBagImg addSubview:nameLab];
            [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(redBagImg);
                make.bottom.equalTo(redBagImg).offset(ChangedHeight(-8));
            }];
            
            UIView *checkImgBg = [UIView new];
            checkImgBg.layer.cornerRadius = 3;
            checkImgBg.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.45];
            checkImgBg.tag = 90;
            checkImgBg.hidden = YES;
            [redBagImg addSubview:checkImgBg];
            [checkImgBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(redBagImg);
            }];
            UIImageView *checkImg = [[UIImageView alloc]init];

            checkImg.image = [UIImage imageNamed:@"红包选中"];
            [checkImgBg addSubview:checkImg];
            [checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(redBagImg);
            }];
            
            if (idx == redBags.count - 1) {
                model.isSelected = YES;
                checkImgBg.hidden = NO;
                self.lastSelectView = checkImgBg;
                [self.selectedRedBag addObject:model];
            }
        }];
    }
    
}

/**
 单选的

 @param gester 手势
 */
- (void)clickedRedBag:(UIGestureRecognizer *)gester{
    UseableRedbagModel *model = self.modelArr[gester.view.tag];

    if (model.isSelected) {//反选
        model.isSelected = NO;
        UIView *checkImg = [gester.view viewWithTag:90];
        checkImg.hidden = !model.isSelected;
        if (_redBagSlectedBlock) {
            _redBagSlectedBlock(- 1);
        }
        [self.selectedRedBag removeAllObjects];
        self.lastSelectView = nil;
    }else{
        if (self.selectedRedBag.count > 0) {
            UseableRedbagModel *model = self.selectedRedBag.firstObject;
            model.isSelected = NO;
            self.lastSelectView.hidden = YES;
            [self.selectedRedBag removeAllObjects];
        }
        
        model.isSelected = YES;
        UIView *checkImg = [gester.view viewWithTag:90];
        self.lastSelectView = checkImg;
        checkImg.hidden = !model.isSelected;
        [self.selectedRedBag addObject:model];
        if (_redBagSlectedBlock) {
            _redBagSlectedBlock(gester.view.tag);
        }
//        }
    }
    
}

/**
 非单选的

 @param gester 手势
 */
- (void)clickedToKnowDetail:(UIGestureRecognizer *)gester{
    if (_redBagSlectedBlock) {
        _redBagSlectedBlock(gester.view.tag);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation  RedBagImgModel

@end
