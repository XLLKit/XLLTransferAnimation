//
//  XLLPresentController.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/25.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLPresentController.h"
#import "XLLTransferDelegate.h"
#import "XLLNavigationController.h"

@interface XLLPresentController ()

@property (nonatomic, strong) XLLTransferDelegate *modalTransition;

@end

@implementation XLLPresentController

#pragma mark - lazy loading
- (XLLTransferDelegate *)modalTransition
{
    if (_modalTransition == nil)
    {
        _modalTransition = [[XLLTransferDelegate alloc] initWithAnimationStyle:XLLAnimationStyleCircle InteractiveStyle:XLLTransferInteractiveModal];
    }
    return _modalTransition;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.modalTransition = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentID"])
    {
        XLLNavigationController *nav = (XLLNavigationController *)segue.destinationViewController;
        [self.modalTransition addGestureOnVC:nav.childViewControllers.firstObject];
        nav.transitioningDelegate = self.modalTransition;
    }
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
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
