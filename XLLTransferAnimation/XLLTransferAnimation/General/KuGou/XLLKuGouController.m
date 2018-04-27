//
//  XLLKuGouController.m
//  XLLTransferAnimation
//
//  Created by 肖乐 on 2018/4/27.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLKuGouController.h"
#import "XLLModalTransition.h"
#import "XLLTestController.h"

@interface XLLKuGouController ()

@property (nonatomic, strong) XLLModalTransition *modalTransition;

@end

@implementation XLLKuGouController

#pragma mark - lazy loading
- (XLLModalTransition *)modalTransition
{
    if (_modalTransition == nil)
    {
        _modalTransition = [[XLLModalTransition alloc] init];
    }
    return _modalTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.modalTransition = nil;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"kugou"])
    {
        XLLTestController *testVC = (XLLTestController *)segue.destinationViewController;
        [self.modalTransition addGestureOnVC:testVC];
        testVC.transitioningDelegate = self.modalTransition;
    }
}

- (void)dealloc
{
    NSLog(@"撤撤撤");
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
