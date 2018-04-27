//
//  XLLModalTransition.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/26.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLModalTransition.h"
#import "XLLTransferAnimation.h"
#import "XLLTransferInteractive.h"

@interface XLLModalTransition ()

/**
 自定义转场动画
 */
@property (nonatomic, strong) XLLTransferAnimation *transferAnimation;
/**
 转场手势
 */
@property (nonatomic, strong) XLLTransferInteractive *transferInteractive;

@end

@implementation XLLModalTransition

#pragma mark - lazy loading
- (XLLTransferAnimation *)transferAnimation
{
    if (_transferAnimation == nil)
    {
        _transferAnimation = [[XLLTransferAnimation alloc] initWithAnimationStyle:XLLAnimationStyleKuGou];
    }
    return _transferAnimation;
}

- (XLLTransferInteractive *)transferInteractive
{
    if (_transferInteractive == nil)
    {
        _transferInteractive = [[XLLTransferInteractive alloc] initWithInteractiveStyle:XLLTransferInteractiveModal];
    }
    return _transferInteractive;
}

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
    //这里我们初始化dismissType
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

@end
