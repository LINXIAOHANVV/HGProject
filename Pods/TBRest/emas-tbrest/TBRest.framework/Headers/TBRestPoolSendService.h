//
//  TBRestPoolSendService.h
//  TBRest
//
//  Created by hansong.lhs on 2019/1/10.
//  Copyright © 2019 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBRestPoolSendService : NSObject

+ (TBRestPoolSendService*)sharedInstance;

- (void)initPool;

/**
 * add pool config with eventId and request count limit
 * note: thread-safe
 */
- (void)addPoolConfig:(int)eventId requestCountLimit:(int)requestCountLimit;

/**
 * add pool config with eventId and request size limit
 * note: thread-safe
 */
- (void)addPoolConfig:(int)eventId requestSizeLimit:(int)requestSizeLimit;

/**
 *
 * send log with pool service
 */
- (void)sendLog:(NSString*)page eventId:(int)eventId arg1:(NSString*)arg1 arg2:(NSString*)arg2 arg3:(NSString*)arg3 args:(NSDictionary*)args;

/**
 * upload and clean all data in pool
 */
- (void)clean;

@end

NS_ASSUME_NONNULL_END
