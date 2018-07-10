//
//  ASPickerView.h
//  astro
//
//  Created by kjubo on 14-7-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASPickerView;
@protocol ASPickerViewDelegate <NSObject>
@optional
- (void)asPickerViewDidSelected:(ASPickerView *)picker;
- (void)asPickerViewDidCancel:(ASPickerView *)picker;
@end

@interface ASPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) UIViewController *parentVc;
@property (nonatomic, assign) id<ASPickerViewDelegate> delegate;
@property (nonatomic, assign) id trigger;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic) UIDatePickerMode datePickerMode;

- (id)initWithParentViewController:(UIViewController *)vc;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)showPickerView;
- (void)hidePickerView;
- (void)setDataSource:(NSArray *)data selected:(id)selected;
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode selected:(NSDate *)date;
- (NSDate *)pickerDate;
@end
