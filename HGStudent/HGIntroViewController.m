//
//  HGIntroViewController.m
//  HGStudent
//
//  Created by DoronXC on 2017/2/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGIntroViewController.h"
#import "HGScrollView.h"
#import "HGHeaderView.h"
#import "HGBottomView.h"
#import "UIImage+Extension.h"
#import "UIBarButtonItem+Extension.h"

@interface HGIntroViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HGScrollView *hgScrollView;
@property (nonatomic, strong) HGHeaderView *hgHeaderView;
@property (nonatomic, strong) HGBottomView *hgBottomView;

@end

@implementation HGIntroViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//- (void)viewDidDisappear:(BOOL)animated {
//
//    [super viewDidDisappear:animated];
//    [self.view removeFromSuperview];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];//----无作用
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self setupNavBar];
}

- (void)initUI {
    
    _hgScrollView = [[HGScrollView alloc] initWithFrame:self.view.bounds];
    _hgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    _hgScrollView.contentInset = UIEdgeInsetsMake(265, 0 , 50, 0);
    [_hgScrollView setContentOffset:CGPointMake(0, -265)];
    _hgScrollView.delegate = self;
    [self.view addSubview:_hgScrollView];
    
    _hgHeaderView = [[HGHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 265)];
    _hgHeaderView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_hgHeaderView];
    
    _hgBottomView = [[HGBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    _hgBottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_hgBottomView];
}
- (void)setupNavBar
{
    //这种效果只能这样做，隐藏之前的UINavigationBar，重新创建
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [navBar setTintColor:[UIColor whiteColor]];
    [self.view addSubview:navBar];
    [navBar setShadowImage:[[UIImage alloc] init]];

    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, kNavigationBarHeight)] forBarMetrics:UIBarMetricsDefault];
    navItem.title = @"项目介绍";
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 30, 30);
    [left setImage:[UIImage imageNamed:@"btn_backItem"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didItemClick:(UIButton *)button
{
    if (button.tag == 0) {
        
    }else {
        button.selected = !button.selected;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_hgHeaderView updateSubViewsWithScrollOffsetY:scrollView.contentOffset.y];
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
