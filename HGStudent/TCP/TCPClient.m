//
//  TCPClient.m
//  HGStudent
//
//  Created by DoronXC on 2019/5/8.
//  Copyright © 2019年 HG. All rights reserved.
//

#import "TCPClient.h"

@implementation TcpClient

-(long)getReadTag {
    return readTag++;
}

-(long)getWriteTag {
    return writeTag++;
}

-(void)createTcpSocket:(const char *)queueName connectToHost:(NSString *) host onPort:(uint16_t)port {
    dispatch_queue_t dispatchQueue = dispatch_queue_create(queueName, NULL);
    clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatchQueue];
    [clientSocket connectToHost:host onPort:port withTimeout:CONNECT_TIMEOUT  error:nil];
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"client didConnectToHost [%@:%d]", host, port);
    [sock readDataWithTimeout:READ_TIMEOUT tag:[self getReadTag]];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
//    NSString *str = [[NSString alloc] initWithData:data encoding:DEF_STR_ENCODING];
    NSDictionary * dic = [[[TcpData alloc] init] decodingOfData:data];
    NSLog(@"接收到的数据dic ============= %@",dic);
    NSLog(@"client didReadData [%@:%d] =====data===%@", ip, port, data);
    
//    NSLog(@"client didReadData [%@:%d] %@=====data===%@", ip, port, str, data);
    //再次接收数据，因为这个方法只接收一次
    [clientSocket readDataWithTimeout:READ_TIMEOUT tag:[self getReadTag]];
    
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSLog(@"client didWriteDataWithTag [%@:%d]", ip, port);
}

-(void)writeString:(NSString *)str withTag:(long)tag {
//    NSData *data = [str dataUsingEncoding:DEF_STR_ENCODING];
    TcpData *tcpData = [[TcpData alloc] init];
    NSData *data = [tcpData encodingData];
    NSLog(@"data数据======%@",data);
    [clientSocket writeData:data withTimeout:WRITE_TIMEOUT tag:[self getWriteTag]];
    [clientSocket readDataWithTimeout:READ_TIMEOUT tag:[self getReadTag]];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSLog(@"client socketDidDisconnect [%@:%d]", ip, port);
    //可以在这边实现断线重连机制
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SocketConnectErrorNotification" object:nil];
}

-(void)disconnect {
    [clientSocket disconnect];
}

@end
