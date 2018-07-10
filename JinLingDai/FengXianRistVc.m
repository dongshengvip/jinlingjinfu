//
//  FengXianRistVc.m
//  JinLingDai
//
//  Created by 001 on 2018/3/9.
//  Copyright © 2018年 JLD. All rights reserved.
//

#import "IMYWebView.h"
#import "FengXianRistVc.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKScriptMessageHandler.h>
#import "RistResultVc.h"
@interface FengXianRistVc ()<IMYWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
{
    WKWebView *myWebview;
}
@property (nonatomic) BOOL hadLoad;
@end

@implementation FengXianRistVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"风险等级测评";
    [self setNavBlackColor];
    myWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + 44, self.view.bounds.size.width, self.view.bounds.size.height - 44 - StatusBarHeight)];
//    myWebview.delegate = self;
    myWebview.UIDelegate = self;
    myWebview.navigationDelegate = self;
    WKWebViewConfiguration* configuration = [myWebview configuration];
    [configuration.userContentController addScriptMessageHandler:self name:@"showResult"];
//    [myWebview addScriptMessageHandler:self name:@"showResult"];
//    [myWebview addScriptMessageHandler:self name:@"Camera"];
//    [myWebview addScriptMessageHandler:self name:@"Input"];
    [self.view addSubview:myWebview];
    [myWebview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (void)setIsChuJie:(BOOL)isChuJie{
    _isChuJie = isChuJie;
}

- (void)setH5Url:(NSString *)H5Url{
    _H5Url = H5Url;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.H5Url && !self.hadLoad) {
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.H5Url]
                                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                              timeoutInterval:15.0];
        [myWebview loadRequest:theRequest];
        //        _originRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.H5Url]];
        //
        //        [self.H5View loadRequest:_originRequest];
    }
    self.hadLoad = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    if ([message.name isEqualToString:@"showResult"]) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arr removeLastObject];
        RistResultVc *vc = [[RistResultVc alloc]init];
        vc.isRefreshUser = YES;
        vc.isChuJie = self.isChuJie;
        vc.hidesBottomBarWhenPushed = YES;
        [arr addObject:vc];
        [self.navigationController setViewControllers:arr animated:YES];
        
//        if ([((WKScriptMessage *)message).body isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = ((WKScriptMessage *)message).body;
//
//        }
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
    
            NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    
            completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        }
    NSString *hostName = webView.URL.host;

    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    return;
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
//                    UIViewController *vc = self.delegate;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
