//
//  HGHomeViewModel.m
//  HGStudent
//
//  Created by DoronXC on 2019/2/18.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "HGHomeViewModel.h"

@implementation HGHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initRACSub];
    }
    return self;
}
- (void)initRACSub {
    self.successObject = [RACSubject subject];
    self.failureObject = [RACSubject subject];
    self.hgModel = [[HGHomeModel alloc] init];
}

- (void)exchangeData {
    [self.hgModel getDataSuccess:^(HGHomeModel *model) {
        NSLog(@"Success======%@",model);
        [self.successObject sendNext:model];
    } AndFailure:^(HGHomeModel *model) {
        NSLog(@"Failure======%@",model);
        [self.failureObject sendNext:model];
    }];
}

@end
