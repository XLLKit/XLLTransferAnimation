//
//  XLLTransferInteractive.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/25.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLTransferInteractive.h"

@interface XLLTransferInteractive ()

@property (nonatomic, assign, readwrite) BOOL gestureTransfer;
@property (nonatomic, assign) XLLInteractiveStyle interactiveStyle;

@end

@implementation XLLTransferInteractive

- (instancetype)initWithInteractiveStyle:(XLLInteractiveStyle)interactiveStyle
{
    if (self = [super init])
    {
        self.interactiveStyle = interactiveStyle;
    }
    return self;
}

- (void)addGestureOnVC:(UIViewController *)vc
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [vc.view addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:panGesture.view];
    //左右滑动的百分比
    CGFloat percentComplete = fabs(translation.x) / panGesture.view.frame.size.width;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.gestureTransfer = YES;
            UIViewController *currentVC = [self getCurrentController:panGesture.view];
            if (self.interactiveStyle == XLLTransferInteractiveShow)
            {
                if ([currentVC isKindOfClass:[UINavigationController class]])
                {
                    UINavigationController *nav = (UINavigationController *)currentVC;
                    [nav popViewControllerAnimated:YES];
                } else {
                    [currentVC.navigationController popViewControllerAnimated:YES];
                }
            } else if (self.interactiveStyle == XLLTransferInteractiveModal) {
                if ([currentVC isKindOfClass:[UINavigationController class]])
                {
                    UINavigationController *nav = (UINavigationController *)currentVC;
                    [nav dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [currentVC dismissViewControllerAnimated:YES completion:nil];
                }
            } else if (self.interactiveStyle == XLLTransferInteractiveTabSelect) {
                
                if ([currentVC isKindOfClass:[UITabBarController class]])
                {
                    UITabBarController *tabVC = (UITabBarController *)currentVC;
                    UINavigationController *nav = tabVC.selectedViewController;
                    if (nav.childViewControllers.count > 1)
                    {
                        // push到第二层，tabbar隐藏，就不需要转场了
                        return;
                    }
                    CGFloat velocityX = [panGesture velocityInView:panGesture.view].x;
                    tabVC.selectedIndex = velocityX<0?tabVC.selectedIndex+1:tabVC.selectedIndex-1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:percentComplete];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.gestureTransfer = NO;
            if (percentComplete > 0.35)
            {
                [self finishInteractiveTransition];
            } else {
                //这里首先将进度更为0.否则会有闪烁bug。
                //原因已定位,目前还没来得及解决
                [self updateInteractiveTransition:0];
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
            self.gestureTransfer = NO;
            [self updateInteractiveTransition:0];
            [self cancelInteractiveTransition];
            break;
    }
}

/**
 *  返回当前视图的控制器
 */
- (UIViewController *)getCurrentController:(UIView *)view
{
    UIResponder *responder = [view nextResponder];
    while (responder)
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
