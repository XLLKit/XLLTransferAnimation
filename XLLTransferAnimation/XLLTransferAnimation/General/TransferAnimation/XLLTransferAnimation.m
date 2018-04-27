//
//  XLLTransferAnimation.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/24.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLTransferAnimation.h"

// 角度转换
#define angelToRandian(x)  ((x)/180.0*M_PI)

@interface XLLTransferAnimation () <CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) XLLAnimationStyle animationStyle;

@end

@implementation XLLTransferAnimation

#pragma mark - lazy loading
- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil)
    {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (instancetype)initWithAnimationStyle:(XLLAnimationStyle)animationStyle
{
    if (self = [super init])
    {
        self.animationStyle = animationStyle;
    }
    return self;
}

#pragma mark - setter方法
- (void)setTransferStyle:(XLLTransferStyle)transferStyle
{
    _transferStyle = transferStyle;
    
}

#pragma mark - UIViewControllerAnimatedTransitioning
//动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.transferStyle) {
        case XLLTransferStylePop:
        case XLLTransferStylePush:
            return 0.3f;
        case XLLTransferStyleDismiss:
        case XLLTransferStylePresent:
            return 0.35f;
        default:
            break;
    }
}

//处理动画事务
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.transferStyle) {
        case XLLTransferStylePush:
        {
            //Default
            //[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [self pushOrPresentAnimateTransition:transitionContext];
        }
            break;
        case XLLTransferStylePop:
        {
            //Default
            //[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [self popOrDismissAnimateTransition:transitionContext];
        }
            break;
        case XLLTransferStylePresent:
        {
            //transitionContext 转场上下文
            //Default
            //[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [self pushOrPresentAnimateTransition:transitionContext];
        }
            break;
        case XLLTransferStyleDismiss:
        {
            //Default
            //[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [self popOrDismissAnimateTransition:transitionContext];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    id <UIViewControllerContextTransitioning>transitionContext = [anim valueForKey:@"transitionContext"];
    UIView *snapShotView = [anim valueForKey:@"snapShotView"];
    if (snapShotView) {
        
        [snapShotView removeFromSuperview];
        snapShotView = nil;
    }
    if ([transitionContext transitionWasCancelled]) {
        
        UIView *toView = [anim valueForKey:@"toView"];
        [toView removeFromSuperview];
    }
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

#pragma mark - private method
//根据设定的动画搞起来
- (void)pushOrPresentAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.animationStyle) {
        case XLLAnimationStyleDoor:
        {
            [self pushOrPresentDoorAnimation:transitionContext];
        }
            break;
        case XLLAnimationStyleCircle:
        {
            [self pushOrPresentCircleAnimation:transitionContext];
        }
            break;
        case XLLAnimationStyleKuGou:
        {
            [self pushOrPresentKuGouAnimation:transitionContext];
        }
            break;
            
        default:
            break;
    }
}

- (void)popOrDismissAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.animationStyle) {
        case XLLAnimationStyleDoor:
        {
            [self popOrDismissDoorAnimation:transitionContext];
        }
            break;
        case XLLAnimationStyleCircle:
        {
            [self popOrDismissCircleAnimation:transitionContext];
        }
            break;
        case XLLAnimationStyleKuGou:
        {
            [self popOrDismissKuGouAnimation:transitionContext];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - pop酷狗动画
- (void)popOrDismissKuGouAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.取出专场前后view
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //2.转场期间容器view
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    toView.transform = CGAffineTransformScale(toView.transform, 0.95, 0.95);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        CGFloat x = fromView.frame.size.width * 0.5;
        CGFloat y = fromView.frame.size.height * 0.5;
        CGFloat ac = calculateAB(x, y) * cos(calculateCAB(x, y));
        CGFloat bc = calculateAB(x, y) * sin(calculateCAB(x, y));
        CGFloat spacingX = ac;
        CGFloat spacingY = 50>bc?50-bc:bc-50;
        
        fromView.transform = CGAffineTransformMakeTranslation(spacingX, spacingY);
        fromView.transform = CGAffineTransformRotate(fromView.transform, angelToRandian(20));
        toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled])
        {
            fromView.transform = CGAffineTransformIdentity;
            toView.transform = CGAffineTransformIdentity;
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


#pragma mark - push酷狗动画
- (void)pushOrPresentKuGouAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.取出转场前后控制器view
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //2.转场容器
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
    //3.计算一开始的transfrom
    CGFloat x = fromView.frame.size.width * 0.5;
    CGFloat y = fromView.frame.size.height * 0.5;
    CGFloat ac = calculateAB(x, y) * cos(calculateCAB(x, y));
    CGFloat bc = calculateAB(x, y) * sin(calculateCAB(x, y));
    CGFloat spacingX = ac;
    CGFloat spacingY = 50>bc?50-bc:bc-50;
    
    toView.transform = CGAffineTransformTranslate(toView.transform, spacingX, spacingY);
    toView.transform = CGAffineTransformRotate(toView.transform, angelToRandian(20));
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        toView.transform = CGAffineTransformIdentity;
        fromView.transform = CGAffineTransformScale(fromView.transform, 0.95, 0.95);
    } completion:^(BOOL finished) {
        
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - 如看不明白，请移步至我的简书
//https://www.jianshu.com/p/18f5348e32c5
float calculateCAB (float x, float y) {
    
    //角bda
    float bda = atan(x/y)*2+angelToRandian(20);
    //角bad
    float bad = (M_PI - bda)*0.5;
    //角cad
    float cad = atan(y/x);
    //角cab
    float cab = cad-bad;
    return cab;
}

float calculateAB (float x, float y) {
    
    //等腰三角形adb的腰长
    float ad = sqrt(pow(x, 2) + pow(y, 2));
    //角bda
    float bda = atan(x/y)*2+angelToRandian(20);
    //角bad
    float bad = (M_PI - bda)*0.5;
    //边ab
    float ab = (ad * cos(bad))*2;
    return ab;
}

#pragma mark - pop圆形收缩动画(CALayer核心动画)
- (void)popOrDismissCircleAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.取出专场前后控制器View
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //2.专场期间容器
    UIView *containerView = transitionContext.containerView;
    //3.生成frameView快照
    UIView *snapShotView = [fromView snapshotViewAfterScreenUpdates:NO];
    //4.获取一开始的圆形路径
    CGFloat startRadius = 45.0;
//    CGRect startRect = CGRectMake(fromView.center.x - startRadius, fromView.center.y - startRadius, 2 * startRadius, 2 * startRadius);
//    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startRect cornerRadius:startRadius];
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:fromView.center radius:startRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //4.获取最后的圆形路径
    CGFloat endRadius = sqrt(fromView.center.x * fromView.center.x + fromView.center.y * fromView.center.y);
//    CGRect endRect = CGRectInset(startRect, -endRadius, -endRadius);
//    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:endRect cornerRadius:endRect.size.width * 0.5];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:fromView.center radius:endRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //5.创建shapeLayer作为视图的遮罩
    self.shapeLayer.path = endPath.CGPath;
    snapShotView.layer.mask = self.shapeLayer;
    [containerView addSubview:toView];
    [containerView addSubview:snapShotView];
    
    // 添加动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)endPath.CGPath;
    pathAnimation.toValue = (id)startPath.CGPath;
    pathAnimation.duration = [self transitionDuration:transitionContext];
//    pathAnimation.duration = 20;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.delegate = self;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [pathAnimation setValue:transitionContext forKey:@"transitionContext"];
    [pathAnimation setValue:snapShotView forKey:@"snapShotView"];
    [pathAnimation setValue:toView forKey:@"toView"];
    [self.shapeLayer addAnimation:pathAnimation forKey:nil];
}

#pragma mark - push圆形扩展动画(CALayer核心动画)
- (void)pushOrPresentCircleAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.取出专场前后控制器view
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //2.转场期间容器
    UIView *containerView = transitionContext.containerView;
    //3.获取一开始的圆形路径
    CGFloat startRadius = 45.0;
//    CGRect startRect = CGRectMake(fromView.center.x - startRadius, fromView.center.y - startRadius, 2 * startRadius, 2 * startRadius);
//    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startRect cornerRadius:startRadius];
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:fromView.center radius:startRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //4.获取最后的圆形路径
    CGFloat endRadius = sqrt(fromView.center.x * fromView.center.x + fromView.center.y * fromView.center.y);
//    CGRect endRect = CGRectInset(startRect, -endRadius, -endRadius);
//    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:endRect cornerRadius:endRect.size.width * 0.5];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:fromView.center radius:endRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //5.创建shapeLayer作为视图的遮罩
    self.shapeLayer.path = startPath.CGPath;
    toView.layer.mask = self.shapeLayer;
    
    [containerView addSubview:toView];
    // 添加动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)startPath.CGPath;
    pathAnimation.toValue = (id)endPath.CGPath;
    pathAnimation.duration = [self transitionDuration:transitionContext];
//    pathAnimation.duration = 20;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.delegate = self;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [pathAnimation setValue:transitionContext forKey:@"transitionContext"];
    [self.shapeLayer addAnimation:pathAnimation forKey:nil];
}

#pragma mark - pop关门动画(UIView动画)
- (void)popOrDismissDoorAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.取出转场前后控制器view
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //2.转场期间容器
    UIView *containerView = transitionContext.containerView;
    //3.创建左右门🚪
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-toView.frame.size.width * 0.5, 0, toView.frame.size.width * 0.5, toView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:toView];
    
    // 使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *snapShotView2 = [toView snapshotViewAfterScreenUpdates:YES];
    snapShotView2.frame = CGRectMake(-toView.frame.size.width * 0.5, 0, toView.frame.size.width, toView.frame.size.height);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(toView.frame.size.width, 0, toView.frame.size.width * 0.5, toView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:snapShotView2];
    
    //将需要的视图加入到容器中
    [containerView addSubview:fromView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    //4.开启动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        leftView.transform = CGAffineTransformTranslate(leftView.transform, toView.frame.size.width * 0.5, 0);
        rightView.transform = CGAffineTransformTranslate(rightView.transform, -toView.frame.size.width * 0.5, 0);
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        [leftView removeFromSuperview];
        [rightView removeFromSuperview];
        if (![transitionContext transitionWasCancelled])
        {
            // toView取消状态就不要加入到容器view中了
            [containerView addSubview:toView];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - push开门动画(UIView动画)
- (void)pushOrPresentDoorAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.取出转场前后控制器
    //    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //2.取出专场前后控制器View
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //3.转场containerView
    UIView *containerView = transitionContext.containerView;
    //4.创建一个左视图,并将控制器截图放置上去
    UIView *snapShotView1 = [fromView snapshotViewAfterScreenUpdates:NO];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fromView.frame.size.width * 0.5, fromView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:snapShotView1];
    //5.创建一个右视图,并将控制器截图放置上去
    UIView *snapShotView2 = [fromView snapshotViewAfterScreenUpdates:NO];
    snapShotView2.frame = CGRectMake(-fromView.frame.size.width * 0.5, 0, fromView.frame.size.width, fromView.frame.size.height);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(fromView.frame.size.width * 0.5, 0, fromView.frame.size.width * 0.5, fromView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:snapShotView2];
    //6.将转场时的View放置转场容器中,并隐藏前控制器view
    [containerView addSubview:toView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    fromView.hidden = YES;
    //7.开门动画，这里使用view动画与核心动画都可以。随心而动，随欲而行
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        leftView.transform = CGAffineTransformTranslate(leftView.transform, -fromView.frame.size.width * 0.5, 0);
        rightView.transform = CGAffineTransformTranslate(rightView.transform, fromView.frame.size.width * 0.5, 0);
    } completion:^(BOOL finished) {
        
        fromView.hidden = NO;
        [leftView removeFromSuperview];
        [rightView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
