//
//  ShakeImageVC.m
//  JinLingDai
//
//  Created by 001 on 2017/10/13.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "ShakeImageVC.h"
#import <YYKit.h>
#import "UIViewController+BackButtonHandler.h"
#import "OSCMotionManager.h"
#import "LXFDrawBoard.h"
#import "FeedBackVc.h"
@interface ShakeImageVC ()<LXFDrawBoardDelegate>
@property (nonnull, strong) LXFDrawBoard *board;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation ShakeImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setNavBlackColor];

    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_board) {
            return ;
        }
        _board = [[LXFDrawBoard alloc]initWithImage:self.shakeImage];
        _board.delegate = self;
//        UIImageView *img = [[UIImageView alloc] init];
//        img.image = self.shakeImage;
        _board.layer.borderWidth = 1;
        _board.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.view addSubview:_board];
        [_board mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(self.view).offset(-ChangedHeight(80));
            make.height.equalTo(_board.mas_width).multipliedBy(self.shakeImage.size.height/self.shakeImage.size.width);
        }];
        
        [_board.superview layoutIfNeeded];
        self.board.brush = [LXFPencilBrush new];
        self.board.style.lineWidth = 2;
        
        [self.view addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.height.mas_equalTo(ChangedHeight(40));
            make.width.mas_equalTo(ChangedHeight(80));
            make.bottom.equalTo(self.view).offset(ChangedHeight(-10));
        }];
        
        [self.view addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.height.mas_equalTo(ChangedHeight(40));
            make.width.mas_equalTo(ChangedHeight(80));
            make.bottom.equalTo(self.view).offset(ChangedHeight(-10));
        }];
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)navigationShouldPopOnBackButton{
//    [OSCMotionManager shareMotionManager].isShaking = NO;
//    [[OSCMotionManager shareMotionManager] setCanShake:[UserManager shareManager].user.shakeOn];
//    return YES;
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [OSCMotionManager shareMotionManager].isShaking = NO;
     [OSCMotionManager shareMotionManager].canShake = [[UserManager shareManager].user.shake_status integerValue] == 1;
}

- (void)touchesEndedWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
    self.cancelBtn.selected = [self.board canRevoke];
}
- (UIButton *)cancelBtn {
   if (!_cancelBtn) {
       _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _cancelBtn.titleLabel.font = [UIFont gs_fontNum:15];
       [_cancelBtn setImage:[UIImage imageNamed:@"撤销"] forState:UIControlStateNormal];
       [_cancelBtn setImage:[UIImage imageNamed:@"撤销_can"] forState:UIControlStateSelected];
       [_cancelBtn setTitle:@"重画" forState:UIControlStateNormal];
       [_cancelBtn setTitleColor:[UIColor newSecondTextColor] forState:UIControlStateNormal];
       [_cancelBtn setTitleColor:[UIColor getOrangeColor] forState:UIControlStateSelected];
       [_cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
       [_cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
       [_cancelBtn addTarget:self action:@selector(cancelDrow:) forControlEvents:UIControlEventTouchUpInside];
   }
   return _cancelBtn;
}

- (void)cancelDrow:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.board canRevoke]) {
         [self.board revoke];
    }
}
- (UIButton *)confirmBtn {
   if (!_confirmBtn) {
       _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _confirmBtn.titleLabel.font = [UIFont gs_fontNum:15];
       [_confirmBtn setImage:[UIImage imageNamed:@"写作"] forState:UIControlStateNormal];
       [_confirmBtn setTitle:@"写反馈" forState:UIControlStateNormal];
       [_confirmBtn setTitleColor:[UIColor getOrangeColor] forState:UIControlStateNormal];
       [_confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
       [_confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
       [_confirmBtn addTarget:self action:@selector(confirmFadBack) forControlEvents:UIControlEventTouchUpInside];
   }
   return _confirmBtn;
}
- (void)confirmFadBack{
//    self.board.image
    FeedBackVc *vc = [[FeedBackVc alloc]init];
    vc.shakeImage = self.board.image;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
