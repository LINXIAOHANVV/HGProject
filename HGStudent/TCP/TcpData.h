//
//  TcpData.h
//  HGStudent
//
//  Created by DoronXC on 2019/5/8.
//  Copyright © 2019年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TcpData : NSObject

@property (nonatomic, assign) int messageId;

- (NSData*)encodingData;

- (NSDictionary*)decodingOfData:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
