//
//  HGStudyViewController.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGStudyViewController.h"
#import "HGIntroViewController.h"
#import "UIImage+Extension.h"

//阅读器+朋友圈
#import "WXViewController.h"
#import "E_ScrollViewController.h"
#import "ContantHead.h"

@interface HGStudyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataSourceArr;
}

@end

@implementation HGStudyViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"学习2";
//    self.view.backgroundColor = [UIColor greenColor];
    
    [self initUI];
    
    [self setupNavBar];
}
- (void)initUI {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 100, kScreenWidth - 20, 50);
    button.backgroundColor = [UIColor colorWithWhite:.3 alpha:.3];
    [button setTitle:@"push" forState:UIControlStateNormal];
    button.tag = 1;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    /////======================
    _dataSourceArr = @[@"阅读器",@"朋友圈"];
    
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, self.view.frame.size.height - 230)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
}
- (void)setupNavBar
{
    //这种效果只能这样做，隐藏之前的UINavigationBar，重新创建
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth, kNavigationBarHeight)] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    navItem.title = @"学习2";
}

- (void)clickButton:(UIButton *)button {

    if (button.tag == 1) {
        
        HGIntroViewController *hgInVC = [[HGIntroViewController alloc] init];
        [self.navigationController pushViewController:hgInVC animated:YES];
    }else if (button.tag == 2) {
    
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
    
        NSLog(@"hhh");
    }
}

#pragma mark --- 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [_dataSourceArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_dataSourceArr objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
        [self presentViewController:loginvctrl animated:NO completion:NULL];
        
    }else{
        WXViewController *wxVc = [WXViewController new];
        [self presentViewController:wxVc animated:YES completion:NULL];
        
    }
    
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
