//
//  JLDPayVc.m
//  JinLingDai
//
//  Created by 001 on 2017/6/29.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JLDPayVc.h"
//#import <WXApi.h>
//#import <AlipaySDK/AlipaySDK.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>

#define ORDERNO  @"当前订单的编号"
//支付宝
#define ZhiFuBaoScheme          @""
@interface JLDPayVc ()

@end

@implementation JLDPayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 发送请求获得支付编号，调用第三方支付
-(void)sendPayRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@""
    parameters:@{@"uid" : @"userID",
                 @"orderno" : ORDERNO,
                 @"balance" : @"",// 余额 暂时传空
                 @"type" : @"支付编号"}
    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([self.paytype integerValue]== 1){
            // 调用银联支付
//            [UPPayPlugin startPay:responseObject mode:@"00" viewController:self delegate:self];
        } else if([self.paytype integerValue] == 2){
            // 调用支付宝
//            [[AlipaySDK defaultService] payOrder:responseObject fromScheme:ZhiFuBaoScheme callback:^(NSDictionary *resultDic) {
//                [self processOrderZhiFubBao:resultDic];
//            }];
        } else if ([self.paytype integerValue] == 4) {
            // 调用微信
//            NSDictionary *dataDict = responseObject;
            /*
             PayReq* req = [[PayReq alloc] init];
             req.openID = [dataDict objectForKey:@"appid"];
             req.partnerId = [dataDict objectForKey:@"partnerid"];
             req.prepayId = [dataDict objectForKey:@"prepayid"];
             req.nonceStr = [dataDict objectForKey:@"noncestr"];
             req.timeStamp = [[dataDict objectForKey:@"timestamp"]intValue];
             req.package = [dataDict objectForKey:@"packagestr"];
             req.sign = [dataDict objectForKey:@"sign"];
             [WXApi sendReq:req];
             */
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark - 微信支付回调结果
- (void)getOrderPayResult:(NSNotification *)notification
{
    BOOL tradeSucc = NO;
    if ([notification.object isEqualToString:@"success"]) {
        tradeSucc=YES;
    }
    [self paymentSynchronous:tradeSucc type:4];
}

//#pragma mark - 银联支付回调结果
//- (void)UPPayPluginResult:(NSString *)result
//{
//    BOOL success = NO;
//    if([[result lowercaseString] isEqualToString:@"success"]){
//        success = YES;
//    }
//    [self paymentSynchronous:success type:1];
//}

#pragma mark - 支付宝支付后回调
- (void)handleZhiFuBaoCallBack:(NSNotification *)sender{
    NSURL *url = sender.object;
    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            [self processOrderZhiFubBao:resultDic];
//        }];
    }
}
- (void)processOrderZhiFubBao:(NSDictionary *)resultDic{
    BOOL tradeSucc = NO;
    if([resultDic[@"resultStatus"] intValue] == 9000
       || [resultDic[@"success"] boolValue]){
        tradeSucc = YES;
    }
    [self paymentSynchronous:tradeSucc type:2];
}


#pragma mark -上传已经成功支付的订单
- (void)paymentSynchronous:(BOOL)payMentSucc type:(NSInteger)type{
    /**
     *  ios9+,选择支付方式跳转支付APP后，点击导航返回，重复操作，会造成一次支付，多个订单成功
     */
//    if (isGetRequest == YES) {
//        NSLog(@"已经成功过了");
//        return;
//    }else{
//        NSLog(@"第一次成功");
//    }
//    isGetRequest = YES;
//    
//    if(payMentSucc){
//        
//        self.navigationItem.rightBarButtonItem = nil;
//        [HttpUtil load:@"deal/paymoneycallback"
//                params:@{@"orderno" : ORDERNO,
//                         @"tradestatus" : @"1",
//                         @"paytype" : @(type)}
//            completion:^(BOOL succ, NSString *message, id json) {
//                if(succ){
//                    NSString *str;
//                    if (type == 1) {
//                        str=@"银联";
//                    } else if (type == 2) {
//                        str=@"支付宝";
//                    } else if (type == 3) {
//                        str=@"微信";
//                    }
//                    [MBProgressHUD showSuccess:message];
//                }else{
//                    [MBProgressHUD showSuccess:message];
//                }
//            }
//         ];
//    }else{
////        [MBProgressHUD showError:@"您未成功支付，\n未付订单请及时处理"];
//    }
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
