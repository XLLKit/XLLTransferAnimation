//
//  UITabBarController+XLLTransfer.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//  因为用户在开发过程中，会经常使用UITabbarControllerDelegate, 所以我并不采用单独一个类作为其代理，这样太自私了。
//  采用交换自定义方法，偷偷将代理设为自己的类。然后使用消息转发机制，将协议方法的实现分发给两个代理

#import <UIKit/UIKit.h>
#import "XLLTransferStyle.h"

@interface UITabBarController (XLLTransfer)


@end
