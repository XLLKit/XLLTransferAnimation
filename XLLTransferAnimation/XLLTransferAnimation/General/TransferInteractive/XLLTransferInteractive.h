//
//  XLLTransferInteractive.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/25.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 手势类型
 */
typedef NS_ENUM(NSInteger, XLLInteractiveStyle) {
    
    XLLTransferInteractiveShow = 1000, //push pop
    XLLTransferInteractiveModal        //present dismiss
};

@interface XLLTransferInteractive : UIPercentDrivenInteractiveTransition

//禁用方法
- (instancetype)init __attribute__((unavailable("请使用initWithVC:interactiveStyle:方法")));
- (instancetype)new __attribute__((unavailable("请使用initWithVC:interactiveStyle:方法")));

/**
 初始化手势转场实例

 @param interactiveStyle 手势转场类型
 @return 实例
 */
- (instancetype)initWithInteractiveStyle:(XLLInteractiveStyle)interactiveStyle;

/**
 控制器上放置手势

 @param vc 控制器载体
 */
- (void)addGestureOnVC:(UIViewController *)vc;

/**
 是否为手势触发的转场
 */
@property (nonatomic, assign, readonly, getter=isGestureTransfer) BOOL gestureTransfer;

@end
