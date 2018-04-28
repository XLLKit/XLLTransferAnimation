//
//  XLLTransferDelegate.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLTransferDelegate.h"
#import "XLLTransferAnimation.h"
#import "XLLTransferInteractive.h"

@interface XLLTransferDelegate ()

/**
 转场动画
 */
@property (nonatomic, strong) XLLTransferAnimation *transferAnimation;
/**
 转场手势驱动
 */
@property (nonatomic, strong) XLLTransferInteractive *transferInteractive;

@end

@implementation XLLTransferDelegate

- (instancetype)initWithAnimationStyle:(XLLAnimationStyle)animationStyle InteractiveStyle:(XLLInteractiveStyle)interactiveStyle
{
    if (self = [super init])
    {
        //初始化两个关键属性
        self.transferAnimation = [[XLLTransferAnimation alloc] initWithAnimationStyle:animationStyle];
        self.transferInteractive = [[XLLTransferInteractive alloc] initWithInteractiveStyle:interactiveStyle];
    }
    return self;
}

#pragma mark - public method
- (void)addGestureOnVC:(UIViewController *)vc
{
    [self.transferInteractive addGestureOnVC:vc];
}

#pragma mark - UIViewControllerTransitioningDelegate
//返回一个处理present动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transferAnimation.transferStyle = XLLTransferStylePresent;
    return self.transferAnimation;
}

//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transferAnimation.transferStyle = XLLTransferStyleDismiss;
    return self.transferAnimation;
}

//返回一个处理dismiss手势过渡的对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.transferInteractive.isGestureTransfer?self.transferInteractive:nil;
}

//返回一个处理present手势过渡的对象
// - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
// {
//     return self.transferInteractive;
// }


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
