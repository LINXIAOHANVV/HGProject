//
//  TcpServer.m
//  HGStudent
//
//  Created by DoronXC on 2019/5/8.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "TcpServer.h"
#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@implementation TcpServer

-(long)getReadTag {
    return readTag++;
}

-(long)getWriteTag {
    return writeTag++;
}

-(void)createTcpSocket:(const char *)queueName acceptOnPort:(uint16_t)port {
    clientArray = [NSMutableArray array];
    dispatch_queue_t dispatchQueue = dispatch_queue_create(queueName, NULL);
    serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatchQueue];
    [serverSocket acceptOnPort:port error:nil];
    readTag = 0;
    writeTag = 0;
}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSString* ip = [newSocket connectedHost];
    uint16_t port = [newSocket connectedPort];
    NSLog(@"server didAcceptNewSocket [%@:%d]", ip, port);
    [clientArray addObject:newSocket];
    //一直等待readSocket的消息(tag是一个标记类似于tcp数据包中的序列号)
    [newSocket readDataWithTimeout:READ_TIMEOUT tag:[self getReadTag]];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *str = [[NSString alloc] initWithData:data encoding:DEF_STR_ENCODING];
    NSLog(@"server didReadData [%@:%d] %@", ip, port, str);
    //再次接收数据，因为这个方法只接收一次
    [sock readDataWithTimeout:READ_TIMEOUT tag:[self getReadTag]];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSLog(@"server didWriteDataWithTag [%@:%d]", ip, port);
}

-(void)socket:(GCDAsyncSocket *)sock writeString:(NSString *)str withTag:(long)tag {
    NSData *data = [str dataUsingEncoding:DEF_STR_ENCODING];
    [sock writeData:data withTimeout:WRITE_TIMEOUT tag:[self getWriteTag]];
}

-(void)broadcastStr:(NSString *)str {
    for(GCDAsyncSocket *sock in clientArray) {
        [self socket:sock writeString:str withTag:[self getWriteTag]];
    }
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSLog(@"server socketDidDisconnect [%@:%d]", ip, port);
    [clientArray removeObject:sock];
}

@end
