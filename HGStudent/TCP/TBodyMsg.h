//
//  TBodyMsg.h
//  HGStudent
//
//  Created by DoronXC on 2019/6/12.
//  Copyright © 2019年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TDeviceStatusMsg;
@class TItemStatussMsg;

NS_ASSUME_NONNULL_BEGIN

@interface TBodyMsg : NSObject

/**
 * 训练类型:第一位代表：科目类型：0、未训练；2、科目二；3、科目三
 */
@property(nonatomic, copy) NSString *subjectType;
/**
 * 学员ID
 */
@property(nonatomic, copy) NSString *studentId;
/**
 * 训练开始时间
 */
@property(nonatomic, copy) NSString *startTime;
/**
 * 设备信号状态
 */
@property(nonatomic, strong) TDeviceStatusMsg *deviceStatus;
/**
 * 项目状态
 */
@property(nonatomic, strong) TItemStatussMsg *itemStatus;
/**
 * 速度
 */
@property(nonatomic, copy) NSString *speed;
/**
 * 发动机转速
 */
@property(nonatomic, copy) NSString *deviceSpeed;
/**
 * GPS经度
 */
@property(nonatomic, copy) NSString *longitude;
/**
 * GPS纬度
 */
@property(nonatomic, copy) NSString *latitude;
/**
 * 航向角
 */
@property(nonatomic, copy) NSString *headAngle;
/**
 * 俯仰角
 */
@property(nonatomic, copy) NSString *elevationAngle;
/**
 * 方向盘转角
 */
@property(nonatomic, copy) NSString *wheelAngle;
/**
 * 海拔高度
 */
@property(nonatomic, copy) NSString *altitude;
/**
 * 当前行驶距离
 */
@property(nonatomic, copy) NSString *drivingDistance;
/**
 * 子项目编号
 */
@property(nonatomic, copy) NSString *itemCode;
/**
 * 基准GPS经度
 */
@property(nonatomic, copy) NSString *markLongitude;
/**
 * 基准GPS纬度
 */
@property(nonatomic, copy) NSString *markLatitude;
/**
 * 扣分项数量
 */
@property(nonatomic, copy) NSString *errorNum;
/**
 * n个扣分项序号
 */
@property(nonatomic, copy) NSString *errorCode;

@end

@interface TDeviceStatusMsg : NSObject

@property(nonatomic, copy) NSString *bit0;
@property(nonatomic, copy) NSString *bit1;
@property(nonatomic, copy) NSString *bit2;
@property(nonatomic, copy) NSString *bit3;
@property(nonatomic, copy) NSString *bit4;
@property(nonatomic, copy) NSString *bit5;
@property(nonatomic, copy) NSString *bit6;
@property(nonatomic, copy) NSString *bit7;
@property(nonatomic, copy) NSString *bit8;
@property(nonatomic, copy) NSString *bit9;
@property(nonatomic, copy) NSString *bit10;
@property(nonatomic, copy) NSString *bit11;
@property(nonatomic, copy) NSString *bit12;
@property(nonatomic, copy) NSString *bit13;
@property(nonatomic, copy) NSString *bit14;
@property(nonatomic, copy) NSString *bit15;
@property(nonatomic, copy) NSString *bit16;
@property(nonatomic, copy) NSString *bit17;
@property(nonatomic, copy) NSString *bit18;
@property(nonatomic, copy) NSString *bit19;
@property(nonatomic, copy) NSString *bit20;
@property(nonatomic, copy) NSString *bit21;
@property(nonatomic, copy) NSString *bit22;
@property(nonatomic, copy) NSString *bit23;

@end

@interface TItemStatussMsg : NSObject

@property(nonatomic, copy) NSString *bit01;
@property(nonatomic, copy) NSString *bit23;
@property(nonatomic, copy) NSString *bit45;
@property(nonatomic, copy) NSString *bit67;
@property(nonatomic, copy) NSString *bit89;
@property(nonatomic, copy) NSString *bit1011;
@property(nonatomic, copy) NSString *bit1213;
@property(nonatomic, copy) NSString *bit1415;
@property(nonatomic, copy) NSString *bit1617;
@property(nonatomic, copy) NSString *bit1819;
@property(nonatomic, copy) NSString *bit2021;
@property(nonatomic, copy) NSString *bit2223;
@property(nonatomic, copy) NSString *bit2425;
@property(nonatomic, copy) NSString *bit2627;
@property(nonatomic, copy) NSString *bit2829;
@property(nonatomic, copy) NSString *bit3031;
@property(nonatomic, copy) NSString *bit3233;
@property(nonatomic, copy) NSString *bit3435;
@property(nonatomic, copy) NSString *bit3637;
@property(nonatomic, copy) NSString *bit3839;

@end
NS_ASSUME_NONNULL_END
