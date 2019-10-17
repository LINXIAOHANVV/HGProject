//
//  BaseTabBarController.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

#import "HGHomeViewController.h"
#import "HGStudyViewController.h"
#import "HGMyViewController.h"
#import "HGMoreViewController.h"

//tabbar tuqi
#import "HGTabBar.h"
#import "HGMiddleVC.h"

@interface BaseTabBarController ()

//tabbar 凸起 - 需要
@property (nonatomic, strong) HGHomeViewController *oneVC;
@property (nonatomic, strong) HGStudyViewController *twoVC;
@property (nonatomic, strong) HGMyViewController *threeVC;
@property (nonatomic, strong) HGMoreViewController *fourVC;

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //正常的
    [self initTabbarItem];
    
    //tabbar突起
//    [self InitView];
//    [self InitMiddleView];
    
    //有选中图片的
}

-(void)initTabbarItem{
    
    HGHomeViewController *home = [[HGHomeViewController alloc]init];
    [self controller:home title:@"首页" image:@"icon_tabbar_homepage" selectedimage:@"icon_tabbar_homepage_selected"];
    
    HGStudyViewController *business = [[HGStudyViewController alloc]init];
    [self controller:business title:@"学习" image:@"icon_tabbar_merchant_normal" selectedimage:@"icon_tabbar_merchant_selected"];
    
    HGMyViewController *me = [[HGMyViewController alloc]init];
    [self controller:me title:@"我的" image:@"icon_tabbar_mine" selectedimage:@"icon_tabbar_mine_selected"];
    
    HGMoreViewController *more = [[HGMoreViewController alloc]init];
    [self controller:more title:@"更多" image:@"icon_tabbar_misc" selectedimage:@"icon_tabbar_misc_selected"];
    
    //测试6个tabbar ---- 最多只显示5个
//    HGMoreViewController *more1 = [[HGMoreViewController alloc]init];
//    [self controller:more1 title:@"我的" image:@"icon_tabbar_mine" selectedimage:@"icon_tabbar_mine_selected"];
//    HGMoreViewController *more2 = [[HGMoreViewController alloc]init];
//    [self controller:more2 title:@"首页" image:@"icon_tabbar_homepage" selectedimage:@"icon_tabbar_homepage_selected"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}

//初始化一个控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage
{
    TS.tabBarItem.title = title;
    TS.tabBarItem.image = [UIImage imageNamed:image];
    TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:TS];
    [self addChildViewController:nav];
}


- (void)InitMiddleView
{
    HGTabBar *tabBar = [[HGTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar setDidMiddBtn:^{
        HGMiddleVC *vc = [[HGMiddleVC alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//        self.selectedIndex = 2;
        [self presentViewController:nav animated:YES completion:nil];
//        [self.navigationController pushViewController:nav animated:YES];
    }];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@" --- %@", item.title);
    
}

- (void)InitView
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"首页", @"学习", @"我的", @"更多"];
    NSArray *images = @[@"icon_tabbar_homepage", @"icon_tabbar_merchant_normal", @"icon_tabbar_mine", @"icon_tabbar_misc"];
    NSArray *selectedImages = @[@"icon_tabbar_homepage_selected", @"icon_tabbar_merchant_selected", @"icon_tabbar_mine_selected", @"icon_tabbar_misc_selected"];
    HGHomeViewController * oneVc = [[HGHomeViewController alloc] init];
    self.oneVC = oneVc;
    HGStudyViewController * twoVc = [[HGStudyViewController alloc] init];
    self.twoVC = twoVc;
    HGMyViewController * threeVc = [[HGMyViewController alloc] init];
    self.threeVC = threeVc;
    HGMoreViewController * fourVc = [[HGMoreViewController alloc] init];
    self.fourVC = fourVc;
    NSArray *viewControllers = @[oneVc, twoVc, threeVc, fourVc];
    for (int i = 0; i < viewControllers.count; i++)
    {
        UIViewController *childVc = viewControllers[i];
        [self setVC:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)setVC:(UIViewController *)VC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    VC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [VC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    VC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:VC];
    [self addChildViewController:nav];
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
