//
//  UITabBarController+XLLTransfer.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/28.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "UITabBarController+XLLTransfer.h"
#import "XLLTransferAnimation.h"
#import "XLLTransferInteractive.h"
#import <objc/runtime.h>
#import "XLLNavigationController.h"

@interface XLLTabbarControllerDelegate : NSObject <UITabBarControllerDelegate>

//内部代理
@property (nonatomic, weak) id insideDelegate;
//外部代理
@property (nonatomic, weak) id outsideDelegate;
@property (nonatomic, strong) Protocol *protocol;
 
@end

@implementation XLLTabbarControllerDelegate

#pragma mark - lazy loading
- (Protocol *)protocol
{
    if (_protocol == nil)
    {
        _protocol = objc_getProtocol("UITabBarControllerDelegate");
    }
    return _protocol;
}

//重写响应方法
- (BOOL)respondsToSelector:(SEL)aSelector
{
    struct objc_method_description des = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    if (des.types == NULL)
    {
        //1.如果不是此协议内的SEL，走系统判定
        return [super respondsToSelector:aSelector];
    }
    //2.协议内SEL是否响应，由内外部代理是否实现了说的算
    if ([self.insideDelegate respondsToSelector:aSelector] || [self.outsideDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    //3.内外部如果没有实现协议内SEL，系统来判定
    return [super respondsToSelector:aSelector];
}

//消息转发，让真正的内外部代理实现方法
//获取方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *insideSign = [self.insideDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature *outsideSign = [self.outsideDelegate methodSignatureForSelector:aSelector];
    return insideSign?:outsideSign?:nil;
}

//指定消息转发target
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = anInvocation.selector;
    //1.以内部代理为主，如果内部代理响应，则让内部代理先执行
    BOOL isResponse = NO;
    if ([self.insideDelegate respondsToSelector:selector])
    {
        [anInvocation invokeWithTarget:self.insideDelegate];
        isResponse = YES;
    }
    if ([self.outsideDelegate respondsToSelector:selector])
    {
        [anInvocation invokeWithTarget:self.outsideDelegate];
        isResponse = YES;
    }
    //2.如果内外部都没实现此方法，却调用了，抛出unRecognize..经典报错
    if (!isResponse)
    {
        [self doesNotRecognizeSelector:selector];
    }
}

@end


@interface UITabBarController ()

/**
 转场动画
 */
@property (nonatomic, strong) XLLTransferAnimation *transferAnimation;
/**
 转场驱动手势
 */
@property (nonatomic, strong) XLLTransferInteractive *transferInteractive;

@end

@implementation UITabBarController (XLLTransfer)
static const void *myDelegate_Key = &myDelegate_Key;

#pragma mark - setter, getter
- (void)setTransferAnimation:(XLLTransferAnimation *)transferAnimation
{
    objc_setAssociatedObject(self, @selector(transferAnimation), transferAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XLLTransferAnimation *)transferAnimation
{
    XLLTransferAnimation *transferAnimation = objc_getAssociatedObject(self, @selector(transferAnimation));
    if (transferAnimation == nil)
    {
        self.transferAnimation = transferAnimation = [[XLLTransferAnimation alloc] initWithAnimationStyle:XLLAnimationStyleTab];
    }
    return transferAnimation;
}

- (void)setTransferInteractive:(XLLTransferInteractive *)transferInteractive
{
    objc_setAssociatedObject(self, @selector(transferInteractive), transferInteractive, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XLLTransferInteractive *)transferInteractive
{
    XLLTransferInteractive *transferInteractive = objc_getAssociatedObject(self, @selector(transferInteractive));
    if (transferInteractive == nil)
    {
        self.transferInteractive = transferInteractive = [[XLLTransferInteractive alloc] initWithInteractiveStyle:XLLTransferInteractiveTabSelect];
    }
    return transferInteractive;
}

//编译时方法交换
+ (void)load
{
    Method originMethod = class_getInstanceMethod(self, @selector(setDelegate:));
    Method myMethod = class_getInstanceMethod(self, @selector(setMyDelegate:));
    method_exchangeImplementations(originMethod, myMethod);
}

- (void)setMyDelegate:(id <UITabBarControllerDelegate>)delegate
{
    XLLTabbarControllerDelegate *myDelegate = [[XLLTabbarControllerDelegate alloc] init];
    myDelegate.insideDelegate = self;
    myDelegate.outsideDelegate = delegate;
    [self setMyDelegate:myDelegate];
    objc_setAssociatedObject(self, myDelegate_Key, myDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //生成手势
    [self.transferInteractive addGestureOnVC:self];
}

#pragma mark - UITabBarControllerDelegate
// 切换动画代理
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC
{
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    self.transferAnimation.transferStyle = (toIndex < fromIndex)?XLLTransferStyleLeftDirection:XLLTransferStyleRightDirection;
    return self.transferAnimation;
}

//切换手势驱动代理
- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController
{
    return self.transferInteractive.isGestureTransfer?self.transferInteractive:nil;
}

@end
