//
//  ASPageView.m
//  gosheng3.0
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ADVPageView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "NSMutableAttributedString+contentText.h"

@interface ADVPageView ()
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *tipView;//提示
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *images;
//图片items (NSString)
@property (nonatomic, strong) NSArray *items;
//自动翻页的时间 (0 表示不翻页)
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic) NSInteger currentPage;
@end

@implementation ADVPageView

- (id)init{
    if(self = [super init]){
        self.contentView = [[UIScrollView alloc] init];
        self.contentView.delegate = self;
        self.contentView.pagingEnabled = YES;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.bounces = NO;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _tipView = [UIView new];
        _tipView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.6];
        _tipView.opaque = NO;
        
        [self addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@25);
        }];
        
        
        UILabel *titleLab = [UILabel new];
        titleLab.font = [UIFont gs_fontNum:11];
        [_tipView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipView);
            make.left.equalTo(_tipView).offset(ChangedHeight(10));
            make.right.equalTo(_tipView.mas_centerX).offset(ChangedHeight(-5));
        }];
        UILabel *titleLab2 = [UILabel new];
        titleLab2.font = [UIFont gs_fontNum:11];
        [_tipView addSubview:titleLab2];
        [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipView);
            make.left.equalTo(_tipView.mas_centerX).offset(ChangedHeight(5));
            make.right.equalTo(_tipView).offset(ChangedHeight(-15));
        }];
        self.pageControl = [[UIPageControl alloc] init];
//        self.pageControl.pageIndicatorTintColor = GS_COLOR_GRAY;
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.bottom.equalTo(_tipView.mas_top);
            make.height.mas_equalTo(@15);
        }];
        
        self.images = [NSMutableArray array];
        _currentPage = 1;
    }
    return self;
}

- (void)setItems:(NSArray *)items andTimeInterval:(NSTimeInterval)interval{
    [self clearTimer];
    _interval = interval;
    if([items count] <= 1){
        _items = [items copy];
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:items];
        [arr addObject:[items firstObject]];
        [arr insertObject:[items lastObject] atIndex:0];
        _items = [arr copy];
    }
    _tipView.hidden = !_hasTip;
    [self refresh];
}

- (void)refresh{
    [[self.contentView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
   
    UIImageView *lastView = nil;
    for(int i = 0; i < [self.items count]; i++){
        UIImageView *iv = [[UIImageView alloc] init];
        iv.userInteractionEnabled = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.backgroundColor = [UIColor clearColor];//设置了背景颜色
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_Image:)];
        [iv addGestureRecognizer:tap];
        iv.tag = i;
        if ([self.items[i] hasPrefix:@"http"]) {
            
            [iv sd_setImageWithURL:[NSURL URLWithString:self.items[i]] placeholderImage:KDefaultImg options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }else{
            iv.image = KDefaultImg;
        }
        
        [self.contentView addSubview:iv];
        //
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            if(lastView){
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.equalTo(self.contentView);
            }
            if(i == [self.items count] - 1){
                make.right.equalTo(self.contentView);
            }
        }];
        
        lastView = iv;
    }
    if([self.items count] <= 3){
        self.pageControl.hidden = YES;
        self.contentView.scrollEnabled = NO;
    }else{
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = [self.items count] - 2;
        self.contentView.scrollEnabled = YES;
    }
    if([self.items  count] <= 3){
        [self.contentView setContentOffset:CGPointZero];
    }else{
        [self.contentView setContentOffset:CGPointMake(CGRectGetWidth(self.contentView.bounds), 0)];
    }
    if([self.items count] >= 3
       && self.interval > 0){
        [self clearTimer];
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
//    if (!_tipView.hidden) {
//        [self reloadText];
//    }
}

- (void)tap_Image:(UITapGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag - 1;
    if (self.items.count == 1) {
        tag = sender.view.tag;
    }
    
    if(tag >= 0 && tag < [self.items count] - 2){
        if([self.delegate respondsToSelector:@selector(pageView:didSelected:)]){
            [self.delegate pageView:self didSelected:tag];
        }
    }
}

- (void)clearTimer{
    if(self.scrollTimer){
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)nextPage{
    self.currentPage++;
}

//- (void)reloadText{
//    
//}

- (void)setTotalLab:(NSString *)totalText interest:(NSString *)interest{
    UILabel *lab = (UILabel *)[_tipView subviews].firstObject;
//    [totalText doubleValue]
    lab.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"交易总额：%.f元",[totalText doubleValue]] Font:[UIFont gs_fontNum:11] Color:[UIColor getOrangeColor] grayText:[NSString stringWithFormat:@"%.f",[totalText doubleValue]] TextAligment:NSTextAlignmentLeft LineSpace:1.f];
    UILabel *lab2 = (UILabel *)[_tipView subviews].lastObject;
    lab2.attributedText = [NSMutableAttributedString getAttributedString:[NSString stringWithFormat:@"为用户赚取：%.f元",[interest doubleValue]] Font:[UIFont gs_fontNum:11] Color:[UIColor getOrangeColor] grayText:[NSString stringWithFormat:@"%.f",[interest doubleValue]] TextAligment:NSTextAlignmentRight LineSpace:1.f];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [self.contentView setContentOffset:CGPointMake(CGRectGetWidth(self.contentView.bounds) * currentPage, 0) animated:YES];
    if(currentPage == 0){
        currentPage = [self.items count] - 2;
    }else if(currentPage == [self.items count] - 1){
        currentPage = 1;
    }
    _currentPage = currentPage;
    self.pageControl.currentPage = _currentPage - 1;
//    if (!_tipView.hidden) {
//        [self reloadText];
//    }
}

- (void)fixCurrentPage{
    NSInteger fixedPage = (NSInteger)(self.contentView.contentOffset.x / CGRectGetWidth(self.contentView.bounds) + 0.5);
    if(fixedPage == [self.items count] - 1){
        fixedPage = 1;
        self.contentView.contentOffset = CGPointMake(fixedPage * CGRectGetWidth(self.contentView.bounds), 0);
    }else if(fixedPage == 0){
        fixedPage = [self.items count] - 2;
        self.contentView.contentOffset = CGPointMake(fixedPage * CGRectGetWidth(self.contentView.bounds), 0);
    }
    _currentPage = fixedPage;
    self.pageControl.currentPage = _currentPage - 1;
//    if (!_tipView.hidden) {
//        [self reloadText];
//    }
}

#pragma mark -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.scrollTimer setFireDate:[NSDate dateWithTimeInterval:self.interval sinceDate:[NSDate date]]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self fixCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x/CGRectGetWidth(self.contentView.bounds) != self.currentPage){
        [self.contentView setContentOffset:CGPointMake(CGRectGetWidth(self.contentView.bounds) * self.currentPage, 0) animated:NO];
    }
}
@end
