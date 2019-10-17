//
//  HGHeaderCell.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGHeaderCell.h"

@implementation HGHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //注册方式不同，此处不走
//    [self initSDCycleScrollView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSDCycleScrollView];
    }
    return self;
}

- (void)initSDCycleScrollView {
    
    SDCycleScrollView *sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) imageNamesGroup:@[@"icon_homepage_hotelCategory",@"icon_homepage_default",@"icon_homepage_lifeServiceCategory"]];
    [self.contentView addSubview:sdc];
    
    //
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, sdc.bottom, kScreenWidth, 30)];
    bottomView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:bottomView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
