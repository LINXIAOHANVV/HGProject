//
//  AlicloudCrashProvider.h
//  AlicloudCrash
//
//  Created by sky on 2019/10/7.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALICLOUDCRASH_VERSION @"1.1.1"

NS_ASSUME_NONNULL_BEGIN

@interface AlicloudCrashProvider : NSObject

/*!
 * @brief 崩溃分析始化接口（自动读取appKey、appSecret）
 * @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
 * @param appVersion app版本，会上报
 * @param channel 渠道标记，自定义，会上报
 * @param nick 昵称，自定义，会上报
 */
- (void)autoInitWithAppVersion:(NSString *)appVersion
                       channel:(NSString *)channel
                          nick:(NSString *)nick;

/*!
 * @brief 崩溃分析初始化接口
 * @details 崩溃分析初始化接口
 * @param appKey appKey,可从控制台或AliyunEmasServices-Info.plist获取
 * @param secret appSecret,可从控制台或AliyunEmasServices-Info.plist获取
 * @param appVersion app版本
 * @param channel 渠道标记，自定义
 * @param nick 昵称，自定义，会上报
 */
- (void)initWithAppKey:(NSString *)appKey
                secret:(NSString *)secret
            appVersion:(NSString *)appVersion
               channel:(NSString *)channel
                  nick:(NSString *)nick;

/*!
* @brief 更新usernick
* @param nick 昵称，自定义，会上报
*/
+ (void)updateNick:(NSString *)nick;

/*!
* @brief 更新appVersion
* @param appVersion 版本号，自定义，会上报
*/
+ (void)updateAppVersion:(NSString *)appVersion;


@end

NS_ASSUME_NONNULL_END
