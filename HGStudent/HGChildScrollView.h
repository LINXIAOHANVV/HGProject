//
//  HGChildScrollView.h
//  HGStudent
//
//  Created by DoronXC on 2017/3/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGChildScrollViewDelegate <NSObject>

- (void)scrollViewEndSlideWithIndex:(NSInteger)index;

@end

@interface HGChildScrollView : UIScrollView

@property (weak, nonatomic) id<HGChildScrollViewDelegate> myDelegate;

- (instancetype)initWithFrame:(CGRect)frame ChildViewControllers:(NSArray *)children MaxCount:(NSInteger)maxCount;

- (void)scrollViewWithIndex:(NSInteger)index;

@end
