//
//  TCPClient.h
//  HGStudent
//
//  Created by DoronXC on 2019/5/8.
//  Copyright © 2019年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface TcpClient : NSObject<GCDAsyncSocketDelegate> {
    GCDAsyncSocket *clientSocket;
    long readTag;
    long writeTag;
}

-(long)getReadTag;
-(long)getWriteTag;
-(void)createTcpSocket:(const char *)queueName connectToHost:(NSString *) host onPort:(uint16_t)port;
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
-(void)writeString:(NSString *)str withTag:(long)tag;
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;

-(void)disconnect;

@end
