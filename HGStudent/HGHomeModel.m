//
//  HGHomeModel.m
//  HGStudent
//
//  Created by DoronXC on 2019/2/18.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "HGHomeModel.h"

@implementation HGHomeModel
- (void)getDataSuccess:(Success)success AndFailure:(Failure)failure {
    NSArray  *result =@[@{@"title":@"我是谁",
                          @"tag":@1,
                          },
                        @{@"title":@"我从哪来",
                          @"img":@2,
                          },
                        @{@"title":@"要到哪去",
                          @"img":@3,
                          }];
    HGHomeModel *hgModel = [[HGHomeModel alloc] init];
    if (result.count > 0) {
        hgModel.code = 1;
        hgModel.message = @"成功";
        hgModel.data = result;
        success(hgModel);
    }else {
        hgModel.code = 0;
        hgModel.message = @"失败";
        hgModel.data = result;
        failure(hgModel);
    }
}

@end
