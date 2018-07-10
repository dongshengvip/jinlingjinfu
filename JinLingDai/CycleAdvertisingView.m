//
//  CycleAdvertisingView.m
//  JinLingDai
//
//  Created by 001 on 2017/6/28.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "CycleAdvertisingView.h"
#import <SDWebImageManager.h>

@interface CycleAdvertisingView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contenView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIPageControl *pageControl;
//自动翻页的时间 (0 表示不翻页)
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray *dataArr;
/**
 *  保存可见的视图
 */
@property (nonatomic, strong) NSMutableSet *visibleImageViews;

/**
 *  保存可重用的
 */
@property (nonatomic, strong) NSMutableSet *reusedImageViews;
@property (nonatomic , assign) BOOL finished;
@end
@implementation CycleAdvertisingView

- (instancetype)init{
    if (self = [super init]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
//        scrollView.contentSize = CGSizeMake(self.imageNames.count * CGRectGetWidth(scrollView.frame), 0);
//        scrollView.minimumZoomScale = 0.5;
//        scrollView.maximumZoomScale = 2.5;
        [self addSubview:scrollView];
        _contenView = scrollView;
//        [self showImageViewAtIndex:0];
    }
    return self;
}

- (void)creatUI:(NSArray *)items TimeInterval:(NSTimeInterval)interval{
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showImages];
//    [self test];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _finished = YES;
    [self showImages];
//    [self test];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _finished = NO;
}
#pragma mark - Private Method

- (void)showImages {
    
    // 获取当前处于显示范围内的图片的索引
    CGRect visibleBounds = self.contenView.bounds;
    CGFloat minX = CGRectGetMinX(visibleBounds);
    CGFloat maxX = CGRectGetMaxX(visibleBounds);
    CGFloat width = CGRectGetWidth(visibleBounds);
    
    NSInteger firstIndex = (NSInteger)floorf(minX / width);
    NSInteger lastIndex  = (NSInteger)floorf(maxX / width);
    if (_finished) {
        lastIndex = firstIndex;
    }
    // 处理越界的情况
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    
    if (lastIndex >= [self.dataArr count]) {
        lastIndex = [self.dataArr count] - 1;
    }
    
    // 回收不再显示的ImageView
    NSInteger imageViewIndex = 0;
    for (UIImageView *imageView in self.visibleImageViews) {
        imageViewIndex = imageView.tag;
        // 不在显示范围内
        if (imageViewIndex < firstIndex || imageViewIndex > lastIndex) {
            [self.reusedImageViews addObject:imageView];
            [imageView removeFromSuperview];
        }
    }
    
    [self.visibleImageViews minusSet:self.reusedImageViews];
    
    // 是否需要显示新的视图
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        BOOL isShow = NO;
        
        for (UIImageView *imageView in self.visibleImageViews) {
            if (imageView.tag == index) {
                isShow = YES;
            }
        }
        
        if (!isShow) {
            [self showImageViewAtIndex:index];
        }
    }
}

// 显示一个图片view
- (void)showImageViewAtIndex:(NSInteger)index {
    
    UIImageView *phtoview = [self.reusedImageViews anyObject];
    
    if (phtoview) {
        [self.reusedImageViews removeObject:phtoview];
    } else {
        phtoview = [[UIImageView alloc] initWithFrame:self.contenView.bounds];

        [phtoview sd_setImageWithURL:[NSURL URLWithString:self.dataArr[index]] placeholderImage:KDefaultImg options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        phtoview.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    CGRect bounds = self.contenView.bounds;
    CGRect imageViewFrame = bounds;
    imageViewFrame.origin.x = CGRectGetWidth(bounds) * index;
    phtoview.tag = index;
    phtoview.frame = imageViewFrame;
    
    [self.visibleImageViews addObject:phtoview];
    [self.contenView addSubview:phtoview];
}
@end
