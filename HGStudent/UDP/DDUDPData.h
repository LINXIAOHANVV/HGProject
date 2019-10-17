//
//  DDUDPData.h
//  Doron
//
//  Created by DoronXC on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DDUDPDataType_HeartRequest = 101,//心跳请求
    DDUDPDataType_HeartResult = 102,//心跳结果
    DDUDPDataType_StartUploadMessage = 103,//开始上传数据
    DDUDPDataType_StopUploadMessage = 105,//结束上传数据
    DDUDPDataType_UploadingMessage = 11,//实时上传坐标信息
}DDUDPDataType;

@interface DDUDPData : NSObject

@property (nonatomic,assign)DDUDPDataType   eventTpyeId;//消息类型编号       传入时不为空
@property (nonatomic,assign)int             MessageNo;//消息流水号 自增      传入时不为空
@property (nonatomic,assign)long            schoolId;//分校编号             传入时不为空
@property (nonatomic,assign)long            carNo;//设备编号               传入时不为空
@property (nonatomic,assign)int             trainingStatus;//训练状态      传入时不为空
@property (nonatomic,assign)long            studentId;//学员号             传入时不为空
@property (nonatomic,assign)NSInteger       resultCode;//结果 1.成功 2.失败
@property (nonatomic,assign)long            cocoaId;//教练号
@property (nonatomic,assign)int             trainingType;//训练类型 值范围1-255 0、未训练；2、科目二；3、科目三。
@property (nonatomic,assign)long            trainingStartTime;//训练开始时间
@property (nonatomic,assign)int             speed;//速度
@property (nonatomic,assign)long            longitude;//经度
@property (nonatomic,assign)long            latitude;//纬度
@property (nonatomic,assign)int             headingAngle;//航向角
@property (nonatomic,assign)int             pitchAngle;//俯仰角
@property (nonatomic,assign)long            altitude;//高程


- (NSData*)encodingData;

+ (NSDictionary*)decodingOfData:(NSData*)data;

@end
