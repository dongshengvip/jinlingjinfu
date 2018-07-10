//
//  FeedBackVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "FeedBackVc.h"

#import "PlaceholderTextView.h"
#import "MBProgressHUD+NetWork.h"
@interface FeedBackVc ()<UITextViewDelegate>
@property (nonatomic, strong) PlaceholderTextView *conemtText;
@property (nonatomic, strong) UIView *coveView;
@property (nonatomic, strong) UIImageView *bordImag;
@property (nonatomic, strong) UIView *TexgtBgView;
@end

@implementation FeedBackVc

- (void)goBack{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    [self setNavBlackColor];
    self.title = @"意见反馈";
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *helperView = [UIView new];
    [scroll addSubview:helperView];
    [helperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-StatusBarHeight - 44);
    }];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [UIColor borderColor].CGColor;
    bgView.layer.cornerRadius = 6;
    [helperView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helperView).offset(ChangedHeight(18));
        make.right.equalTo(helperView).offset(ChangedHeight(- 18));
        make.top.equalTo(helperView).offset(ChangedHeight(5));
    }];
    _TexgtBgView = bgView;
    self.conemtText = [[PlaceholderTextView alloc]init];
    
    self.conemtText.placeholder = @"您的反馈将是我们前进的最大动力";
    
    self.conemtText.font = [UIFont gs_fontNum:15];
    
    [self.TexgtBgView addSubview:self.conemtText];
    [self.conemtText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.height.mas_equalTo(ChangedHeight(150));
//        make.top.equalTo(bgView).offset(ChangedHeight(5));
    }];
    
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont gs_fontNum:15];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor getOrangeColor];
    [helperView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helperView).offset(ChangedHeight(35));
        make.right.equalTo(helperView).offset(ChangedHeight(- 35));
        make.height.mas_equalTo(ChangedHeight(40));
        make.top.equalTo(self.TexgtBgView.mas_bottom).offset(ChangedHeight(80));
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.shakeImage && !_bordImag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bordImag = [[UIImageView alloc]initWithImage:self.shakeImage];
            [_TexgtBgView addSubview:self.bordImag];
            [self.bordImag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_TexgtBgView).offset(ChangedHeight(2));
                make.top.equalTo(self.conemtText.mas_bottom).offset(ChangedHeight(4));
                make.width.equalTo(_TexgtBgView).dividedBy(3.0);
                make.height.equalTo(self.bordImag.mas_width).multipliedBy(self.shakeImage.size.height/self.shakeImage.size.width);
                make.bottom.equalTo(_TexgtBgView).offset(ChangedHeight(-4));
            }];
//            [_TexgtBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(ChangedHeight(200) + self.shakeImage.size.height/self.shakeImage.size.width * );
//            }];
        });
        
    }else if(!self.shakeImage){
        [_TexgtBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ChangedHeight(200));
        }];
    }
}
- (void)rechargeMoney{
    if (!self.conemtText.text.length) {
        [MBProgressHUD showError:@"请输入反馈信息"];
        return;
    }
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager updatePortraitImag:self.shakeImage
               url:[NSString stringWithFormat:@"%@app/feedback",postUrl]
              mdic:@{
                     @"feedbackfiles":[NSString stringWithFormat:@"img%@",[[NSUUID UUID] UUIDString]],//上传文件
                     @"message":self.conemtText.text,//    反馈内容    string
                     @"system":@"ios",//    终端    string
                     @"token":[UserManager shareManager].userId  //    用户ID    number
                     }
              name:[NSString stringWithFormat:@"img%@",[[NSUUID UUID] UUIDString]]
          fileName:@"hedimg.png"
           success:^(NSURLSessionDataTask *task, id responseObject) {
               if ([responseObject[@"status"] integerValue] == 200) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [MBProgressHUD showSuccess:responseObject[@"message"]];
                       self.conemtText.text = @"";
                       if (self.shakeImage) {
                           NSMutableArray *viewsArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                           [viewsArr removeLastObject];
                           [viewsArr removeLastObject];
                           [self.navigationController setViewControllers:viewsArr animated:YES];
                       }else
                            [self.navigationController popViewControllerAnimated:YES];
                   });
                   //
               }
           }
           failure:^(NSURLSessionDataTask *task, NSError *error) {
               
           }];

    
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
