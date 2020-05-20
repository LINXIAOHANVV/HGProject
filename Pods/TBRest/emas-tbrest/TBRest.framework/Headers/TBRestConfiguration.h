//
//  TBRestConfiguration.h
//  TBRest
//
//  Created by qiulibin on 16/11/12.
//  Copyright © 2016年 Taobao lnc. All rights reserved.
//

#ifndef TBRestConfiguration_h
#define TBRestConfiguration_h


#import <Foundation/Foundation.h>

//用于返回追加的保留字段信息
@protocol TBRestReservesProviderProtocol <NSObject>

- (NSDictionary<NSString*, NSString*>*)reserveInfoDictionary;

@end

@interface TBRestConfiguration : NSObject

@property(nonatomic, copy) NSString * channel;
@property(nonatomic, copy) NSString * appkey;
@property(nonatomic, copy) NSString * secret;
@property(nonatomic, copy) NSString * userId;
@property(nonatomic, copy) NSString * usernick;
@property(nonatomic, copy) NSString * appVersion;
@property(nonatomic, copy) NSString * country;
@property(nonatomic, copy) NSString * dataUploadScheme;     // http or https
@property(nonatomic, copy) NSString * dataUploadHost;       // data upload host

@end

#endif /* TBRestConfiguration_h */
