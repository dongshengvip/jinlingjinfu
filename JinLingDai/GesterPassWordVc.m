//
//  GesterPassWordVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/3.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "GesterPassWordVc.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import <YYKit.h>
#import "MBProgressHUD+NetWork.h"
#import "UserManager.h"
#import "UIView+Radius.h"
@interface GesterPassWordVc ()<CircleViewDelegate>
{
    PCCircleView *lockView;
    UIButton *jumpBtn;//跳过
    UIButton *backBtn;//登录手势的关闭
}
@property (nonatomic, strong) UILabel *tipTitleLab;//大标题
@property (nonatomic, strong) UILabel *tipSubLab;//小标题或昵称
@property (nonatomic, strong) UILabel *nickTipLab;//有昵称时的提示
@property (nonatomic, strong) UIImageView *userLogo;//头像
@property (nonatomic, strong) UIButton *reSetBtn;//重置
@property (nonatomic, assign) NSInteger errTime;//错误
@end
static NSInteger maxErrTime = 5;
@implementation GesterPassWordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor infosBackViewColor];
    
    lockView = [[PCCircleView alloc]init];
    lockView.delegate = self;
    lockView.clip = NO;
    [self.view addSubview:lockView];
    
    [self setNavBlackColor];
    
    
    self.tipTitleLab = [UILabel new];
    self.tipTitleLab.text = @"请绘制手势密码";
    
    self.tipTitleLab.font = [UIFont gs_fontNum:17 weight:UIFontWeightBold];
    self.tipTitleLab.textAlignment = NSTextAlignmentCenter;
//    self.tipTitleLab.textColor = [UIColor]
    [self.view addSubview:self.tipTitleLab];
    
    
    self.tipSubLab = [UILabel new];
    self.tipSubLab.text = @"请绘制手势密码";
    self.tipSubLab.textColor = [UIColor darkGrayColor];
    self.tipSubLab.textAlignment = NSTextAlignmentCenter;
    self.tipSubLab.font = [UIFont gs_fontNum:13];
    [self.view addSubview:self.tipSubLab];
    
    self.userLogo = [[UIImageView alloc]init];
    self.userLogo.hidden = YES;
    self.userLogo.backgroundColor = [UIColor whiteColor];
    self.userLogo.bounds = CGRectMake(0, 0, ChangedHeight(55), ChangedHeight(55));
    [self.view addSubview:self.userLogo];
    
    
    self.nickTipLab = [UILabel new];
    self.nickTipLab.textAlignment = NSTextAlignmentCenter;
    self.nickTipLab.textColor = [UIColor getOrangeColor];
    self.nickTipLab.font = [UIFont gs_fontNum:13];
    self.nickTipLab.text = @"绘制手势密码";
    [self.view addSubview:self.nickTipLab];
    
   
    
    self.reSetBtn = [UIButton new];
    self.reSetBtn.hidden = YES;
    [self.reSetBtn addTarget:self action:@selector(reSetGester) forControlEvents:UIControlEventTouchUpInside];
    [self.reSetBtn setTitle:@"重新设置" forState:UIControlStateNormal];
    [self.reSetBtn setTitleColor:[UIColor getBlueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.reSetBtn];
   
    
    
    
    
}

- (void)reSetGester{
    if (self.circleType == CircleViewTypeSetting) {
       [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    }else{
        [[UserManager shareManager] logoutUsr];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLogout object:nil];
        if (_gesterSuccessBlock) {
            _gesterSuccessBlock();
        }
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    [lockView setType:self.circleType];
    
    if (self.circleType == CircleViewTypeSetting) {
        self.tipTitleLab.hidden = NO;
        self.nickTipLab.hidden = self.userLogo.hidden = YES;
//    }else if (self.circleType == CircleViewTypeSetting){
        
    }else{
        self.tipTitleLab.hidden = YES;
        self.nickTipLab.hidden = self.userLogo.hidden = NO;
        [self.userLogo.superview layoutIfNeeded];
        [self.userLogo setCornerRadiusAdvance:self.userLogo.width/2];
        [self.userLogo sd_setImageWithURL:[NSURL URLWithString:[UserManager shareManager].user.head] placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        self.nickTipLab.text = @"验证手势密码";
        [UserManager shareManager];
        self.tipSubLab.text = [NSString stringWithFormat:@"欢迎,%@",[UserManager shareManager].user.username];
    }
    if (self.circleType == CircleViewTypeLogin) {
        self.reSetBtn.hidden = NO;
        [self.reSetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [self setLoginLayoutCenten];
    }else
        [self setOtherLayoutCenten];
}


/**
 登录约束
 */
- (void)setLoginLayoutCenten{

    [self.tipSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(120) + 64);
        make.left.right.equalTo(self.view);
    }];
    
    [self.userLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(45) + 64);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(ChangedHeight(55));
    }];
    [self.nickTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipSubLab.mas_bottom).offset(ChangedHeight(15));
        make.left.right.equalTo(self.view);
    }];
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(-35));
        make.height.equalTo(lockView.mas_width);
        make.top.equalTo(self.tipSubLab.mas_bottom).offset(ChangedHeight(55));
        //        make.height.equalTo(self.view).dividedBy(3/2.0);
    }];
    [self.reSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(lockView.mas_bottom).offset(ChangedHeight(40));
    }];
}
/**
其他约束
 */
- (void)setOtherLayoutCenten{
    [self.tipTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(55) + 64);
        make.left.right.equalTo(self.view);
        //        make.centerX.equalTo(self.view);
    }];
    [self.tipSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(90) + 64);
        make.left.right.equalTo(self.view);
    }];
    [self.userLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ChangedHeight(7) + 64);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(ChangedHeight(55));
    }];
    [self.nickTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipSubLab.mas_bottom).offset(ChangedHeight(15));
        make.left.right.equalTo(self.view);
    }];
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ChangedHeight(35));
        make.right.equalTo(self.view).offset(ChangedHeight(-35));
        make.height.equalTo(lockView.mas_width);
        make.top.equalTo(self.tipSubLab.mas_bottom).offset(ChangedHeight(55));
        //        make.height.equalTo(self.view).dividedBy(3/2.0);
    }];
    [self.reSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(lockView.mas_bottom).offset(ChangedHeight(40));
    }];
}
/**
 设置手势的类型

 @param circleType 类型
 */
- (void)setCircleType:(CircleViewType)circleType{
    _circleType = circleType;
    [lockView setType:_circleType];
}

- (void)backTolastVc{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  登陆或者验证手势密码输入完成时的代理方法
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 登陆时的手势密码
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {//通过了验证
            [MBProgressHUD showSuccess:@"验证成功" toView:self.view];
            if (_gesterSuccessBlock) {
                _gesterSuccessBlock();
            }
            if (self.navigationController && self.navigationController.viewControllers.count) {
                [self performSelector:@selector(backTolastVc) withObject:nil afterDelay:1.f];
            }
        } else {
            
            self.nickTipLab.text = @"密码错误";
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            self.nickTipLab.text = @"请设置手势密码";
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
            
            [lockView setType:CircleViewTypeSetting];
            
        } else {
            self.errTime ++;
            if (self.errTime >= maxErrTime) {
                self.reSetBtn.hidden = NO;
            }
            self.nickTipLab.text = @"密码验证失败";
            
        }
    }
}
/**
 *  连线个数多于或等于4个，获取到第一个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 第一个次保存的密码
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture{
    if (self.nickTipLab.hidden) {
        self.tipSubLab.text = @"请再次输入手势";
    }else{
        self.nickTipLab.text = @"请再次输入手势";
    }
}
/**
 *  获取到第二个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 第二次手势密码
 *  @param equal   第二次和第一次获得的手势密码匹配结果
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal{
    if (equal) {
        if (self.nickTipLab.hidden) {
            self.tipSubLab.text = @"手势设置成功";
        }else{
            self.nickTipLab.text = @"手势设置成功";
        }
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        UserModel *model = [UserManager shareManager].user;
        model.hadGester = YES;
        model.gesterOn = YES;
        [[UserManager shareManager] saveUserModel:model];
        MBProgressHUD *MBhud = [MBProgressHUD createHUD];
        MBhud.label.text = @"设置成功";
        
        [MBhud showAnimated:YES];
        [MBhud hideAnimated:YES afterDelay:1.f];
        if (_gesterSuccessBlock) {
            _gesterSuccessBlock();
        }
        [self performSelector:@selector(backTolastVc) withObject:nil afterDelay:1.f];
    }else{
        if (self.nickTipLab.hidden) {
            self.tipSubLab.text = @"手势输入不对";
        }else{
            self.nickTipLab.text = @"手势输入不对";
        }
    }
}
/**
 *  连线个数少于4个时，通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 手势结果
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    // 看是否存在第一个密码
    if (gestureOne) {
        
        
    } else {
        //设置失败
        if (self.nickTipLab.hidden) {
            self.tipSubLab.text = @"密码不能少于4位";
        }else{
            self.nickTipLab.text = @"密码不能少于4位";
        }
    }
}
/**
 自己添加,用于返回绘制结束时的image
 
 @param view  circleView
 @param type  type
 @param image 绘制结束时的图案
 */
//- (void)cicleView:(PCCircleView *)view type:(CircleViewType)type didEndGesture:(UIImage *)image{
//    
//}
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
