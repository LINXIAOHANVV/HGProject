//
//  HGHomeModel.h
//  HGStudent
//
//  Created by DoronXC on 2019/2/18.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "BaseModel.h"

@interface HGHomeModel : BaseModel

typedef void(^Success)(HGHomeModel *model);
typedef void(^Failure)(HGHomeModel *model);

@property (nonatomic, strong) NSObject *data;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger code;

-(void)getDataSuccess:(Success)success AndFailure:(Failure)failure;

@end
