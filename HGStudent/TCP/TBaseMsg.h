//
//  TBaseMsg.h
//  HGStudent
//
//  Created by DoronXC on 2019/5/17.
//  Copyright © 2019年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBaseMsg : NSObject

/**
 * 消息对应的字节流
 */
@property(nonatomic, copy) NSString *msgBytesString;
/**
 * 消息版本号
 */
@property(nonatomic, copy) NSString *version;
/**
 * 消息id
 */
@property(nonatomic, copy) NSString *msgId;
/**
 * 终端编号
 */
@property(nonatomic, copy) NSString *devno;
/**
 * 消息流水号
 */
@property(nonatomic, copy) NSString *serialNo;
/**
 * 报文头长度
 */
@property(nonatomic, copy) NSString *headLength;
/**
 * 报文体长度
 */
@property(nonatomic, copy) NSString *bodyLength;

@end

NS_ASSUME_NONNULL_END
