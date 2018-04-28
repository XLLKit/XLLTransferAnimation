//
//  XLLTransferAnimation.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/24.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//  转场动画类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XLLTransferStyle.h"

/**
 具体转场类型
 */
typedef NS_ENUM(NSInteger, XLLTransferStyle) {
    
    XLLTransferStylePush = 1000,  //push
    XLLTransferStylePop,          //pop
    XLLTransferStylePresent,      //present
    XLLTransferStyleDismiss,      //dismiss
    XLLTransferStyleLeftDirection,//tabbar向左滑动
    XLLTransferStyleRightDirection//tabbar向右滑动
};

@interface XLLTransferAnimation : NSObject <UIViewControllerAnimatedTransitioning>

//禁用方法
- (instancetype)init __attribute__((unavailable("请使用initWithAnimationStyle:方法")));
- (instancetype)new __attribute__((unavailable("请使用initWithAnimationStyle:方法")));

/**
 初始化方法

 @param animationStyle 动画类型
 @return 实例对象
 */
- (instancetype)initWithAnimationStyle:(XLLAnimationStyle)animationStyle;

/**
 具体转场类型
 */
@property (nonatomic, assign) XLLTransferStyle transferStyle;

@end
