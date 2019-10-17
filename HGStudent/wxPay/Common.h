//
//  Common.h
//  ShareDemo
//
//  Created by 阳 on 2017/2/27.
//  Copyright © 2017年 阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>

@interface Common : NSObject

+ (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
+ (NSString *)getCurrentTimeSp;
+ (NSString *)baseServerURLWithSimpleServer:(NSString *)urlStr;
+ (NSString *)getIPAddress;

@end
