//
//  TcpData.m
//  HGStudent
//
//  Created by DoronXC on 2019/5/8.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "TcpData.h"
#import "TBaseMsg.h"
#import "TBodyMsg.h"

@implementation TcpData

#pragma mark encodingData
#pragma mark
- (NSData*)encodingData
{
    // 订阅实时坐标数据组装
    // 消息结构：标识位+消息头+消息体+标识位
    // 标识位
    NSData *bsw = [TcpData ByteToNSData:0x7e];
    NSData *head = [self messageHead];
//    NSData *headCode = [self verificationCode:head];
    NSData *body = [self messageBody];
//    NSData *bodyCode = [self verificationCode:body];
//    NSData *end  = [self messageEnd];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:bsw];
    [data appendData:head];
//    [data appendData:headCode];
    [data appendData:body];
//    [data appendData:bodyCode];
    [data appendData:bsw];
    
    NSLog(@"标识位：%@--%d",bsw,bsw.length);
    NSLog(@"消息头：%@--%d",head,head.length);
//    NSLog(@"headCode：%@--%d",headCode,headCode.length);
    NSLog(@"消息体：%@--%d",body,body.length);
//    NSLog(@"bodyCode：%@--%d",bodyCode,bodyCode.length);
    return data;
}

- (NSData *)messageHead
{
    // 协议版本号
    NSData *data1 = [TcpData  ByteToNSData:0x00];
    // 消息ID
    NSData *data2 = [self messageEnd:0x01 with:0x13];
    // 消息体长度
    NSData *data3 = [TcpData  IntToNSData:(int)[self messageBody].length];
    // 终端编号长度 = 0，则不存在终端编号
    NSData *data4 = [TcpData  ByteToNSData:0];
    // 终端流水号
    NSData *data5 = [TcpData  IntToNSData:self.messageId++];
    if (self.messageId >= 65515) {
        self.messageId = 0;
    }
    NSMutableData *data = [NSMutableData data];
    [data appendData:data1];
    [data appendData:data2];
    [data appendData:data3];
    [data appendData:data4];
    [data appendData:data5];
    
    return data;
}

- (NSData *)messageBody {
    // 驾校id
    NSData *schoolData = [TcpData IntToNSData:1];
    // 订阅终端
    NSData *clientNum = [TcpData ByteToNSData:1];
    // 终端1编号长度
    NSData *clientLength = [TcpData ByteToNSData:1];
    // 终端1编号
    NSData *clientNo = [@"www.www.www" dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:schoolData];
    [data appendData:clientNum];
    [data appendData:clientLength];
    [data appendData:clientNo];
    NSData *bodyData = [self enVerificationCode:data];
    
    return bodyData;
}

- (NSData *)messageEnd:(char)cr with:(char)lf
{
    NSString *end = [NSString stringWithFormat:@"%c%c",cr,lf];
    NSData *data = [end dataUsingEncoding:NSASCIIStringEncoding];
    return data;
}

#pragma mark decodingOfData
#pragma mark
- (NSDictionary *)decodingOfData:(NSData *)data
{
    // 模拟数据 //Byte 转换成 NSData
    Byte byte[] = {126, 0, 1, 18, 0, 49, 15, 56, 54, 50, 49, 48, 55, 48, 52, 51, 54, 48, 54, 55, 48, 54, 0, 73, 2, 0, 12, 207, 203, 36, 18, 8, 248, 176, 194, 2, 4, 0, 0, 0, 0, 0, 1, 3, 42, 1, 33, 102, 118, 35, 48, 0, 49, 32, 0, 2, 6, 98, 92, 0, 0, 0, 80, 255, 255, 255, 137, 0, 0, 0, 0, 0, 0, 126};
    data = [[NSData alloc] initWithBytes:byte length:74];
    
    NSDictionary *dic = [NSDictionary dictionary];
    NSLog(@"接收到的data====%@，长度 =====%d",data,(int)data.length);
    // 去除标识位
    data = [data subdataWithRange:NSMakeRange(1, data.length -2)];
    
    // 转译还原
    data = [self deVerificationCode:data];
    NSLog(@"去除标识位，转译接收到的data====%@，长度 =====%d",data,(int)data.length);
    
    // 解析报文头
    TBaseMsg *head = [self decodeHead:data];
    if (![head.msgId isEqualToString:@"0112"]) {
        dic = @{@"head":head};
        return dic;
    }
    // 去除报文头长度
    NSData *bodyData = [data subdataWithRange:NSMakeRange([head.headLength integerValue], data.length -[head.headLength integerValue])];
    NSLog(@"去除报文头长度接收到的bodyData====%@，长度 =====%d",bodyData,(int)bodyData.length);
    // 解析报文体
    TBodyMsg *body = [self decodeBody:bodyData];
    
    dic = @{@"head":head,@"body":body};
    
    return dic;
}

// 转译编码
- (NSData *)enVerificationCode:(NSData *)data
{
    NSMutableData *mData = [[NSMutableData alloc] initWithData:data];
    int n = (int)[data length];
    uint8_t *dataByte = (uint8_t*)[data bytes];
    uint8_t b = 0;
    
    for (int i = 0; i < n; i++) {
        b = (uint8_t) (b ^ (uint8_t)dataByte[i]);
        if (b == 0x7e) {
            NSMutableData *sData = [[NSMutableData alloc] init];
            [sData appendData:[TcpData ByteToNSData:0x7d]];
            [sData appendData:[TcpData ByteToNSData:0x02]];
            NSRange rang = {i,1};
            [mData replaceBytesInRange:rang withBytes:[sData bytes]];
        }
        if (b == 0x7d) {
            [mData appendData:[TcpData ByteToNSData:0x01]];
        }
    }
    
    return mData;
}

// 转译解码
- (NSData *)deVerificationCode:(NSData *)data
{
    NSMutableData *mData = [[NSMutableData alloc] initWithData:data];
    int n = (int)[data length];
    uint8_t *dataByte = (uint8_t*)[data bytes];
    uint8_t b = 0;
    uint8_t b1 = 0;
    
    for (int i = 0; i < n; i++) {
        b = (uint8_t) (b ^ (uint8_t)dataByte[i]);
        b1 = (uint8_t) (b1 ^ (uint8_t)dataByte[i + 1]);
        if (b == 0x7d && b1 == 0x02) {
            NSMutableData *sData = [[NSMutableData alloc] init];
            [sData appendData:[TcpData ByteToNSData:0x7e]];
            NSRange rang = {i,2};
            [mData replaceBytesInRange:rang withBytes:[sData bytes]];
        }
        if (b == 0x7d && b1 == 0x01) {
            NSMutableData *sData = [[NSMutableData alloc] init];
            [sData appendData:[TcpData ByteToNSData:0x7d]];
            NSRange rang = {i,1};
            [mData replaceBytesInRange:rang withBytes:[sData bytes]];
        }
    }
    
    return mData;
}

#pragma mark 解码
#pragma mark

- (TBaseMsg *)decodeHead:(NSData *)data {
    TBaseMsg *head = [[TBaseMsg alloc] init];
    if (data.length < 6) {
        return head;
    }
    NSData *versionData = [data subdataWithRange:NSMakeRange(0, 1)];
    NSString *version = [self convertDataToHexStr:versionData];
    
    NSData *msgIdData = [data subdataWithRange:NSMakeRange(1, 2)];
    NSString *msgId = [self convertDataToHexStr:msgIdData];
    
    NSData *msgBodyLengthData = [data subdataWithRange:NSMakeRange(3, 2)];
    NSString *msgBodyLength16 = [self convertDataToHexStr:msgBodyLengthData];
    NSString *msgBodyLength = [self hexToDecimal:msgBodyLength16];
    
    NSData *devNoLengthData = [data subdataWithRange:NSMakeRange(5, 1)];
    NSString *devNoLength16 = [self convertDataToHexStr:devNoLengthData];
    // 16进制转10禁止
    NSString *devNoLength = [self hexToDecimal:devNoLength16];
    
    NSData *devNoData = [data subdataWithRange:NSMakeRange(6, [devNoLength integerValue])];
    NSString *devNo = [self convertDataToHexStr:devNoData];
    
    NSData *serialNoData = [data subdataWithRange:NSMakeRange(6 + [devNoLength integerValue], 2)];
    NSString *serialNo16 = [self convertDataToHexStr:serialNoData];
    // 16进制转10禁止
    NSString *serialNo = [self hexToDecimal:serialNo16];
    
    head.version = version;
    head.msgId = msgId;
    head.devno = devNo;
    head.serialNo = serialNo;
    head.headLength = [NSString stringWithFormat:@"%ld",6 + [devNoLength integerValue] + 2];
    head.bodyLength = msgBodyLength;
    
    return head;
}

- (TBodyMsg *)decodeBody:(NSData *)data {
    
    TBodyMsg *body = [[TBodyMsg alloc] init];
    if (data.length < 49) {
        return body;
    }
    
    NSData *subjectTypeData = [data subdataWithRange:NSMakeRange(0, 1)];
    NSString *subjectType16 = [self convertDataToHexStr:subjectTypeData];
    // 16进制转10进制
    NSString *subjectType= [self hexToDecimal:subjectType16];
    
    NSData *studentIdData = [data subdataWithRange:NSMakeRange(1, 4)];
    NSString *studentId16 = [self convertDataToHexStr:studentIdData];
    NSString *studentId = [self hexToDecimal:studentId16];
    
    NSData *startTimeData = [data subdataWithRange:NSMakeRange(5, 4)];
    NSString *startTime16 = [self convertDataToHexStr:startTimeData];
    NSString *startTime = [self hexToDecimal:startTime16];
    
    NSData *deviceStatusData = [data subdataWithRange:NSMakeRange(9, 3)];
    NSString *deviceStatus16 = [self convertDataToHexStr:deviceStatusData];
//    NSString *deviceStatus = [self hexToDecimal:deviceStatus16];
    // 转2进制
    NSString *deviceStatus2 = [self getBinaryByHex:deviceStatus16];
    // 设备信息处理
    TDeviceStatusMsg *deviceMsg = [self getDeviceStatusMsg:deviceStatus2];
    
    
    NSData *itemStatusData = [data subdataWithRange:NSMakeRange(12, 5)];
    NSString *itemStatus16 = [self convertDataToHexStr:itemStatusData];
//    NSString *itemStatus = [self hexToDecimal:itemStatus16];
    // 转2进制
    NSString *itemStatus2 = [self getBinaryByHex:itemStatus16];
    // 项目信息处理
    TItemStatussMsg *itemMsg = [self getItemStatussMsg:itemStatus2];
    
    NSData *speedData = [data subdataWithRange:NSMakeRange(17, 2)];
    NSString *speed16 = [self convertDataToHexStr:speedData];
    NSString *speed = [self hexToDecimal:speed16];
    
    NSData *deviceSpeedData = [data subdataWithRange:NSMakeRange(19, 2)];
    NSString *deviceSpeed16 = [self convertDataToHexStr:deviceSpeedData];
    NSString *deviceSpeed = [self hexToDecimal:deviceSpeed16];
    
    NSData *longitudeData = [data subdataWithRange:NSMakeRange(21, 6)];
    NSString *longitude16 = [self convertDataToHexStr:longitudeData];
    NSString *longitude = [self hexToDecimal:longitude16];
    
    NSData *latitudeData = [data subdataWithRange:NSMakeRange(27, 6)];
    NSString *latitude16 = [self convertDataToHexStr:latitudeData];
    NSString *latitude = [self hexToDecimal:latitude16];
    
    NSData *headAngleData = [data subdataWithRange:NSMakeRange(33, 2)];
    NSString *headAngle16 = [self convertDataToHexStr:headAngleData];
    NSString *headAngle = [self hexToDecimal:headAngle16];
    
    NSData *elevationAngleData = [data subdataWithRange:NSMakeRange(35, 2)];
    NSString *elevationAngle16 = [self convertDataToHexStr:elevationAngleData];
    NSString *elevationAngle = [self hexToDecimal:elevationAngle16];
    
    NSData *wheelAngleData = [data subdataWithRange:NSMakeRange(37, 2)];
    NSString *wheelAngle16 = [self convertDataToHexStr:wheelAngleData];
    NSString *wheelAngle = [self hexToDecimal:wheelAngle16];
    
    NSData *altitudeData = [data subdataWithRange:NSMakeRange(39, 4)];
    NSString *altitude16 = [self convertDataToHexStr:altitudeData];
    NSString *altitude = [self hexToDecimal:altitude16];
    
    NSData *drivingDistanceData = [data subdataWithRange:NSMakeRange(43, 4)];
    NSString *drivingDistance16 = [self convertDataToHexStr:drivingDistanceData];
    NSString *drivingDistance = [self hexToDecimal:drivingDistance16];
    
    NSData *itemCodeData = [data subdataWithRange:NSMakeRange(47, 1)];
    NSString *itemCode16 = [self convertDataToHexStr:itemCodeData];
    NSString *itemCode = [self hexToDecimal:itemCode16];
    
    NSData *markLongitudeData = [data subdataWithRange:NSMakeRange(48, 6)];
    NSString *markLongitude16 = [self convertDataToHexStr:markLongitudeData];
    NSString *markLongitude = [self hexToDecimal:markLongitude16];

    NSData *markLatitudeData = [data subdataWithRange:NSMakeRange(54, 6)];
    NSString *markLatitude16 = [self convertDataToHexStr:markLatitudeData];
    NSString *markLatitude = [self hexToDecimal:markLatitude16];

    NSData *errorNumData = [data subdataWithRange:NSMakeRange(48, 1)];
    NSString *errorNum16 = [self convertDataToHexStr:errorNumData];
    NSString *errorNum = [self hexToDecimal:errorNum16];
    
    // 没有扣分数量，则没有扣分项
    NSString *errorCode = @"";
    if (![errorNum isEqualToString:@"0"]) {
        NSData *errorCodeData = [data subdataWithRange:NSMakeRange(49, data.length -49)];
        NSString *errorCode16 = [self convertDataToHexStr:errorCodeData];
        errorCode = [self hexToDecimal:errorCode16];
    }

    body.subjectType = subjectType;
    body.studentId = studentId;
    body.startTime = startTime;
    body.deviceStatus = deviceMsg;
    body.itemStatus = itemMsg;
    body.speed = speed;
    body.deviceSpeed = deviceSpeed;
    body.longitude = longitude;
    body.latitude = latitude;
    body.headAngle = headAngle;
    body.elevationAngle = elevationAngle;
    body.wheelAngle = wheelAngle;
    body.altitude = altitude;
    body.drivingDistance = drivingDistance;
    body.itemCode = itemCode;
//    body.markLongitude = markLongitude;
//    body.markLatitude = markLatitude;
    body.errorNum = errorNum;
    body.errorCode = errorCode;
    
    return body;
}

- (TDeviceStatusMsg *)getDeviceStatusMsg:(NSString *)str {
    TDeviceStatusMsg *deviceMsg = [[TDeviceStatusMsg alloc] init];
    deviceMsg.bit0 = [str substringWithRange:NSMakeRange(0,1)];
    deviceMsg.bit1 = [str substringWithRange:NSMakeRange(1,1)];
    deviceMsg.bit2 = [str substringWithRange:NSMakeRange(2,1)];
    deviceMsg.bit3 = [str substringWithRange:NSMakeRange(3,1)];
    deviceMsg.bit4 = [str substringWithRange:NSMakeRange(4,1)];
    deviceMsg.bit5 = [str substringWithRange:NSMakeRange(5,1)];
    deviceMsg.bit6 = [str substringWithRange:NSMakeRange(6,1)];
    deviceMsg.bit7 = [str substringWithRange:NSMakeRange(7,1)];
    deviceMsg.bit8 = [str substringWithRange:NSMakeRange(8,1)];
    deviceMsg.bit9 = [str substringWithRange:NSMakeRange(9,1)];
    deviceMsg.bit10 = [str substringWithRange:NSMakeRange(10,1)];
    deviceMsg.bit11 = [str substringWithRange:NSMakeRange(11,1)];
    deviceMsg.bit12 = [str substringWithRange:NSMakeRange(12,1)];
    deviceMsg.bit13 = [str substringWithRange:NSMakeRange(13,1)];
    deviceMsg.bit14 = [str substringWithRange:NSMakeRange(14,1)];
    deviceMsg.bit15 = [str substringWithRange:NSMakeRange(15,1)];
    deviceMsg.bit16 = [str substringWithRange:NSMakeRange(16,1)];
    deviceMsg.bit17 = [str substringWithRange:NSMakeRange(17,1)];
    deviceMsg.bit18 = [str substringWithRange:NSMakeRange(18,1)];
    deviceMsg.bit19 = [str substringWithRange:NSMakeRange(19,1)];
    deviceMsg.bit20 = [str substringWithRange:NSMakeRange(20,1)];
    deviceMsg.bit21 = [str substringWithRange:NSMakeRange(21,1)];
    deviceMsg.bit22 = [str substringWithRange:NSMakeRange(22,1)];
    deviceMsg.bit23 = [str substringWithRange:NSMakeRange(23,1)];
    return deviceMsg;
}

- (TItemStatussMsg *)getItemStatussMsg:(NSString *)str {
    TItemStatussMsg *itemMsg = [[TItemStatussMsg alloc] init];
    itemMsg.bit01 = [str substringWithRange:NSMakeRange(0,2)];
    itemMsg.bit23 = [str substringWithRange:NSMakeRange(2,2)];
    itemMsg.bit45 = [str substringWithRange:NSMakeRange(4,2)];
    itemMsg.bit67 = [str substringWithRange:NSMakeRange(6,2)];
    itemMsg.bit89 = [str substringWithRange:NSMakeRange(8,2)];
    itemMsg.bit1011 = [str substringWithRange:NSMakeRange(10,2)];
    itemMsg.bit1213 = [str substringWithRange:NSMakeRange(12,2)];
    itemMsg.bit1415 = [str substringWithRange:NSMakeRange(14,2)];
    itemMsg.bit1617 = [str substringWithRange:NSMakeRange(16,2)];
    itemMsg.bit1819 = [str substringWithRange:NSMakeRange(18,2)];
    itemMsg.bit2021 = [str substringWithRange:NSMakeRange(20,2)];
    itemMsg.bit2223 = [str substringWithRange:NSMakeRange(22,2)];
    itemMsg.bit2425 = [str substringWithRange:NSMakeRange(24,2)];
    itemMsg.bit2627 = [str substringWithRange:NSMakeRange(26,2)];
    itemMsg.bit2829 = [str substringWithRange:NSMakeRange(28,2)];
    itemMsg.bit3031 = [str substringWithRange:NSMakeRange(30,2)];
    itemMsg.bit3233 = [str substringWithRange:NSMakeRange(32,2)];
    itemMsg.bit3435 = [str substringWithRange:NSMakeRange(34,2)];
    itemMsg.bit3637 = [str substringWithRange:NSMakeRange(36,2)];
    itemMsg.bit3839 = [str substringWithRange:NSMakeRange(38,2)];
    return itemMsg;
}

- (int)dataToInt:(NSData *)data {
    Byte *bb = (Byte *)data.bytes;
    int result;
    if (data.length == 1) {
        result = [self byteToInt:bb[0]];
        return result;
    } else if (data.length == 2) {
        result = (int)(((bb[0] & 0xff) << 8) | ((bb[1] & 0xff) << 0));
        return result;
    } else if (data.length == 4) {
        result = (int)((((bb[0] & 0xff) << 24) | ((bb[1] & 0xff) << 16) | ((bb[2] & 0xff) << 8)
                        | ((bb[3] & 0xff) << 0)));
        return result;
    }
    return -1;
}

- (int)byteToInt:(Byte)b {
    int result = b;
    if (b < 0) {
        result += 256;
    }
    return result;
}

/**
 NSData 转 NSString
 
 @return NSString类型的字符串
 */
- (NSString *)dataToString:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *string = [[NSMutableString alloc] init];
    for(int i = 0; i< [data length]; i++) {
        if (i == 0) {
            [string appendString:[NSString stringWithFormat:@"%hhu",bytes[i]]];
        }else {
            [string appendString:[NSString stringWithFormat:@",%hhu",bytes[i]]];
        }
    }
    return string;
}

/**
 NSData 转  十六进制string
 
 @return NSString类型的十六进制string
 */
- (NSString *)convertDataToHexStr:(NSData *)data{
    if (!self || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

/**
 十六进制转十进制
 
 @return 十进制字符串
 */
- (NSString *)hexToDecimal:(NSString *)string {
    return [NSString stringWithFormat:@"%lu",strtoul([string UTF8String],0,16)];
}

/**十六进制字符串转二进制*/
- (NSString *)getBinaryByHex:(NSString *)hex {
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSMutableString *binary = [NSMutableString string];
    for (int i = 0; i < hex.length; i++) {
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        key = key.uppercaseString; //不管三七二十一,先转为大写字母再说
        NSString *binaryStr = hexDic[key];
        [binary appendString:[NSString stringWithFormat:@"%@",binaryStr]];
    }
    NSLog(@"十六进制转换为二进制:%@ %lu个bytes",binary,binary.length/8);
    
    return binary;
}

#pragma mark 转码
#pragma mark
+ (NSData *)ByteToNSData:(int)data//Byte
{
    NSData *bigData = [NSData dataWithBytes: &data length:1];
    NSData *smallData = [self dataTransfromBigOrSmall:bigData];
    return smallData;
}

+ (NSData *)LongToNSData:(long long)data//DWORD
{
    NSData *bigData = [NSData dataWithBytes: &data length:4];
    NSData *smallData = [self dataTransfromBigOrSmall:bigData];
    return smallData;
}

+ (NSData *)IntToNSData:(int)data//WORD
{
    NSData *bigData = [NSData dataWithBytes: &data length:2];
    NSData *smallData = [self dataTransfromBigOrSmall:bigData];
    return smallData;
}

+ (NSData *)CharToNSData:(char *)data
{
    NSData *bigData = [NSData dataWithBytes: data length:strlen(data)];
    NSData *smallData = [self dataTransfromBigOrSmall:bigData];
    return smallData;
}

//大小端数据转换（其实还有更简便的方法，不过看起来这个方法是最直观的）
+ (NSData *)dataTransfromBigOrSmall:(NSData *)data{
    
    NSString *tmpStr = [self dataChangeToString:data];
    NSMutableArray *tmpArra = [NSMutableArray array];
    for (int i = 0 ;i<data.length*2 ;i+=2) {
        NSString *str = [tmpStr substringWithRange:NSMakeRange(i, 2)];
        [tmpArra addObject:str];
    }
    NSArray *lastArray = [[tmpArra reverseObjectEnumerator] allObjects];
    NSMutableString *lastStr = [NSMutableString string];
    for (NSString *str in lastArray) {
        [lastStr appendString:str];
    }
    NSData *lastData = [self HexStringToData:lastStr];
    
    return lastData;
    
}

+ (NSString*)dataChangeToString:(NSData*)data{
    
    NSString * string = [NSString stringWithFormat:@"%@",data];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

+ (NSMutableData*)HexStringToData:(NSString*)str{
    
    NSString *command = str;
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

// 16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
// NSData转16进制 第一种
+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


// NSData转16进制 第二种
+ (NSString *)hexStringFormData:(NSData *)data
{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString:@"<" withString:@""]
             stringByReplacingOccurrencesOfString:@">" withString:@""]
            stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
