//
//  DDUDPData.m
//  Doron
//
//  Created by DoronXC on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DDUDPData.h"

@interface DDUDPData()

+ (NSData *) LongToNSData:(long long)data;
+ (NSData *) IntToNSData:(int)data;
+ (NSData *) CharToNSData:(char*)data;

@end

@implementation DDUDPData

#pragma mark encodingData
#pragma mark
- (NSData*)encodingData
{
    NSData *head = [self messageHead];
    NSData *headCode = [self verificationCode:head];
    NSData *body = [self messageBody];
    NSData *bodyCode = [self verificationCode:body];
    NSData *end  = [self messageEnd];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:head];
    [data appendData:headCode];
    [data appendData:body];
    [data appendData:bodyCode];
    [data appendData:end];
    
    return data;
}

- (NSData*)messageBody
{
    if (DDUDPDataType_HeartRequest == _eventTpyeId)
    {
        NSData *data1 = [DDUDPData  ByteToNSData:_MessageNo];
        NSData *data2 = [DDUDPData  ByteToNSData:_trainingStatus];
        NSData *data3 = [DDUDPData  LongToNSData:_studentId];
        
        NSMutableData *data = [NSMutableData data];
        [data appendData:data1];
        [data appendData:data2];
        [data appendData:data3];

        return data;
        
    }else if (DDUDPDataType_UploadingMessage == _eventTpyeId)
    {
        NSData *data1 = [DDUDPData  LongToNSData:_studentId];
        NSData *data2 = [DDUDPData  LongToNSData:_cocoaId];
        NSData *data3 = [DDUDPData  ByteToNSData:_trainingType];
        NSData *data4 = [DDUDPData  LongToNSData:_trainingStartTime];
        
        //设备信号状态
        NSData *data5_0 = [DDUDPData  ByteToNSData:0];
        NSData *data5_1 = [DDUDPData  ByteToNSData:0];
        NSData *data5_2 = [DDUDPData  ByteToNSData:0];

        NSData *data6 = [DDUDPData  IntToNSData:_speed];
        NSData *data7 = [DDUDPData  ByteToNSData:0];
        NSData *data8 = [DDUDPData  LongToNSData:_longitude];
        NSData *data9 = [DDUDPData  LongToNSData:_latitude];
        NSData *data10 = [DDUDPData  IntToNSData:_headingAngle];
        NSData *data11 = [DDUDPData  IntToNSData:_pitchAngle];
        NSData *data12 = [DDUDPData  LongToNSData:_altitude];

        //设备信号状态
        NSData *data13_0 = [DDUDPData  ByteToNSData:0];
        NSData *data13_1 = [DDUDPData  ByteToNSData:0];
        NSData *data13_2 = [DDUDPData  ByteToNSData:0];
        NSData *data13_3 = [DDUDPData  ByteToNSData:0];
        NSData *data13_4 = [DDUDPData  ByteToNSData:0];

        NSData *data14 = [DDUDPData  ByteToNSData:0];
        NSData *data15 = [DDUDPData  IntToNSData:0];
        NSData *data16 = [DDUDPData  IntToNSData:0];
        NSData *data17 = [DDUDPData  IntToNSData:0];

        
        NSMutableData *data = [NSMutableData data];
        [data appendData:data1];
        [data appendData:data2];
        [data appendData:data3];
        [data appendData:data4];
        
        //设备信号状态
        [data appendData:data5_0];
        [data appendData:data5_1];
        [data appendData:data5_2];

        [data appendData:data6];
        [data appendData:data7];
        [data appendData:data8];
        [data appendData:data9];
        [data appendData:data10];
        [data appendData:data11];
        [data appendData:data12];
        
        //设备信号状态
        [data appendData:data13_0];
        [data appendData:data13_1];
        [data appendData:data13_2];
        [data appendData:data13_3];
        [data appendData:data13_4];

        [data appendData:data14];
        [data appendData:data15];
        [data appendData:data16];
        [data appendData:data17];

        return data;

    }
    return 0;
}

- (NSData*)messageEnd
{
    char cr=(char)0x0a;
    char lf=(char)0x0d;
    NSString *end = [NSString stringWithFormat:@"%c%c",lf,cr];
    NSData *data = [end dataUsingEncoding:NSASCIIStringEncoding];
    
    return data;
}

- (NSData*)messageHead
{
    NSData *data1 = [DDUDPData  ByteToNSData:_eventTpyeId];
    NSData *data2 = [DDUDPData  IntToNSData:_MessageNo];
    NSData *data3 = [DDUDPData  LongToNSData:_schoolId];
    NSData *data4 = [DDUDPData  LongToNSData:_carNo];
    NSData *data5 = [DDUDPData  IntToNSData:(int)[[self messageBody] length]];

    NSMutableData *data = [NSMutableData data];
    [data appendData:data1];
    [data appendData:data2];
    [data appendData:data3];
    [data appendData:data4];
    [data appendData:data5];

    return data;
}

- (NSData*)verificationCode:(NSData*)data
{
    int n = (int)[data length];
    uint8_t *dataByte = (uint8_t*)[data bytes];
    uint8_t b = 0;

    for (int i = 0; i < n; i++) {
        b = (uint8_t) (b ^ (uint8_t)dataByte[i]);
    }

    return [NSData dataWithBytes:&b length:1];
}

#pragma mark decodingOfData
#pragma mark
+ (NSDictionary*)decodingOfData:(NSData*)data
{
    int n = (int)[data length];

    if (n > 17) {
        int m0;
        NSData *data0 = [data subdataWithRange:NSMakeRange(0, 1)];
        [data0 getBytes:&m0 length:1];

        int m1;
        NSData *data1 = [data subdataWithRange:NSMakeRange(14, 1)];
        [data1 getBytes:&m1 length:1];
        
        int m2;
        NSData *data2 = [data subdataWithRange:NSMakeRange(15, 1)];
        [data2 getBytes:&m2 length:1];
        
        NSDictionary * parameters = @{@"a":[NSNumber numberWithInt:m0],@"b":[NSNumber numberWithInt:m1],@"c":[NSNumber numberWithInt:m2]};
        
        return parameters;
    }
    return nil;
}

#pragma mark public
#pragma mark
+(NSData *) ByteToNSData:(int)data//Byte
{
    return [NSData dataWithBytes: &data length:1];
}

+(NSData *) LongToNSData:(long long)data//DWORD
{
    return [NSData dataWithBytes: &data length:4];
}

+(NSData *) IntToNSData:(int)data//WORD
{
    return [NSData dataWithBytes: &data length:2];
}

+(NSData *) CharToNSData:(char*)data
{
    return  [NSData dataWithBytes: data length:strlen(data)];
}

@end
