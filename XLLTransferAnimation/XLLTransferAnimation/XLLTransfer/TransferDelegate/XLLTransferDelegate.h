//
//  XLLTransferDelegate.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XLLTransferStyle.h"

@interface XLLTransferDelegate : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

//禁用方法
- (instancetype)init __attribute__((unavailable("请使用initWithAnimationStyle:InteractiveStyle:方法")));
- (instancetype)new __attribute__((unavailable("请使用initWithAnimationStyle:InteractiveStyle:方法")));

/**
 初始化方法

 @param animationStyle 动画类型 （目前只提供三种动画类型，两个UIView动画，一个核心动画）
 @param interactiveStyle 手势转场类型
 @return 实例对象
 */
- (instancetype)initWithAnimationStyle:(XLLAnimationStyle)animationStyle InteractiveStyle:(XLLInteractiveStyle)interactiveStyle;

/**
 在第二控制器上放置手势
 
 @param vc 控制器载体
 
 @discussion 需要在push或present第二控制器前调用
 */
- (void)addGestureOnVC:(UIViewController *)vc;

@end
