//
//  AsynMediaSocketManager.m
//  Doron
//
//  Created by DoronXC on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//
#import "AsynMediaSocketManager.h"
#import "AsyncUdpSocket.h"
#import "DDUDPData.h"

@interface AsynMediaSocketManager()

@property (nonatomic, retain) AsyncUdpSocket *mediaSocket1;
@property (nonatomic, retain) AsyncUdpSocket *mediaSocket2;
@property (nonatomic, assign) BOOL mediaSocket1Con;
@property (nonatomic, assign) BOOL mediaSocket2Con;

@end

@implementation AsynMediaSocketManager
@synthesize mediaSocket1;
@synthesize mediaSocket2;


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initAsyncMediaSocket];
    }
    return self;
}

- (void)dealloc
{
    [mediaSocket2 close];
    _mediaSocket2Con = NO;
    mediaSocket2 = nil;
    [mediaSocket1 close];
    _mediaSocket1Con = NO;
    mediaSocket1 = nil;
    [super dealloc];
}

/**
 *	@brief	初始化Socket
 */
- (void)initAsyncMediaSocket
{
    if (mediaSocket1 == nil) {
        NSError *error = nil;
        mediaSocket1 = [[AsyncUdpSocket alloc] initWithDelegate:self];
        BOOL  conectRes = [mediaSocket1 bindToPort:SERVER_PORT error:&error];
        if (conectRes) {
            conectRes = [mediaSocket1 enableBroadcast:YES error:&error];
            [mediaSocket1 joinMulticastGroup:SERVER_ADDRESS error:nil];

            if (!conectRes) {
                
            }else {
                _mediaSocket1Con = YES;
                [mediaSocket1 receiveWithTimeout:-1 tag:0];
            }
        }
    }else {
        [mediaSocket1 receiveWithTimeout:-1 tag:0];
    }
    
    if (mediaSocket2 == nil) {
        NSError *error = nil;
        mediaSocket2 = [[AsyncUdpSocket alloc] initWithDelegate:self];
        BOOL conectRes = [mediaSocket2 bindToPort:SERVER_PORT error:&error];
        if (conectRes) {
            conectRes = [mediaSocket2 enableBroadcast:YES error:&error];
            [mediaSocket2 joinMulticastGroup:SERVER_ADDRESS error:nil];

            if (!conectRes) {
                
            }else {
                _mediaSocket2Con = YES;
                [mediaSocket2 receiveWithTimeout:-1 tag:0];
            }
        }
    }else {
        [mediaSocket2 receiveWithTimeout:-1 tag:0];
    }
}

/**
 *	@brief	重新连接Socket
 */
- (void)reConnectMediaSocket
{
    [mediaSocket2 close];
    _mediaSocket2Con = NO;
    mediaSocket2 = nil;
    
    [mediaSocket1 close];
    _mediaSocket1Con = NO;
    mediaSocket1 = nil;
    
    [self initAsyncMediaSocket];
}


#pragma mark function
#pragma mark
- (void)writeUDPHeartData:(NSData*)data type:(KInstructionsType)type
{
    if (mediaSocket1 && _mediaSocket1Con) {
        [mediaSocket1 sendData:data
                        toHost:SERVER_ADDRESS
                          port:SERVER_PORT
                   withTimeout:-1
                           tag:type];
        [mediaSocket1 receiveWithTimeout:-1 tag:type];
    }
}

- (void)writeUDPGPSData:(NSData*)data
{
    if (mediaSocket2 && _mediaSocket2Con) {
        [mediaSocket2 sendData:data
                        toHost:SERVER_ADDRESS
                          port:SERVER_PORT
                   withTimeout:-1
                           tag:kInstructionsPGPS];
        [mediaSocket2 receiveWithTimeout:-1 tag:kInstructionsPGPS];
    }
}

#pragma mark AsyncUdpSocket Delegate
#pragma mark
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    if (_asyConnectDelegate && [_asyConnectDelegate respondsToSelector:@selector(socketConnectStatus:tag:resultData:)] ) {
        [_asyConnectDelegate socketConnectStatus:self tag:(KInstructionsType)tag resultData:data];
    }
    
    [sock receiveWithTimeout:-1 tag:tag];
    
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"didNotReceiveDataWithTag");
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    if (_asyConnectDelegate && [_asyConnectDelegate respondsToSelector:@selector(socketConnectFailed)] ) {
        [_asyConnectDelegate socketConnectFailed];
    }
    NSLog(@"didNotSendDataWithTag");
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"didSendDataWithTag");
}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"onUdpSocketDidClose");
}

@end
