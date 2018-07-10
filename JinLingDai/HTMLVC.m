//
//  HTMLVC.m
//  JinLingDai
//
//  Created by 001 on 2017/7/12.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "HTMLVC.h"
#import "MBProgressHUD+NetWork.h"
#import "JLDShareManager.h"
#import <NJKWebViewProgressView.h>
#import <NJKWebViewProgress.h>
#import "UIViewController+BackButtonHandler.h"
#import "OSCPhotoGroupView.h"
#import "ChuJieXiangQingVc.h"
@interface HTMLVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIGestureRecognizerDelegate,NSURLConnectionDataDelegate>
{
    NSURLRequest *_originRequest;
    
    NSURLConnection *_urlConnection;
    
    BOOL _authenticated;
}
@property (nonatomic, strong) MBProgressHUD          *HUD;
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress     *webViewProgress;
@property (nonatomic, assign) BOOL hadLoad;
@end

@implementation HTMLVC

- (BOOL)navigationShouldPopOnBackButton{
    if (_ignoreBetween) return YES;
    if ([self.H5View canGoBack]) {
        [self.H5View goBack];
        return NO;
    }
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavBlackColor];
//    self.navigationController.navigationBar.delegate = self;
    self.H5View = [[UIWebView alloc]init];
//    self.H5View.delegate = self;
    self.H5View.scalesPageToFit = YES;
    [self.view addSubview:self.H5View];
    [self.H5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.webViewProgress = [[NJKWebViewProgress alloc] init];
    __weak typeof (NJKWebViewProgress *)weakProgress = self.webViewProgress;
    self.webViewProgress.webViewProxyDelegate = self;
    self.H5View.delegate = weakProgress;

    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 - 4,
                                 navBounds.size.width,
                                 4);
    

    self.webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    self.webViewProgressView.backgroundColor = [UIColor blackColor];
    self.webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [self.webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];

    __weak typeof(_webViewProgressView) weakProgressView = _webViewProgressView;
    self.webViewProgress.progressBlock = ^(float progress) {
        [weakProgressView setProgress:progress animated:YES];
    };
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletap:)];
//    singleTap.numberOfTouchesRequired = 1;
//    singleTap.delegate=self;
//    singleTap.cancelsTouchesInView = NO;
//    [self.H5View addGestureRecognizer:singleTap];
}

- (void)setH5Url:(NSString *)H5Url{
    _H5Url = H5Url;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.H5Url && !self.hadLoad) {
        [self.H5View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.H5Url]]];
//        _originRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.H5Url]];
//        
//        [self.H5View loadRequest:_originRequest];
    }
    self.hadLoad = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [self.HUD showAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self.HUD hideAnimated:YES];
}

- (void)Share{
    [self JLDShare:self.isShare];
}
- (void)setShareBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shareTo"] style:UIBarButtonItemStylePlain target:self action:@selector(Share)];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlstring = [[request.URL.absoluteString copy] lowercaseString];
    if ([urlstring containsString:@"invitefx"]) {
        [self JLDShare:YES];
        return NO;
    }else if ([urlstring containsString:@"borrow/lists"] || [urlstring containsString:@"invest/index"]){
        [self.tabBarController setSelectedIndex:1];
        [self.navigationController popViewControllerAnimated:NO];
        return NO;
    }else if([urlstring containsString:@"member/memberinfo/openaccount"]){
        UIViewController *vc = [[NSClassFromString(@"ManageOfBankVc") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if ([urlstring containsString:@"invest/detail"]){
        NSArray *investArr = [urlstring componentsSeparatedByString:@"?id="];
        if (investArr.count) {
            NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [vcArr removeLastObject];
            ChuJieXiangQingVc *vc = [[ChuJieXiangQingVc alloc]init];
            vc.borrow_id = investArr.lastObject;
            vc.hidesBottomBarWhenPushed = YES;
            [vcArr addObject:vc];
            [self.navigationController setViewControllers:vcArr animated:YES];
        }
        return NO;
    }else if ([urlstring containsString:@"login"]){
        NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcArr removeLastObject];
        [self loginUser];
        [self.navigationController setViewControllers:vcArr];
    }
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.HUD = [MBProgressHUD createHUD];
    self.HUD.detailsLabel.text = @"加载失败";
    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:0.5f];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - 手势点击图片


-(void)singletap:(UITapGestureRecognizer *)sender
{
    
    CGPoint pt = [sender locationInView:sender.view];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [((UIWebView *)sender.view) stringByEvaluatingJavaScriptFromString:imgURL];
    if (urlToSave.length > 0) {
        if ([urlToSave rangeOfString:@"jpg"].location  != NSNotFound ||
            [urlToSave rangeOfString:@"png"].location  != NSNotFound ||
            [urlToSave rangeOfString:@"jepg"].location != NSNotFound ||
            [urlToSave rangeOfString:@"gif"].location  != NSNotFound
            ||
            [urlToSave rangeOfString:@"pdf"].location  != NSNotFound)
        {
            OSCPhotoGroupItem* item = [OSCPhotoGroupItem new];
            item.largeImageURL = [NSURL URLWithString:urlToSave];
            
            OSCPhotoGroupView* groupView = [[OSCPhotoGroupView alloc] initWithGroupItems:@[item]];
            UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
            
            [groupView presentFromImageView:nil toContainer:currentWindow animated:NO completion:nil];
        }
    }else{
        
    }
}

- (void)resetUrl:(NSString *)url{
    [self.H5View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)JLDShare:(BOOL)isShare{
    if ([JLDShareManager canShareToFriendds]) {
        ShareModel *model = [[ShareModel alloc] init];
        model.title = self.title;
        model.logoImage = [UIImage imageNamed:@"LOGO"];
        model.descString = @"金陵金服国企全资控股，安全运营5年，银行存管对接，供应链金融，值得信赖。";
        //        model.resourceUrl = @"";
        NSString *postUrl ;
        kAppPostHost(postUrl);
        if (isShare) {
            model.title = @"老平台，全场预期年化12%收益";
            model.href = [UserManager shareManager].user?[NSString stringWithFormat:@"%@user/register/code/%@",postUrl,[UserManager shareManager].user.code]:[NSString stringWithFormat:@"%@user/register/code",postUrl];
                model.isImag = YES;
                [[JLDShareManager shareManager] showShareBoardWithModel:model];
        }else{
            model.href = [self.H5Url stringByAppendingString:@"&download=1"];
            model.isImag = YES;
            [[JLDShareManager shareManager] showShareBoardWithModel:model];
        }
        
        
        
    }else{
        UIAlertController *warmTip = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未安装社交软件来分享消息" preferredStyle:UIAlertControllerStyleAlert];
        [warmTip addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:warmTip animated:YES completion:nil];
    }
}

- (void)loging{
    UIViewController *vc = [[NSClassFromString(@"LogingVc") alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.webViewProgress = nil;
    [self.webViewProgressView removeFromSuperview];;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
