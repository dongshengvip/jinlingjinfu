//
//  AboutCompanyVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "AboutCompanyVc.h"
#import "UIColor+Util.h"
#import <Masonry.h>
#ifdef MoreThaniOS10
#import <StoreKit/StoreKit.h>
#endif
@interface AboutCompanyVc ()
//@property 
@end

@implementation AboutCompanyVc
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    
    [self setNavBlackColor];
    self.title = @"关于我们";
    
    UIImageView *companyLogo = [[UIImageView alloc]init];
    companyLogo.image = [UIImage imageNamed:@"LOGO"];
    [self.view addSubview:companyLogo ];
    [companyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(ChangedHeight(75));
        make.top.equalTo(self.view).offset(ChangedHeight(23) + 64);
    }];
    
    NSMutableParagraphStyle *parastyle = [[NSMutableParagraphStyle alloc]init];
    
    [parastyle setLineSpacing:ChangedHeight(6)];
    [parastyle setAlignment:NSTextAlignmentCenter];
    
    UILabel *verLab = [UILabel new];
    verLab.numberOfLines = 0;
    [self.view addSubview:verLab];
    [verLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(companyLogo.mas_bottom).offset(ChangedHeight(25));
    }];
    
    
    
    
    UILabel *contenLab = [UILabel new];
    contenLab.numberOfLines = 0;
    [self.view addSubview:contenLab];
    [contenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(verLab.mas_bottom).offset(ChangedHeight(40));
    }];
    
    NSMutableAttributedString *verAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"金陵金服手机客户端\niOS版本：%@",kAppVersion]];
    [verAttr addAttribute:NSParagraphStyleAttributeName value:parastyle range:NSMakeRange(0, verAttr.string.length)];
    [verAttr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, verAttr.string.length)];
    [verAttr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:14] range:NSMakeRange(0, verAttr.string.length)];
    verLab.attributedText = verAttr;
    
    NSMutableAttributedString *contenAttr = [[NSMutableAttributedString alloc]initWithString:@"隶属江苏耀信经济信息咨询有限公司\n创建于2013年9月\n是国内较早的互联网网络理财平台\n\n致力于提高普通百姓投资理财收益\n\n为了您的投资生活\n我们一直在努力"];
    [contenAttr addAttribute:NSParagraphStyleAttributeName value:parastyle range:NSMakeRange(0, contenAttr.string.length)];
    [contenAttr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, contenAttr.string.length)];
    [contenAttr addAttribute:NSFontAttributeName value:[UIFont gs_fontNum:14] range:NSMakeRange(0, contenAttr.string.length)];
    contenLab.attributedText = contenAttr;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"给我们点个赞吧" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont gs_fontNum:15];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor getOrangeColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(- 35));
        make.height.mas_equalTo(ChangedHeight(40));
        make.bottom.equalTo(self.view).offset(ChangedHeight(-40));
    }];
    
}

- (void)rechargeMoney{
    if(MoreThaniOS10&&[SKStoreReviewController respondsToSelector:@selector(requestReview)]){
        [SKStoreReviewController requestReview];
    }else
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppItunesUrl] options:@{} completionHandler:^(BOOL success) {
            NSLog(@"%d",success);
        }];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppItunesUrl]];
    }
    
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
