//
//  HTMLVC.h
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ViewController.h"
//#import "<#header#>"
@interface HTMLVC : ViewController

@property (nonatomic, assign) BOOL ignoreBetween;
@property (nonatomic, copy) NSString *H5Url;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) UIWebView *H5View;
- (void)resetUrl:(NSString *)url;
- (void)setShareBtn;
@end
