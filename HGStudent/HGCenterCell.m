//
//  HGCenterCell.m
//  HGStudent
//
//  Created by DoronXC on 2017/1/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGCenterCell.h"

@implementation HGCenterCell {

    UICollectionView *_collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HGCollectionCell"];
    }
    return self;
}

- (void)initUI {

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collect"]];
    imageView.frame = CGRectMake(10, 10, 80, 80);
    [self.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"智能VIP班";
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.text = @"我要报名";
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//       make
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(imageView.right + 10, 40, kScreenWidth - 110, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:lineView];
    
    //
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(100, 30);
//    layout.minimumInteritemSpacing = 10;
//    layout.minimumLineSpacing = 10;
//    
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(imageView.right + 10, 60, kScreenWidth - 110, 130) collectionViewLayout:layout];
//    [self.contentView addSubview:_collectionView];
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    _collectionView.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 30);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(imageView.right + 10, 60, kScreenWidth - 110, 30) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.backgroundColor = [UIColor blackColor];
}

#pragma mark -----UICollection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HGCollectionCell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"11111";
    [label sizeToFit];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"111111111");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
