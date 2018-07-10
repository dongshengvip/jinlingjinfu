//
//  RecommendCell.m
//  JinLingDai
//
//  Created by 001 on 2017/8/16.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "RecommendCell.h"
#import "TuiJianBiaoView.h"
#import <YYKit.h>
@interface RecommendCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *childVcDic;
@property (nonatomic, strong) NSArray *biaoArr;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *helpView;

@property (nonatomic, strong) UIPageControl *pageControl;


@end
@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor infosBackViewColor];
        self.scroll = [[UIScrollView alloc]init];
        self.scroll.delegate = self;
        self.scroll.pagingEnabled = YES;
        [self.contentView addSubview:self.scroll];
        [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.childVcDic = [NSMutableDictionary dictionary];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = 2;
        self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor getOrangeColor];
        [self.contentView addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(@15);
        }];
    }
    return self;
}

- (void)setListItem:(NSArray *)items{
    self.biaoArr = [items copy];
    [self.scroll removeAllSubviews];
    [self.childVcDic removeAllObjects];
    [self.scroll setContentOffset:CGPointZero];
    [self.scroll addSubview:self.helpView];
    [self.helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.height.equalTo(self.contentView);
        make.width.equalTo(self.contentView).multipliedBy(items.count * 1.0);
    }];
    if (items.count) {
        TuiJianBiaoView *biaoView = [TuiJianBiaoView new];
        biaoView.biaoClickedBlock = ^(NSString *BorrowId) {
            if (_GoToBorrowBlock) {
                _GoToBorrowBlock(BorrowId);
            }
        };
        [self.scroll addSubview:biaoView];
        [biaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView);
            make.left.top.bottom.equalTo(self.helpView);
        }];
        [biaoView setBiaoContenView:items.firstObject];
        [self.childVcDic setValue:biaoView forKey:@"0"];
    }

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger idex = (NSInteger)scrollView.contentOffset.x/K_WIDTH;
    self.pageControl.currentPage = idex;
    if (self.childVcDic[[NSString stringWithFormat:@"%@",@(idex)]]) {
        return;
    }
    TuiJianBiaoView *biaoView = [[TuiJianBiaoView alloc]init];
    biaoView.biaoClickedBlock = ^(NSString *BorrowId) {
        if (_GoToBorrowBlock) {
            _GoToBorrowBlock(BorrowId);
        }
    };
    [self.scroll addSubview:biaoView];
    [biaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.helpView);
        make.width.equalTo(self.contentView);
        if (idex == self.biaoArr.count - 1) {
            make.right.equalTo(self.helpView);
        }else{
            make.left.equalTo(self.helpView).offset(K_WIDTH * idex);
        }
    }];
    [biaoView setBiaoContenView:self.biaoArr[idex]];
    [self.childVcDic setValue:biaoView forKey:[NSString stringWithFormat:@"%@",@(idex)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (UIView *)helpView {
   if (!_helpView) {
       _helpView = [UIView new];
       _helpView.backgroundColor = [UIColor clearColor];
   }
   return _helpView;
}


@end
