//
//  Header.h
//  HGStudent
//
//  Created by DoronXC on 2017/1/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#ifndef Header_h
#define Header_h

//网络
#import "AFNetworking.h"

//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Map/BMKOverlay.h>

//极光推送
#import "JPUSHService.h"

//布局
#import "Masonry.h"

//加载样式
#import "MBProgressHUD.h"

//建模
#import "MJExtension.h"

//刷新
#import "MJRefresh.h"

//无限轮播
#import "SDCycleScrollView.h"

//网络图片加载
#import <SDWebImage/UIImageView+WebCache.h>

//加载样式
#import "SVProgressHUD.h"

//友盟--分享（qq,微信,微博。。。），推送 
#import "UMSocial.h"

//推送小红点
#import "WZLBadgeImport.h"

//数据库
#import "FMDB.h"

//正则表达式
#import "RegexKitLite.h"

//监控键盘弹出变化
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

//界面布局
#import "UIViewExt.h"
#import "UIView+Size.h"

//js交互
#import "WebViewJavascriptBridge.h"


#import "UIColor+Extension.h"//UIColor 扩展类
#import "UILabel+Extension.h"//UILabel 扩展类
#import "UIImage+Extension.h"//UIImage 扩展类
#import "UIButton+Edge.h"//UIButton 扩展类
// 1.判断是否为iOS8
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

// 2.获得RGB颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)     RGBA(r, g, b, 1.0f)

#define navigationBarColor RGB(67, 199, 176)
#define separaterColor RGB(200, 199, 204)
#define selectColor RGB(46, 158, 138)


//判断屏幕大小
#define iPhone35inch ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone4inch ([UIScreen mainScreen].bounds.size.height == 568)
#define iPhone47inch ([UIScreen mainScreen].bounds.size.height == 667)
#define iPhone55inch ([UIScreen mainScreen].bounds.size.height == 736)

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabbarHeight 49
#define kNavigationBarHeight 64

//重新设定view的x.y.h.w值
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)
#define setFrameW(view, newW) view.frame =                           CGRectMake(view.frame.origin.x, view.frame.origin.y, newW, view.frame.size.height)

//取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y

//字体
#define kFONT16                  [UIFont systemFontOfSize:16.0f]
#define kFONT15                  [UIFont systemFontOfSize:15.0f]
#define kFONT13                  [UIFont systemFontOfSize:13.0f]
#define kFONT12                  [UIFont systemFontOfSize:12.0f]
#define kFONT10                  [UIFont systemFontOfSize:10.0f]


//5.常用对象
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

//6.经纬度
#define LATITUDE_DEFAULT 39.983497
#define LONGITUDE_DEFAULT 116.318042

//7./系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define YYISiPhoneX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f&& YYIS_IPHONE
#define YYIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
////状态栏高度
//#define kStatusBarHeight    (CGFloat)(YYISiPhoneX?(44):(20))
//// 导航栏高度
//#define kNavBarHBelow7      (44)
//// 状态栏和导航栏总高度
//#define kNavBarHAbove7      (CGFloat)(YYISiPhoneX?(88):(64))
//// TabBar高度
//#define kTabBarHeight       (CGFloat)(YYISiPhoneX?(49+34):(49))
//// 顶部安全区域远离高度
//#define kTopBarSafeHeight   (CGFloat)(YYISiPhoneX?(44):(0))
//// 底部安全区域远离高度
//#define kBottomSafeHeight   (CGFloat)(YYISiPhoneX?(34):(0))
//// iPhoneX的状态栏高度差值
//#define kTopBarDifHeight    (CGFloat)(YYISiPhoneX?(24):(0))

/**
 * MARK:-屏幕尺寸宏定义
 * 导航栏高度 状态栏高度 底部tabbar高度 苹果X底部安全区高度
 */
//屏幕rect
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))
//iPhone X系列判断
#define  IS_iPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))
//状态栏高度
#define StatusBarHeight (IS_iPhoneX ? 44.f : 20.f)
//导航栏高度
#define NavBarHeight (44.f+StatusBarHeight)
//底部标签栏高度
#define TabBarHeight (IS_iPhoneX ? (49.f+34.f) : 49.f)
//安全区域高度
#define TabbarSafeBottomMargin     (IS_iPhoneX ? 34.f : 0.f)


// TCP 相关
#define DEF_STR_ENCODING    NSUTF8StringEncoding
//连接超时时间为60秒
#define CONNECT_TIMEOUT     60
#define READ_TIMEOUT        -1
//发送数据超时时间为60秒
#define WRITE_TIMEOUT       60

#define SERVER_QUEUE        "tcpServerQueue"
#define CLIENT_QUEUE        "tcpClientQueue"

#define SERVER_ADDRESS      @"127.0.0.1"
#define SERVER_PORT         40000
//#define SERVER_ADDRESS      @"114.55.125.222"
//#define SERVER_PORT         50504
//#define SERVER_ADDRESS      @"dmstcp.duolunxc.com"
//#define SERVER_PORT         52001

#import "TcpData.h"
#import "DDUDPData.h"
#import "AsynMediaSocketManager.h"

#endif /* Header_h */


/**
 *  完美解决Xcode NSLog打印不全的宏 亲测目前支持到8.2bate版
 */
#ifdef DEBUG
//#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
//#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(format, ...)
#endif
