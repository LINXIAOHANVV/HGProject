//
//  HGHomeViewController.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGHomeViewController.h"
#import "HGHeaderCell.h"
#import "HGCenterCell.h"
#import "HGBottomCell.h"
#import "DBManager.h"

#import "HGHomeAViewController.h"
#import "HGHomeViewModel.h"
#import <ARKit/ARKit.h>

@interface HGHomeViewController ()<UITableViewDelegate, UITableViewDataSource, ARSCNViewDelegate>

@property (nonatomic, strong) HGHomeViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) NSArray *aArr;
@property (nonatomic, strong) NSArray *bArr;
@property (nonatomic, strong) NSMutableArray *cArr; //可变类型只能使用 strong 修饰，copy修饰会崩溃
@property (nonatomic, copy) NSMutableArray *dArr;

@property (nonatomic, strong) ARSCNView *sceneView;

@property WebViewJavascriptBridge* bridge;

@end

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页1";
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    NSLog(@"hhhhhhhh===%@",NSHomeDirectory());
    
    NSLog(@"1");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    [self initUI];
    self.aArr = self.dataArr;
    self.bArr = self.dataArr;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"1"];
//    self.cArr = [NSMutableArray array];
//    self.dArr = [NSMutableArray array];
//    [self.cArr addObject:@"1"];
//    [self.dArr addObject:@"1"];
//    NSLog(@"self.dArr == %@",self.dArr);
//    [self.cArr removeObject:@"1"];
//    [self.dArr removeObject:@"1"];
//    NSLog(@"self.dArr == %@",self.dArr);
    
//    [self loadData];
    
//    [self loadAR];
    
//    [self initWebView];
}

- (void)initWebView {
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
}

- (void)loadAR {
    self.sceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    // 1.设置场景视图的代理
    self.sceneView.delegate = self;
    // 是否显示fps或 timing等信息
    self.sceneView.showsStatistics = YES;
    //2. 创建场景
    SCNScene *scene = [SCNScene scene];
    //2.1  给场景视图绑定场景
    self.sceneView.scene = scene;
    //3.  创建一个平面几何图形，高为0.1米，宽为0.1米
    SCNPlane *plane = [SCNPlane planeWithWidth:0.1 height:0.1];
    //4.  基于几何图形创建节点
    SCNNode *node = [SCNNode nodeWithGeometry:plane]; // 节点的创建不仅仅是基于平面，根据SCNGeometry头文件里可见，长方体、圆球、圆锥、圆环、金字塔形等等都可以创建。有兴趣的可以换着尝试一下。
    //5.  创建渲染器
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor redColor];   // 渲染器可以决定怎样渲染，这个 contents属性可以设置很多东西，UILabel， UIImage，甚至 AVPlayer都可以
    node.position = SCNVector3Make(0, 0, -0.3);
    //5.5. 用渲染器对几何图形进行渲染
    plane.materials = @[material];
    //6. 为场景的根节点添加节点
    [scene.rootNode addChildNode:node];
}

//- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = YES;
//}

- (void)initUI {

    [self initTableView];
}
- (void)initTableView {

    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)loadData {
    self.viewModel = [[HGHomeViewModel alloc] init];
    [self.viewModel.successObject subscribeNext:^(id x) {
        HGHomeModel *model = x;
        self.dataArr = (NSArray *)model.data;
        [self.tableView reloadData];
    }];
    [self.viewModel.failureObject subscribeNext:^(id x) {
        HGHomeModel *model = x;
        self.dataArr = model.data;
    }];
    
    [self.viewModel exchangeData];
}

#pragma mark -- 

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}
//每一组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
    
        return self.dataArr.count;
    }else if (section == 2) {
    
        return 4;
    }
    return 1;
}
//cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 230;
    }else if (indexPath.section == 1) {
        
        return 200;
    }else if (indexPath.section == 2) {
        
        return 50;
    }
    return 50;
}
//头视图的高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 0;
    }else {
    
        return 5;
    }
}
//尾视图的高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 2) {
        
        return 0;
    }else {
    
        return 5;
    }
}
//每组的头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    hView.backgroundColor = [UIColor greenColor];
    return hView;
}
//每组的尾视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    fView.backgroundColor = [UIColor greenColor];
    return fView;
}
//定制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        HGHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGHeaderCell"];
        if (!cell) {
            
            cell = [[HGHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HGHeaderCell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        return cell;
    }else if (indexPath.section == 1) {
    
        HGCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGCenterCell"];
        if (!cell) {
            
            cell = [[HGCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HGCenterCell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        return cell;
    }else if (indexPath.section == 2) {
    
        HGBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGBottomCell"];
        if (!cell) {
            
            cell = [[HGBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HGBottomCell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        return cell;
    }

    return nil;
}
//cell的选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HGHomeAViewController *vc = [[HGHomeAViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
