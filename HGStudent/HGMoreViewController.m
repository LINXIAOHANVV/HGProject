//
//  HGMoreViewController.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGMoreViewController.h"
#import "iQiYiPlayButton.h"
#import "YouKuPlayButton.h"
#import "RSA.h"
#import "TcpServer.h"
#import "TcpClient.h"

//#import "NIMSessionListViewController.h"
//#import "NIMSessionViewController.h"

@interface HGMoreViewController ()<AsynMediaSocketManagerDelegate>{
    
    iQiYiPlayButton *_iQiYiPlayButton;
    
    YouKuPlayButton *_youKuPlayButton;
    
    AsynMediaSocketManager *mediaSocketManager;
    
    DDUDPData           *udpData;
}


@property (nonatomic, retain) TcpServer *tcpServer;
@property (nonatomic, retain) TcpClient *tcpClient;

@end

@implementation HGMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多4";
//    self.view.backgroundColor = [UIColor redColor];
    
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    _iQiYiPlayButton = [[iQiYiPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) state:iQiYiPlayButtonStatePlay];
    _iQiYiPlayButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height/3);
    [_iQiYiPlayButton addTarget:self action:@selector(iQiYiPlayMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_iQiYiPlayButton];
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    _youKuPlayButton = [[YouKuPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) state:YouKuPlayButtonStatePlay];
    _youKuPlayButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height*2/3);
    [_youKuPlayButton addTarget:self action:@selector(youKuPlayMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_youKuPlayButton];
    
//    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(host) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:time forMode:UITrackingRunLoopMode];
    
    // TCP 相关
    [self initTcp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnectError) name:@"SocketConnectErrorNotification" object:nil];
    
//    mediaSocketManager = [[AsynMediaSocketManager alloc] init];
//    [mediaSocketManager setAsyConnectDelegate:self];
//    udpData = [DDUDPData new];
}
- (void)initTcp {
    //    _tcpServer = [[TcpServer alloc] init];
    _tcpClient = [[TcpClient alloc] init];
    //    [_tcpServer createTcpSocket:SERVER_QUEUE acceptOnPort:SERVER_PORT];
    [_tcpClient createTcpSocket:CLIENT_QUEUE connectToHost:SERVER_ADDRESS onPort:SERVER_PORT];
}
- (void)socketConnectError {
    [self initTcp];
//    [_tcpClient disconnect];
}
#pragma mark
#pragma mark AsynMediaSocketManager Delegate
- (void)socketConnectStatus:(AsynMediaSocketManager *)asynMediaSocketManager tag:(KInstructionsType)type resultData:(NSData*)data
{
    NSDictionary * dic = [DDUDPData decodingOfData:data];
    NSLog(@"接收到的数据dic ============= %@",dic);
}

- (void)host {
    NSLog(@"========1======");
}

- (void)iQiYiPlayMethod {
    //通过判断当前状态 切换显示状态
    if (_iQiYiPlayButton.buttonState == iQiYiPlayButtonStatePause) {
        _iQiYiPlayButton.buttonState = iQiYiPlayButtonStatePlay;
    }else {
        _iQiYiPlayButton.buttonState = iQiYiPlayButtonStatePause;
    }
    
    // tcp 服务端
//    [_tcpServer broadcastStr:@"服务端11111"];
    [_tcpClient disconnect];// 断开链接
    
//    //公钥
//    NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDl5RBHD3abOyeYCOLkaWkpJXgJQfMklOWPmdJAnG1eD6CV+UOpUKMy5LtfGHQEM7ao5x3BpMx4MNRUYVwBAmU84PhwNm6xpTJrg5zZCloFmsX+E5ukWE5YFRu8i5+5d8LuQTTTv4XfzbTCTOhON8uj+ypkomETuVNwgRFVFjHd1QIDAQAB";
//    //私钥
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOXlEEcPdps7J5gI4uRpaSkleAlB8ySU5Y+Z0kCcbV4PoJX5Q6lQozLku18YdAQztqjnHcGkzHgw1FRhXAECZTzg+HA2brGlMmuDnNkKWgWaxf4Tm6RYTlgVG7yLn7l3wu5BNNO/hd/NtMJM6E43y6P7KmSiYRO5U3CBEVUWMd3VAgMBAAECgYEAkqHVDQ4O35oOegmI9plJauYsNvNqqzWRalN5aJ6dn3YmPiI8Bt2ZClgcLt6A+UEmy3qGX0HG7Q5wD9X9geNOQB3ZiD/pGAGW08wS/wTxnWSnSBwdtZ03pUttfnFctkxULfDq4iG1ywdjqEk3F8QVFajQ0c76kWbt9LGAv2OGIi0CQQD2CmbVFXy4JeNHK3TDoLMjsUCiLa+qPnyyVDLDG9Ozb7wN2ydTrMhI+0udmjKvy/Lm1E2bKyp42iYuubEqvSAXAkEA7zNZsOgUe0q73sxXqrLQ7Fs7TNtIEXghrGmkVTHN0I7uMKzQ7KEbA6hfcBm4hPMoLa6Ag3m9tiMNBWtDWc/Y8wJAK0//dEl5EC3TSccTohCbGJBukV47i1u+teHuobw3U2I7F7FZxfgntflPAWqQu7PKieob01IRAv9cM2OLFbv/dwJBAIniXedeQMA5ekaaIEbjwQ8eH/bTyJ1ZVH/gfbwmc2+vlJo2ZFCjJcFcA3fJO9ZXnGeI2cfwG22sksr24+IXsAUCQG5yvVIleTDYqWuWVG1Rc8fk5UFjoZzJpp0nil0z+0fR5rogr4fxcH7vbWsE0id7gSvtV7KxPzkvJTpOK3yGDN0=";
//    //测试要加密的数据
//    NSString *sourceStr = @"iOS端RSA";
//    //公钥加密
//    NSString *encryptStr = [RSA encryptString:sourceStr publicKey:publicKey];
//    //私钥解密
//    NSString *decrypeStr = [RSA decryptString:encryptStr privateKey:privateKey];
//    NSLog(@"加密后的数据 %@ 解密后的数据 %@",encryptStr,decrypeStr);
    
    
    
//    // by PHP
//    encWithPubKey = @"CKiZsP8wfKlELNfWNC2G4iLv0RtwmGeHgzHec6aor4HnuOMcYVkxRovNj2r0Iu3ybPxKwiH2EswgBWsi65FOzQJa01uDVcJImU5vLrx1ihJ/PADUVxAMFjVzA3+Clbr2fwyJXW6dbbbymupYpkxRSfF5Gq9KyT+tsAhiSNfU6akgNGh4DENoA2AoKoWhpMEawyIubBSsTdFXtsHK0Ze0Cyde7oI2oh8ePOVHRuce6xYELYzmZY5yhSUoEb4+/44fbVouOCTl66ppUgnR5KjmIvBVEJLBq0SgoZfrGiA3cB08q4hb5EJRW72yPPQNqJxcQTPs8SxXa9js8ZryeSxyrw==";
//    decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
//    NSLog(@"(PHP enc)Decrypted with private key: %@", decWithPrivKey);
    
//    // Demo: encrypt with private key
//    encWithPrivKey = [RSA encryptString:originString privateKey:privkey];
//    NSLog(@"Enctypted with private key: %@", encWithPrivKey);
//
//    // Demo: decrypt with public key
//    decWithPublicKey = [RSA decryptString:encWithPrivKey publicKey:pubkey];
//    NSLog(@"(PHP enc)Decrypted with public key: %@", decWithPublicKey);
    
    
    
//    NIMSessionListViewController *vc = [[NIMSessionListViewController alloc] init];
//    NIMSession *session = [NIMSession session:@"1" type:NIMSessionTypeP2P];
//    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:session];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)youKuPlayMethod {
    //通过判断当前状态 切换显示状态
    if (_youKuPlayButton.buttonState == YouKuPlayButtonStatePause) {
        _youKuPlayButton.buttonState = YouKuPlayButtonStatePlay;
    }else {
        _youKuPlayButton.buttonState = YouKuPlayButtonStatePause;
    }
    
    // tcp 客户端
//    [_tcpClient writeString:@"客户端22222" withTag:[_tcpClient getWriteTag]];
    [_tcpClient writeString:@"7E 00 01 13 00 03 00 00 00 00 03 00 7E" withTag:[_tcpClient getWriteTag]];
    
    
    udpData.eventTpyeId = DDUDPDataType_UploadingMessage;
    udpData.MessageNo = 1;
    udpData.schoolId = 2;
    udpData.carNo = 123;
    udpData.trainingStatus = 3;
    udpData.studentId = 1234;
    udpData.cocoaId = 12345;
    udpData.trainingType = 1;
    udpData.trainingStartTime = 2134123241212412;
    udpData.speed = (int)(0.1 * 100);
    udpData.longitude = 1  * 1000000;
    udpData.latitude = 1 * 1000000;
    udpData.headingAngle = 1;
    udpData.pitchAngle = 0;
    udpData.altitude = 1;
//    [mediaSocketManager writeUDPGPSData:[udpData encodingData]];
    
    
//    NSString *postUrl = @"http://192.168.27.55:8081/secRest/homepage/uploadPhoto.do";//URL
//    UIImage *image = [UIImage imageNamed:@"1.jpg"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);//image为要上传的图片(UIImage)
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer    = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = nil;
//    [manager.requestSerializer setTimeoutInterval:30.0];
//    [manager.requestSerializer setValue:@"form/data" forHTTPHeaderField:@"Content-Type"];
//
//    [manager POST:postUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
//        //二进制文件，接口key值，文件路径，图片格式
//        NSLog(@"imageData=====%@",imageData);
//        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject======%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error======%@",error);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
