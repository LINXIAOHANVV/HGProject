//
//  AlicloudHALogManager.h
//  AliHAAdapter4Cloud
//
//  Created by sky on 2019/7/23.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface ALCLogManager : NSObject

@property (nonatomic, copy) NSString *bizId;

+ (instancetype)sharedManager;

- (void)addBizId:(NSString *)bizId;

// 进入后台打点
- (void)clickSwitchToBackgroundPoint;

// 添加一个时间戳到本地持久化文件
- (void)addLog:(NSString *)timeStampStr;

// 返回未上传的日志
- (NSString *)unUploadTimeStamp;

// 清空本地保存的时间戳
- (void)clearTimeStamps;

// 只保留最近N条日志
- (NSString *)filterLog:(NSString *)timeStamps count:(int)count;

// 更新缓存
- (void)updateCache:(NSString *)startUps;

// 上传日志
- (void)uploadLog;

@end

NS_ASSUME_NONNULL_END
