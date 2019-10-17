//
//  TcpServer.h
//  HGStudent
//
//  Created by DoronXC on 2019/5/8.
//  Copyright © 2019年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface TcpServer : NSObject  <GCDAsyncSocketDelegate> {
    GCDAsyncSocket *serverSocket;
    NSMutableArray *clientArray;
    long readTag;
    long writeTag;
}

-(long)getReadTag;
-(long)getWriteTag;
-(void)createTcpSocket:(const char *)queueName acceptOnPort:(uint16_t)port;
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket;
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
-(void)socket:(GCDAsyncSocket *)sock writeString:(NSString *)str withTag:(long)tag;
-(void)broadcastStr:(NSString *)str;
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;

@end
