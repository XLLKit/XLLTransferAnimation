//
//  XLLFirstController.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/24.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLPushController.h"
#import "XLLPopController.h"
#import "XLLPushPopTransition.h"

@interface XLLPushController () <CAAnimationDelegate>

@property (nonatomic, weak) UIView *testView;
@property (nonatomic, strong) XLLPushPopTransition *showTransition;

@end

@implementation XLLPushController

#pragma mark - lazy loading
- (XLLPushPopTransition *)showTransition
{
    if (_showTransition == nil)
    {
        _showTransition = [[XLLPushPopTransition alloc] init];
    }
    return _showTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    UIView *testView = [[UIView alloc] init];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    self.testView = testView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.showTransition = nil;
    self.navigationController.delegate = nil;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.testView.frame = CGRectMake((self.view.frame.size.width - 70)/2.0, 100, 70, 120);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.testView.center.x, CGRectGetMaxY(self.testView.frame) + self.testView.frame.size.height * 0.5) radius:self.testView.frame.size.height startAngle:-M_PI_4 endAngle:-M_PI_2 clockwise:NO];
    CAKeyframeAnimation *posAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnimation.duration = 1.5;
    posAnimation.removedOnCompletion = NO;
    posAnimation.delegate = self;
    posAnimation.fillMode = kCAFillModeForwards;
    posAnimation.path = bezierPath.CGPath;
    [self.testView.layer addAnimation:posAnimation forKey:nil];
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    self.testView.transform = CGAffineTransformRotate(self.testView.transform, M_PI_4);
    [UIView animateWithDuration:1.5 animations:^{
        self.testView.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.testView.layer removeAllAnimations];
}

- (IBAction)pushClick:(id)sender {
    
    [self performSegueWithIdentifier:@"firstPush" sender:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"firstPush"])
    {
        XLLPopController *popVC = (XLLPopController *)segue.destinationViewController;
        [self.showTransition addGestureOnVC:popVC];
        self.navigationController.delegate = self.showTransition;
    }
}

- (void)dealloc
{
    NSLog(@"---");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

