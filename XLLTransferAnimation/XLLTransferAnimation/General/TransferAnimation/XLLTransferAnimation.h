//
//  XLLTransferAnimation.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/24.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//  转场动画类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 转场类型
 */
typedef NS_ENUM(NSInteger, XLLTransferStyle) {
    
    XLLTransferStylePush = 1000, //push
    XLLTransferStylePop,         //pop
    XLLTransferStylePresent,     //present
    XLLTransferStyleDismiss      //dismiss
};

/**
 转场动画类型
 */
typedef NS_ENUM(NSInteger, XLLAnimationStyle) {
    
    XLLAnimationStyleDoor = 1000, //开门动画
    XLLAnimationStyleCircle,      //圆形扩展动画
    XLLAnimationStyleKuGou        //酷狗音乐那种动画
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
 转场类型
 */
@property (nonatomic, assign) XLLTransferStyle transferStyle;

@end
