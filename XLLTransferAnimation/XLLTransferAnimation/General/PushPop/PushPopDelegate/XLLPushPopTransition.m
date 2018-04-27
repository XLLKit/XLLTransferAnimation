//
//  XLLPushPopTransition.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/26.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLPushPopTransition.h"
#import "XLLTransferAnimation.h"
#import "XLLTransferInteractive.h"

@interface XLLPushPopTransition ()

/**
 自定义动画
 */
@property (nonatomic, strong) XLLTransferAnimation *transferAnimation;
/**
 转场手势
 */
@property (nonatomic, strong) XLLTransferInteractive *transferInteractive;

@end

@implementation XLLPushPopTransition

#pragma mark - lazy loading
- (XLLTransferAnimation *)transferAnimation
{
    if (_transferAnimation == nil)
    {
        _transferAnimation = [[XLLTransferAnimation alloc] initWithAnimationStyle:XLLAnimationStyleCircle];
    }
    return _transferAnimation;
}

- (XLLTransferInteractive *)transferInteractive
{
    if (_transferInteractive == nil)
    {
        _transferInteractive = [[XLLTransferInteractive alloc] initWithInteractiveStyle:XLLTransferInteractiveShow];
    }
    return _transferInteractive;
}

- (void)addGestureOnVC:(UIViewController *)vc
{
    [self.transferInteractive addGestureOnVC:vc];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    self.transferAnimation.transferStyle = (operation == UINavigationControllerOperationPush)?XLLTransferStylePush:XLLTransferStylePop;
    return self.transferAnimation;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.transferAnimation.transferStyle == XLLTransferStylePop?(self.transferInteractive.isGestureTransfer?self.transferInteractive:nil):nil;
}

@end
