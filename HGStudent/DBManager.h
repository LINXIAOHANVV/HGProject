//
//  DBUtils.h
//  DoronTrainee
//
//  Created by DoronXC on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (instancetype)shareManager;

- (void)dbSuccess:(void (^)(NSMutableArray * results))successBlock;

//- (void)saveStatuses:(NSArray *)array;

- (void)insertData:(NSArray *)array useTransaction:(BOOL)useTransaction;
//
//- (void)delStatuses:(HGNewsModel *)newsModel;

//- (void)del;

@end
