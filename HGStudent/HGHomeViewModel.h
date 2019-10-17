//
//  HGHomeViewModel.h
//  HGStudent
//
//  Created by DoronXC on 2019/2/18.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "BaseViewModel.h"
#import "HGHomeModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface HGHomeViewModel : BaseViewModel

@property(nonatomic, strong) HGHomeModel *hgModel;
@property(nonatomic, strong) RACSubject *successObject;
@property(nonatomic, strong) RACSubject *failureObject;

- (void)exchangeData;

@end
