//
//  AsynMediaSocketManager.h
//  Doron
//
//  Created by DoronXC on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kInstructionHeart = 101,
    kInstructionsPGPS = 102,
    kInstructionudpStu_Search_Driver_DataMessageManager= 103,
    kInstructionudpDriver_Search_Stu_DataMessageManager= 104,
    kInstructionudpStu_Upload_GPS_DataMessageManager= 105,
    kInstructionudpDriver_Upload_GPS_DataMessageManager= 106
}KInstructionsType;

@class AsynMediaSocketManager;
@protocol AsynMediaSocketManagerDelegate <NSObject>
- (void)socketConnectStatus:(AsynMediaSocketManager *)asynMediaSocketManager tag:(KInstructionsType)type resultData:(NSData*)data;
- (void)socketConnectFailed;
@end

@interface AsynMediaSocketManager : NSObject

@property (nonatomic, assign) id <AsynMediaSocketManagerDelegate> asyConnectDelegate;

- (void)reConnectMediaSocket;

- (void)writeUDPHeartData:(NSData*)data type:(KInstructionsType)type;

- (void)writeUDPGPSData:(NSData*)data;

@end
