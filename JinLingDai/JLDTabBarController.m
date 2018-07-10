//
//  JLDTabBarController.m
//  JinLingDai
//
//  Created by 001 on 2017/6/26.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "JLDTabBarController.h"
#import "ViewController.h"
#import "UIImage+Comment.h"
#import "UIDevice+SystemInfo.h"
#import "JLDNavigationController.h"
#import "UserManager.h"
#import "SecondVc.h"
#import "JLDActAlertView.h"
#import "RedBagAleartView.h"
#import "ManageOfBankVc.h"
#import "OSCMotionManager.h"
#define VcArr @[@"HomePageVc",@"SecondVc",@"FindVc",@"MineVc",@"MineVc"]
@interface JLDTabBarController ()<UITabBarControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) RedBagAleartView *alertView;
@end

@implementation JLDTabBarController

+ (JLDTabBarController *)shareManager{
    static JLDTabBarController *manager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[JLDTabBarController alloc] init];
        }
    });
    return manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    self.delegate = self;

    
//    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ChangedHeight(40), ChangedHeight(44)));
//        //                make.right.equalTo(window).offset(ChangedHeight(-30));
//        //                make.bottom.equalTo(window).offset(ChangedHeight(-180));
//        make.center.equalTo(self.tabBar);
//    }];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -8, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
//    [imageView setImage:[UIImage imageNamed:@"tab-bg"]];
//
////    if (K_WIDTH == 375) {
////        [imageView setImage:[UIImage imageNamed:@"tab-6-bg"]];
////    }
//    [imageView setContentMode:UIViewContentModeCenter];
//    [self.tabBar insertSubview:imageView atIndex:0];
//    [self.tabBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
//    [self.tabBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
//    [self.tabBar setShadowImage:[[UIImage new] imageMaskedWithColor:[UIColor clearColor]]];
    
    
    self.viewControllers = @[
                             [self creatNavWithVc:VcArr[0]],
                             [self creatNavWithVc:VcArr[1]],
                             [self creatNavWithVc:VcArr[2]],
                             [self creatNavWithVc:VcArr[3]],
//                             [self creatNavWithVc:VcArr[4]],
                             ];
    
    NSArray *titles = @[@"首页", @"产品", @"发现", @"我的"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor getOrangeColor]} forState:UIControlStateSelected];
//        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor getOrangeColor]} forState:UIControlStateSelected];
        item.image = [[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
//    [self.tabBar.items[2] setEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHadLoged) name:UserLogin object:nil];
    //会员登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHadLogOut) name:UserLogout object:nil];
    //银行存管
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userOpenBankManager) name:OpenBankManager object:nil];
    
//    _alertView = [[RedBagAleartView alloc]init];
//    
//    _alertView.redBagType = RedBagUsedNow;
//    //        __weak typeof(self) weakSelf = self;
//    _alertView.confirmBtnBlock = ^{
//        //                [weakSelf.alertView hidenAlertType];
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        //        UIViewController *vc = [[NSClassFromString(@"UserNameAndIdCheckVc") alloc] init];
//        //        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        //        [window.rootViewController presentViewController:nav animated:YES completion:nil];
//        JLDActAlertView *actView = [JLDActAlertView shareManager];
//        [actView showAlertType:BankShowType toView:window];
//    };
    
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)userOpenBankManager{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        BankGiftImageView *giftView = [BankGiftImageView shareManage];
//        [giftView.giftImage stopAnimating];
//        giftView.hidden = YES;
        
        ManageOfBankVc *vc = [[ManageOfBankVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = (UINavigationController *)self.selectedViewController;
        [nav pushViewController:vc animated:YES];
    });
    
}

- (void)userHadLogOut{
    [OSCMotionManager shareMotionManager].isShaking = NO;
    [OSCMotionManager shareMotionManager].canShake =  NO;

//    BankGiftImageView *bankView = [BankGiftImageView shareManage];
//    bankView.hidden = YES;
//    [bankView.giftImage stopAnimating];
    [[UserManager shareManager]logoutUsr];
//    [self setSelectedIndex:3];

    if (self.selectedIndex == 3) {
        [self setSelectedIndex:0];
    }
         UINavigationController *nav = (UINavigationController *)self.viewControllers[3];
    if (nav) [nav popToRootViewControllerAnimated:YES];
    
}

- (void)userHadLoged{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OSCMotionManager shareMotionManager].isShaking = NO;
         [OSCMotionManager shareMotionManager].canShake = [[UserManager shareManager].user.shake_status integerValue] == 1;
    });
    
    
    if (!Nilstr2Space([UserManager shareManager].user.platcust).length || [Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JLDActAlertView shareManager] showAlertType:BankShowType toView:[UIApplication sharedApplication].windows.firstObject];
            });
        });
        
        UINavigationController *nav = (UINavigationController *)self.selectedViewController;
//        __weak typeof(self) weakSelf = self;
        [JLDActAlertView shareManager].cancelBtnBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                BankGiftImageView *bankView = [BankGiftImageView shareManage];
//                bankView.hidden = NO;
//                bankView.frame = CGRectMake(K_WIDTH - ChangedHeight(70), K_HEIGHT - ChangedHeight(164), ChangedHeight(45), ChangedHeight(49));
//                [bankView.giftImage startAnimating];
//                    [window addSubview:bankView];
//                });
            });
        };
        
        [JLDActAlertView shareManager].confirmBtnBlock = ^{
//            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
//            BankGiftImageView *bankView = [BankGiftImageView shareManage];
//            bankView.hidden = YES;
//            [bankView.giftImage stopAnimating];
//            bankView.frame = CGRectMake(K_WIDTH - ChangedHeight(70), K_HEIGHT - ChangedHeight(164), ChangedHeight(45), ChangedHeight(49));
//            [window addSubview:bankView];
            ManageOfBankVc *vc = [[ManageOfBankVc alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            
        };
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//添加中间按钮（根据需求变动）
-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height);
    
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setImage:buttonImage  forState:UIControlStateNormal];
    [_centerButton setImage:[UIImage imageNamed:@"ic_nav_add_actived"] forState:UIControlStateHighlighted];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}

- (void)buttonPressed
{
    [self setSelectedIndex:2];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UINavigationController *)creatNavWithVc:(NSString *)vcName{
    UIViewController *vc= [[NSClassFromString(vcName) alloc]init];
    JLDNavigationController *navC = [[JLDNavigationController alloc]initWithRootViewController:vc];
    return navC;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (1 == [tabBar.items indexOfObject:item]) {
        SecondVc *listVc = (SecondVc *)((UINavigationController *)self.viewControllers[1]).viewControllers[0];
        [listVc reloadListData];
    }
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (3 == [self.tabBar.items indexOfObject:viewController.tabBarItem]) {
        if (![UserManager shareManager].user) {
            UIViewController *vc = [[NSClassFromString(@"LogingVc") alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
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
