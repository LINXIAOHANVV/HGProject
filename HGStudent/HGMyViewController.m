//
//  HGMyViewController.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGMyViewController.h"
#import "HGShowOneViewController.h"
#import "HGShowTwoViewController.h"

#import "HGTypeScrollView.h"
#import "HGChildScrollView.h"

@interface HGMyViewController ()<HGTypeScrollViewDelegate, HGChildScrollViewDelegate>

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) UIButton *cityBtn;
@property (strong, nonatomic) HGTypeScrollView *typeScrollView;
@property (strong, nonatomic) HGChildScrollView *childScrollView;
//@property (strong, nonatomic) ShowSelectTypeView *timeTypeView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIButton *rightBtn;

@end

@implementation HGMyViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的3";
    self.automaticallyAdjustsScrollViewInsets = NO;//禁止自动滑动
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    
    [self initUI];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCityNotification:) name:@"SelectCityNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTypeNotification:) name:@"ShowSelectTypeNotification" object:nil];
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"全部分类",@"演唱会",@"音乐会",@"话剧歌剧",@"舞蹈芭蕾",@"曲苑杂坛",@"体育比赛",@"度假休闲",@"周边商品",@"儿童亲子",@"动漫"];
    }
    return _titles;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewClick)]];
    }
    return _bgView;
}

- (void)didBgViewClick
{
//    [self didRightClick:self.rightBtn];
}

- (void)setupNavBar
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.view addSubview:navBar];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F4153D"] size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    navItem.title = @"演出";
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn setTitle:@"武汉" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"btn_cityArrow"] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(didBgViewClick) forControlEvents:UIControlEventTouchUpInside];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    self.cityBtn = cityBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[[UIImage imageNamed:@"icon_screening_bottom_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(didBgViewClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.size = rightBtn.currentImage.size;
    self.rightBtn = rightBtn;
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [navBar setTintColor:[UIColor whiteColor]];
    
//    [self.view insertSubview:self.timeTypeView belowSubview:navBar];
}

- (void)initUI {
    
    HGTypeScrollView *typeView = [[HGTypeScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, 40) Titles:self.titles];
    typeView.myDelegate = self;
    typeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:typeView];
    self.typeScrollView = typeView;
    
    HGChildScrollView *scrollView = [[HGChildScrollView alloc] initWithFrame:CGRectMake(0, typeView.bottom, kScreenWidth, kScreenHeight - typeView.bottom) ChildViewControllers:self.childViewControllers MaxCount:self.titles.count];
    scrollView.myDelegate = self;
    [self.view addSubview:scrollView];
    self.childScrollView = scrollView;
}

//- (void)clickButton:(UIButton *)button {
//    
//    HGShowOneViewController *hgShowVC = [[HGShowOneViewController alloc] init];
//    [self.navigationController pushViewController:hgShowVC animated:YES];
//}

#pragma HGTypeScrollViewDelegate
- (void)didTypeWithIndex:(NSInteger)index {

    [self.childScrollView scrollViewWithIndex:index];
}
#pragma HGChildScrollViewDelegate
- (void)scrollViewEndSlideWithIndex:(NSInteger)index {

    [self.typeScrollView selectedButtonForIndex:index];
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
