//
//  WXPay.m
//  LearnDriving
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 chelichewai. All rights reserved.
//

#define KEncryptKey @"1"

#import "WXPay.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "GTMBase64.h"
#import "Common.h"


@implementation WXPay

+ (void)jumpToPayWithDic:(NSDictionary *)dict {
    
    NSString *WXAppId       = [dict objectForKey:@"appid"];
    NSString *WXMchId       = [dict objectForKey:@"partner"];
    NSString *WXAppSecret   = [dict objectForKey:@"appsecret"];
    NSString *WXAPIKey      = [dict objectForKey:@"partnerkey"];
    NSString *WXPreSignKey  = [dict objectForKey:@"partnerkey"];
    NSString *NOTIFY_URL    = [dict objectForKey:@"notifyURL"];
    NSString *ORDER_NAME    = [dict objectForKey:@"productDescription"];
    NSInteger total_price   = [[dict objectForKey:@"amount"] doubleValue]*100;
    NSString *ORDER_PRICE   = [NSString stringWithFormat:@"%ld",(long)total_price];

    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    [req init:WXAppId app_secret:WXAppSecret mach_id:WXMchId api_key:WXAPIKey notify_url:NOTIFY_URL preSignKey:WXPreSignKey];
    
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    [packageParams setObject: WXAppId   forKey:@"appid"];
    [packageParams setObject: WXMchId   forKey:@"mch_id"];
    
    NSString *nonce_str, *package;
    NSString *time_stamp = [Common getCurrentTimeSp];
    
    nonce_str	= [TenpayUtil md5:time_stamp];
    
    [packageParams setObject:[NSString stringWithFormat:@"wx%@",[dict objectForKey:@"aaaaaa"]] forKey:@"nonce_str"];//随机编码
    [packageParams setObject:ORDER_NAME                        forKey:@"body"];            //商品描述
    [packageParams setObject:[dict objectForKey:@"bbbbb"]  forKey:@"out_trade_no"];    //订单号
    [packageParams setObject:@"CNY"                            forKey:@"fee_type"];        //交易币种
    [packageParams setObject:ORDER_PRICE                       forKey:@"total_fee"];
    [packageParams setObject:[Common getIPAddress]             forKey:@"spbill_create_ip"];//网络地址
    [packageParams setObject:NOTIFY_URL                        forKey:@"notify_url"];      //回调url
    [packageParams setObject:@"APP"                            forKey:@"trade_type"];      //交易种类
    NSString *sign = [req createSHA1Sign:packageParams];//一次签名
    
    NSMutableDictionary *payParams = [[NSMutableDictionary alloc] initWithDictionary:packageParams];
    [payParams setObject:sign forKey:@"sign"];
    
    //获取prepayId
    NSString *prePayid  = [req sendPrepay:payParams];
    
    if (prePayid != nil) {
        //重新按提交格式组包，微信客户端5.0.3以前版本只支持package=Sign=***格式，须考虑升级后支持携带package具体参数的情况
        package = @"Sign=WXPay";
        //签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        
        [signParams setObject:WXAppId                                          forKey:@"appid"];
        [signParams setObject:nonce_str                                        forKey:@"noncestr"];
        [signParams setObject:package                                          forKey:@"package"];
        [signParams setObject:WXMchId                                          forKey:@"partnerid"];
        [signParams setObject:time_stamp                                       forKey:@"timestamp"];
        [signParams setObject:prePayid                                         forKey:@"prepayid"];
        
        //生成签名
        sign = [req createSHA1Sign:signParams];//二次签名
        
        //调起微信支付
        PayReq *payReq = [[PayReq alloc] init];
        payReq.openID      = WXAppId;
        payReq.partnerId   = WXMchId;
        payReq.prepayId    = prePayid;
        payReq.nonceStr    = nonce_str;
        payReq.timeStamp   = [time_stamp intValue];//转变类型
        payReq.package     = package;
        payReq.sign        = sign;
        
        [WXApi sendReq:payReq];
    }else{
        
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"获取prepayid失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alter show];
    }
}


@end
