//
//  UserInfoVc.m
//  JinLingDai
//
//  Created by 001 on 2017/7/4.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "UserInfoVc.h"
#import "MBProgressHUD+NetWork.h"
#import "UserManager.h"
#import "UIView+Radius.h"
#import "XiuGaiCartVc.h"
#import "ManageOfBankVc.h"
#import <AFNetworking.h>
#import <YYKit.h>
#import "FengXianRistVc.h"
#import "RistResultVc.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define TitleArr @[@[@"头像", @"用户名", @"手机号"], @[@"真实姓名",@"身份证号", @"银行卡", @"风险测评"]]
@interface UserInfoVc ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UIImageView *userLogo;
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) UIImage *imge;
@end

@implementation UserInfoVc

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBlackColor];
    
    self.myTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    self.myTab.estimatedSectionHeaderHeight = 0;
    self.myTab.estimatedSectionFooterHeight = 0;
    self.myTab.sectionFooterHeight = ChangedHeight(2);
    self.myTab.rowHeight = ChangedHeight(46);
//    [self.myTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    
    [self.view addSubview:self.self.myTab];
    [self.myTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.model = [UserManager shareManager].user;
    self.userLogo = [[UIImageView alloc]init];
    self.userLogo.userInteractionEnabled = YES;
    [self.userLogo addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setUserHeadImage)]];
    self.userLogo.bounds = CGRectMake(0, 0, ChangedHeight(37), ChangedHeight(37));
    [self.userLogo sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.userLogo setCornerRadiusAdvance:CGRectGetWidth(self.userLogo.bounds)/2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(riskHadRefresh) name:@"riskHadRefresh" object:nil];
}

- (void)riskHadRefresh{
//    [super viewWillAppear:animated];
    self.model = [UserManager shareManager].user;
    [self.myTab reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return TitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TitleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return ChangedHeight(25);
    }
    return ChangedHeight(5);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 1) {
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor tipTextColor];
        lab.font = [UIFont gs_fontNum:13];
        lab.text = @"务必填写真实数据，验证通过后数据不可更改";
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 10, 0, 0));
        }];
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userCell"];
         [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor getColor:84 G:85 B:86];
        
        cell.detailTextLabel.textColor = [UIColor getColor:84 G:85 B:86];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = TitleArr[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 0) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = self.model.username;
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = @"";
                [cell.contentView addSubview:self.userLogo];
                [self.userLogo mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.contentView).offset(ChangedHeight(- 2));
                    make.size.mas_equalTo(self.userLogo.bounds.size);
                }];
            }
        }else if (indexPath.row == 2){
            cell.accessoryType = [Nilstr2Zero(self.model.tel) integerValue] != 0?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
//        }else{
            cell.detailTextLabel.text = [Nilstr2Zero(self.model.tel) integerValue] != 0?self.model.tel:@"去绑定手机号";
        }
    }else{
        if (indexPath.row == 0) {
            cell.accessoryType = [self.model.is_verify integerValue] == 1?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [self.model.is_verify integerValue] == 1?self.model.real_name:@"去实名";
            
        }else if(indexPath.row == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 0) {
                cell.detailTextLabel.text = @"去绑卡";
            }else{
                if([Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 3){
                    cell.detailTextLabel.text = @"在审核";
                }else if( [Nilstr2Zero([UserManager shareManager].user.bind_status) integerValue] == 1 && self.model.bank_data.count){
                    bankModel *bank = self.model.bank_data[0];
                    cell.detailTextLabel.text = bank.bankNumText;
                }
                
            }
            
        }else if(indexPath.row == 1){
            cell.accessoryType = [self.model.is_verify integerValue] == 1?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [self.model.is_verify integerValue] == 1?self.model.getIdCartString:@"去实名";
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = Nilstr2Space(self.model.risk_level);// [self.model.risk_level isEqualToString:@"未测评"] ? @""
        }
        
    }
    
    
    return cell;
}

- (void)setUserHeadImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertCtlPhoto = [UIAlertController alertControllerWithTitle:@"选择获取图片等方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertCtlPhoto addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIAlertController *alertCtlCam = [UIAlertController alertControllerWithTitle:@"出错了" message:@"设备没有照相机" preferredStyle:UIAlertControllerStyleAlert];
                [alertCtlCam addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }]];
                          
                [self presentViewController:alertCtlCam animated:YES completion:nil];
                
            } else {
                UIImagePickerController *imagePickerController = [UIImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.showsCameraControls = YES;
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
                
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }]];
        [alertCtlPhoto addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertCtlPhoto addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }]];
        
        [self presentViewController:alertCtlPhoto animated:YES completion:nil];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 1 ) {
            
        }else if (indexPath.row == 2){
            if (!Nilstr2Space(self.model.platcust).length) {
                ManageOfBankVc *vc = [[ManageOfBankVc alloc]init];
                vc.BangcartBlock = ^(BOOL succ) {
                    weakSelf.model = [UserManager shareManager].user;
                    [weakSelf.myTab reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else if (Nilstr2Space(self.model.tel).length == 0){
                UIViewController *vc = [[NSClassFromString(@"CheckUserIDVc") alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        if (indexPath.row <= 1) {
            if (![self.model.is_verify integerValue]) {
                ManageOfBankVc *vc = [[ManageOfBankVc alloc]init];
                vc.BangcartBlock = ^(BOOL succ) {
                    weakSelf.model = [UserManager shareManager].user;
                    [weakSelf.myTab reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if(indexPath.row == 2){
//            if (![[UserManager shareManager] canExtractMoney]) {
//                return;
//            }
            if ([Nilstr2Zero(self.model.bind_status) integerValue] == 1) {
                //会员已经绑定卡yes
                XiuGaiCartVc *vc = [[XiuGaiCartVc alloc]init];
                vc.JieBangCartBlock = ^(BOOL succ) {
                    weakSelf.model = [UserManager shareManager].user;
                    [weakSelf.myTab reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([Nilstr2Zero(self.model.bind_status) integerValue] == 0){
                ManageOfBankVc *vc = [[ManageOfBankVc alloc]init];
                vc.BangcartBlock = ^(BOOL succ) {
                    weakSelf.model = [UserManager shareManager].user;
                    [weakSelf.myTab reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            if([self.model.risk_level isEqualToString:@"未测评"]){
                if ([[UserManager shareManager] canExtractMoney]) {
                    NSString *postUrl ;
                    kAppPostHost(postUrl);
                    FengXianRistVc *vc = [[FengXianRistVc alloc]init];
                    vc.title = @"风险测评";
                    vc.H5Url = [NSString stringWithFormat:@"%@page/dangerquestion?src=%@",postUrl,self.model.uid];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                RistResultVc *vc = [[RistResultVc alloc]init];
//                vc.title = @"风险测评";
//                vc.H5Url = [NSString stringWithFormat:@"%@page/dangerquestion?src=%@",kAppPostHost,self.model.uid];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        }
        
        
        
    }
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imge = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^ {
        [self updatePortrait];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)updatePortrait{
    NSString *postUrl ;
    kAppPostHost(postUrl);
    [NetworkManager updatePortraitImag:self.imge
                             url:[NSString stringWithFormat:@"%@user/changepic",postUrl]
                              mdic:@{@"token":[UserManager shareManager].userId}
                              name:@"image"
                              fileName:@"hedimg.png"
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   if ([responseObject[@"status"] integerValue] == 200) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.userLogo.image = self.imge;
                                           self.model.head = responseObject[@"data"][@"picurl"];
                                           [[UserManager shareManager] saveUserModel:self.model];
                                           [MBProgressHUD showSuccess:@"上传成功"];
                                       });
                                   }
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {

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
