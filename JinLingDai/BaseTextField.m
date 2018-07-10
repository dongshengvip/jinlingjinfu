//
//  BaseTextField.m
//  JinLingDai
//
//  Created by 001 on 2017/7/8.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible=NO;
        
    }
    
    return NO;
    
}
@end
