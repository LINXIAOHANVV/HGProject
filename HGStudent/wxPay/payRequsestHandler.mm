
#import <Foundation/Foundation.h>
#import "payRequsestHandler.h"
#import "GDataXMLNode.h"
/*
 服务器请求操作处理
 */
@implementation payRequsestHandler

//初始化函数
-(BOOL) init:(NSString *)app_id app_secret:(NSString *)app_secret mach_id:(NSString *)mach_id api_key:(NSString *)api_key notify_url:(NSString *)notify_url preSignKey:(NSString *)preSignKey
{
    //初始构造函数
    tokenUrl    = @"https://api.weixin.qq.com/cgi-bin/token";
    gateUrl     = @"https://api.weixin.qq.com/pay/genprepay";
    notifyUrl	= notify_url;
    if (debugInfo == nil){
        debugInfo   = [NSMutableString string];
    }
    appid       = [NSString stringWithString:app_id];
    appsecret   = [NSString stringWithString:app_secret];
    machid      = [NSString stringWithString:mach_id];
    apikey      = [NSString stringWithString:api_key];
    token_time  = 0;
    [debugInfo setString:@""];
    return YES;
}
//设置商户密钥
-(void) setKey:(NSString *)key
{
    machid = [NSString stringWithString:key];
}
//获取debug信息
-(NSString*) getDebugifo
{
    NSString *res = [NSString stringWithString:debugInfo];
    [debugInfo setString:@""];
    return res;
}
//获取最后服务返回错误代码
-(long) getLasterrCode
{
    return last_errcode;
}
//获取TOKEN，一天最多获取200次，需要所有用户共享值
-(NSString *) GetToken
{
    NSString *url = [NSString stringWithFormat:@"%@?grant_type=client_credential&appid=%@&secret=%@", tokenUrl, appid, appsecret];
    //发送http请求
    NSDictionary *resParams = [TenpayUtil httpSendJson:url method:@"GET" data:@""];
    
    //判断返回，获取access_token参数
    Token = [resParams objectForKey:@"access_token"];
    if ( Token == nil ){
        last_errcode = [[resParams objectForKey:@"retcode"] integerValue];
        token_time  = 0;
    }
    
    //输出Debug Info
    [debugInfo appendFormat:@"Get Token url:%@\n", url];
    [debugInfo appendFormat:@"Get Token json:%@\n", [TenpayUtil toJson:resParams]];
    
    return Token;
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", machid];
    //得到MD5 sign签名
    NSString *md5Sign =[TenpayUtil md5:contentString];
    
    //输出Debug Info
    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n",contentString];

    return md5Sign;
}

//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    NSString *sign = [self genSign:packageParams];
    //生成urlendcode的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>"];
    for (NSString *categoaryId in keys) {
        [reqPars appendFormat:@"<%@><![CDATA[%@]]></%@>",categoaryId,[packageParams objectForKey:categoaryId],categoaryId];
        
    }
    [reqPars appendFormat:@"<sign><![CDATA[%@]]></sign></xml>",sign];

    return [NSString stringWithString:reqPars];
}

- (NSString *)genSign:(NSDictionary *)signParams{
    NSArray *keys = [signParams allKeys];
    
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *sign = [NSMutableString string];
    
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *result = [NSString stringWithFormat:@"%@&key=%@",sign,apikey];
    NSString *signMD5 = [TenpayUtil md5:result];
    signMD5 = signMD5.uppercaseString;
    return signMD5;
}
//创建签名SHA1
-(NSString *)createSHA1Sign:(NSMutableDictionary *)signParams
{
    NSMutableString *signString=[NSMutableString string];
    //按字母顺序排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if ( [signString length] > 0) {
            [signString appendString:@"&"];
        }
        [signString appendFormat:@"%@=%@", categoryId, [signParams objectForKey:categoryId]];
        
    }
    
    
    NSString *newSignString = [NSString stringWithFormat:@"%@&key=%@",signString,apikey];
    NSLog(@"qianmiang:%@",newSignString);
    //得到sha1 sign签名
    NSString *sign =[TenpayUtil md5:newSignString];
    
    //输出Debug Info
    [debugInfo appendFormat:@"SHA1签名字符串：\n%@\n",sign];

    return sign;
}
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
{
    NSString *send = [self genPackage:prePayParams];
    
    NSLog(@"%@",send);
    
    NSData *data_send = [send dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"https://api.mch.weixin.qq.com/pay/unifiedorder"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:data_send];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (!error) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data error:nil];
        GDataXMLElement  *rootElement = [document rootElement];
        GDataXMLElement  *return_code = [[rootElement elementsForName:@"retutn_code"] lastObject];
        GDataXMLElement  *return_msg  = [[rootElement elementsForName:@"return_msg"] lastObject];
        GDataXMLElement  *result_code = [[rootElement elementsForName:@"result_code"] lastObject];
        GDataXMLElement  *prepay_id = [[rootElement elementsForName:@"prepay_id"] lastObject];
        
        NSLog(@"%@,%@,%@,%@",return_code,return_msg,result_code,prepay_id);
        return [prepay_id stringValue];
    }else{
        return nil;
    }
    
    
    
    
//    NSString *prepayid = nil;
//    //获取提交支付json
//    NSString *json      = [TenpayUtil toJson:prePayParams];
//    NSString *url       = [NSString stringWithFormat:@"%@", gateUrl];
//    //发送请求post json数据
//    NSDictionary *resParams = [TenpayUtil httpSendJson:url method:@"POST" data:json];
//    //判断返回
//    long retcode   = [[resParams objectForKey:@"errcode"] longValue];
//    if ( retcode == 0) {//返回成功
//        prepayid    = [resParams objectForKey:@"prepayid"];
//    }
//    last_errcode = retcode;
//
//    //输出Debug Info
//    [debugInfo appendFormat:@"send prePay url:%@\n", url];
//    [debugInfo appendFormat:@"send prePay body json:%@\n", json];
//    NSError *error = nil;
//    //ios5.0 自带的NSJSONSerialization序列化
//    //记录返回的json
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resParams options:NSJSONWritingPrettyPrinted error:&error];
//    [debugInfo appendFormat:@"send prePay res json:%@\n", [[[NSString alloc] autorelease] initWithData:jsonData encoding:NSUTF8StringEncoding]];
//
//    return prepayid;
}

@end
