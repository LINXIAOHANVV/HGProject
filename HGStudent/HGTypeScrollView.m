//
//  HGTypeScrollView.m
//  HGStudent
//
//  Created by DoronXC on 2017/3/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGTypeScrollView.h"

@interface HGTypeScrollView ()

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *button;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation HGTypeScrollView

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titels
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titels;
        self.showsHorizontalScrollIndicator = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI {

    CGFloat margin = 15;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#F4153D"] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.tag = i;
        [button addTarget:self action:@selector(didTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button.top = 0;
        button.left = margin + i * 20;
        button.width = [button.titleLabel getTextWidth] + 6;
        button.height = self.height;
        margin += button.width;
        if (i == 0) {
            button.enabled = NO;
            self.button = button;
        }
        if (i == self.titles.count - 1) {
            self.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + 15, self.height);
        }
        
        NSLog(@"%@",NSStringFromCGSize(self.contentSize));
        NSLog(@"%@",NSStringFromCGRect(self.frame));
    }
    //底部的线
    UIView *lineView = [[UIView alloc] init];
    lineView.top = self.height - 2;
    lineView.height = 2;
    lineView.width = self.button.width;
    lineView.centerX = self.button.centerX;
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F4153D"];
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)didTypeClick:(UIButton *)button
{
    self.button.enabled = YES;
    button.enabled = NO;
    self.button = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.width = button.width;
        self.lineView.centerX = button.centerX;
    }];
    
    if ([self.myDelegate respondsToSelector:@selector(didTypeWithIndex:)]) {
        [self.myDelegate didTypeWithIndex:button.tag];
    }
    if (button.left + button.width / 2  < self.width / 2) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    if (button.left + button.width / 2 > self.contentSize.width - self.width / 2) {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.width, 0) animated:YES];
        return;
    }
    CGRect rect = [button.superview convertRect:button.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat centerX = rect.origin.x + rect.size.width / 2;
    CGFloat offsetX = 0;
    if (centerX < self.width / 2) {
        offsetX = self.width / 2 - centerX;
        [self setContentOffset:CGPointMake(self.contentOffset.x - offsetX, 0) animated:YES];
    }else if (centerX > self.width / 2){
        offsetX = centerX - self.width / 2;
        [self setContentOffset:CGPointMake(self.contentOffset.x + offsetX, 0) animated:YES];
    }
}

- (void)selectedButtonForIndex:(NSInteger)index {

    if (self.currentIndex == index) {
        return;
    }
    [self didTypeClick:self.subviews[index]];
    self.currentIndex = index;
}


@end
