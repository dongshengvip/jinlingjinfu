//
//  ChuJieInfoHTML.m
//  JinLingDai
//
//  Created by 001 on 2017/7/25.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ChuJieInfoHTML.h"
#import "TitleBarView.h"
#import <WebKit/WebKit.h>

@interface ChuJieInfoHTML ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>{
    UIScrollView *scroll;
}
@property (nonatomic, strong) TitleBarView *H5TitleView;//H5的title
@property (nonatomic, strong) UIView *webBGView;;//H5的底部页面
@property (nonatomic, strong) NSMutableDictionary *H5Dic;//H5存放的字典
@end

@implementation ChuJieInfoHTML

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    scroll = [[UIScrollView alloc]init];
    //    webScroll.delegate = self;
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.backgroundColor = [UIColor infosBackViewColor];
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(StatusBarHeight + 44, 0, 0, 0));
    }];
    _webBGView = [UIView new];
    [scroll addSubview:_webBGView];
    [_webBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.height.equalTo(self.view).offset(- StatusBarHeight - 44);
        make.width.equalTo(self.view).multipliedBy(4.0);
    }];
    
    self.H5TitleView = [[TitleBarView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 44, K_WIDTH, ChangedHeight(40))];
    //    self.H5TitleView.layer.shadowColor = [UIColor redColor].CGColor;
    //    self.H5TitleView.layer.shadowRadius = 5;
    //    self.H5TitleView.layer.shadowOpacity = 1;
    //    self.H5TitleView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.view addSubview:self.H5TitleView];
    [self.H5TitleView reloadAllButtonsOfTitleBarWithTitles:@[@"项目信息",@"相关资料",@"出借记录",@"还款记录"]];
    self.H5TitleView.currentCollor = [UIColor getOrangeColor];
    __weak typeof(self) weakMine = self;
    self.H5TitleView.titleButtonClicked = ^(NSUInteger index) {
        [weakMine setContentViewAtindex:index];
    };
    
    self.H5Dic = [[NSMutableDictionary alloc]init];
    
    [self setContentViewAtindex:0];
    
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        
//        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
//        
//        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
//    }
    NSString *hostName = webView.URL.host;
    
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;

        if (secTrustRef != NULL) {

            SecTrustResultType result;

            OSErr er = SecTrustEvaluate(secTrustRef, &result);
            if (er != noErr) {

                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,  nil);

                return;

            }

            if (result == kSecTrustResultRecoverableTrustFailure) {
            
                //证书不受信任

                CFArrayRef secTrustProperties = SecTrustCopyProperties(secTrustRef);

                NSArray *arr = CFBridgingRelease(secTrustProperties);

                NSMutableString *errorStr = [NSMutableString string];

                for (int i=0;i<arr.count;i++){
                
                    NSDictionary *dic = [arr objectAtIndex:i];

                    if (i != 0 ) [errorStr appendString:@" "];
                        
                        [errorStr appendString:(NSString*)dic[@"value"]];
                        
                    }

                    SecCertificateRef certRef = SecTrustGetCertificateAtIndex(secTrustRef, 0);

                    CFStringRef cfCertSummaryRef = SecCertificateCopySubjectSummary(certRef);

                    NSString *certSummary = (NSString *)CFBridgingRelease(cfCertSummaryRef);

                    NSString *title = @"该服务器无法验证";

                    NSString *message = [NSString stringWithFormat:@" 是否通过来自%@标识为 %@证书为%@的验证. \n%@" , @"我的app",hostName,certSummary, errorStr];

                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"

                                    style:UIAlertActionStyleDefault

                                    handler:^(UIAlertAction *action) {
                                    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}]

                    ];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];

                    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);

                    }]];
            
          dispatch_async(dispatch_get_main_queue(), ^{
                
              [self presentViewController:alertController animated:YES completion:^{}];
                
               });
            
               return;

            }

        NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];

        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);

        return;

        }

        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);

        }

        else {

        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);

        }

   

}



/**
 设置4个h5
 
 @param index 顺讯
 */
- (void)setContentViewAtindex:(NSInteger)index{
    [scroll setContentOffset:CGPointMake(K_WIDTH * index, 0)];
    if (self.H5Dic[[NSString stringWithFormat:@ "%@",@(index)]]) {
        return;
    }
    
    WKWebView *webview = [[WKWebView alloc]init];
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
//    webview.scrollView.delegate = self;
    //    _web.scrollView.scrollEnabled = NO;
    //    _web.delegate = self;
    //    [webScroll insertSubview:webview belowSubview:self.H5TitleView];
    [scroll addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_webBGView);
        make.top.equalTo(_webBGView).offset(ChangedHeight(40));
        make.width.equalTo(self.view);
        if (index == 3) {
            make.right.equalTo(_webBGView);
        }else{
            make.left.equalTo(_webBGView).offset(K_WIDTH * index);
        }
        
    }];
    [self.H5Dic setValue:webview forKey:[NSString stringWithFormat:@"%@",@(index)]];
    
    if (!self.borrowModel) {
        return ;
    }
    switch (index) {
        case 0:{
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.borrow_info]]];
        }
            
            break;
        case 1:
        {
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.file_info]]];
        }
            break;
        case 2:
        {
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.borrow_log]]];
        }
            break;
            
        default:{
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.borrowModel.investor_log]]];
        }
            break;
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if ([scrollView isEqual:webScroll]) {
        NSInteger idex = (NSInteger)scrollView.contentOffset.x/K_WIDTH;
        [self.H5TitleView scrollToCenterWithIndex:idex];
        [self setContentViewAtindex:idex];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
