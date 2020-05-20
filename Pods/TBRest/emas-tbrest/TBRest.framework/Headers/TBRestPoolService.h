//
//  TBRestPoolService.h
//  TBRest
//
//  Created by hansong.lhs on 2019/1/8.
//  Copyright © 2019 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBRestPoolService : NSObject

/**
 * init pool service with request count limit
 */
- (instancetype)initWithRequestCountLimit:(NSInteger)requestCountLimit eventId:(int)eventId;

/**
 * init pool service with size(in bytes) limit
 */
- (instancetype)initWithRequestSizeLimit:(NSInteger)sizeLimit eventId:(int)eventId;

/**
 * send log with pool service
 */
- (void)sendLog:(NSObject*)aPageName arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;

/**
 * send all log and clean request pool
 */
- (void)clean;


@end

NS_ASSUME_NONNULL_END
