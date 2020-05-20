//
//  AlicloudHAProvider.h
//  AlicloudHAUtil
//
//  Created by sky on 2019/10/9.
//  Copyright © 2019 emas. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALICLOUDHAUTIL_VERSION @"1.0.1"

NS_ASSUME_NONNULL_BEGIN

@interface AlicloudHAProvider : NSObject

/*!
 * @brief 启动AppMonitor服务
 * @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
 */
+ (void)start;

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
