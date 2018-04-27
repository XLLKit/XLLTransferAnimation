//
//  XLLPushPopTransition.h
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/26.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XLLPushPopTransition : NSObject <UINavigationControllerDelegate>

/**
 在控制器上放置手势

 @param vc 控制器载体
 */
- (void)addGestureOnVC:(UIViewController *)vc;

@end
