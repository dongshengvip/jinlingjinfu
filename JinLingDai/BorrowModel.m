//
//  BorrowModel.m
//  JinLingDai
//
//  Created by 001 on 2017/7/18.
//  Copyright © 2017年 JLD. All rights reserved.
//

#import "BorrowModel.h"

@implementation BorrowModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [ListModel class],
             @"nlist" : [ListModel class],
             };
}
- (NSArray<ListModel *> *)list{
    if (!_list) {
        return @[];
    }
    return _list;
}
@end

@implementation ListModel
- (NSString *)id{
    if([Nilstr2Zero(_id) integerValue] == 0){
        return self.borrow_id;
    }
    return _id;
}


@end
