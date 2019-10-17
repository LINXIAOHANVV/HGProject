//
//  HGTypeScrollView.h
//  HGStudent
//
//  Created by DoronXC on 2017/3/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGTypeScrollViewDelegate <NSObject>

- (void)didTypeWithIndex:(NSInteger)index;

@end
@interface HGTypeScrollView : UIScrollView

@property (weak, nonatomic) id<HGTypeScrollViewDelegate> myDelegate;

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titels;
- (void)selectedButtonForIndex:(NSInteger)index;

@end
