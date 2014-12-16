//
//  ViewController.m
//  RACDome
//
//  Created by QiMENG on 14-12-15.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>

#import "LoginModel.h"

@interface ViewController ()

@property (nonatomic, copy) NSString * username;
//@property (nonatomic , )
@property (nonatomic, strong) LoginModel * viewModel;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"RAC";
    
    /*
    self.viewModel = [LoginModel new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    // Reactive Stuff
    @weakify(self);
    RAC(self.viewModel, username) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.loginCommand;
    
    [[self.viewModel.loginCommand.executionSignals flattenMap:^(RACSignal *execution) {
        // Sends RACUnit after the execution completes.
        return [[execution ignoreValues] concat:[RACSignal return:RACUnit.defaultUnit]];
    }] subscribeNext:^(id _) {
        @strongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.viewModel.loginCommand.errors subscribeNext:^(id x) {
        NSLog(@"Login error: %@", x);
    }];
    
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
     
     */
    
    //冷状态
    RACSignal *signal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        NSLog(@"triggered");
        [subscriber sendNext:@"foobar"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [signal subscribeCompleted:^{
        NSLog(@"subscribeCompleted");
    }];
    
    
    RAC(myButton,enabled) = [RACSignal combineLatest:@[self.usernameTextField.rac_textSignal,
                                                       self.passwordTextField.rac_textSignal]
                                              reduce:^(NSString *user, NSString * pwd){
                                                    return  @(user.length > 0 && pwd.length > 0);
                                              }];
    
    
    
    RAC(myLabel,text) = myTextField.rac_textSignal;
    RAC(myButton.titleLabel,text) = myTextField.rac_textSignal;
    
    [RACObserve(myLabel,text) subscribeNext: ^(NSString *newName){
        NSLog(@"newName:%@", newName);
    }];
    
    /**
     *  rac 应用于 UIButton
     */
    [[myButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"RAC button");
    }];
    
    
    NSArray *array = @[@"foo"];
    [[array rac_willDeallocSignal] subscribeCompleted:^{
        NSLog(@"oops, i will be gone");
    }];
    array = nil;
    
    
    //    NSArray *pins = @[@172230988, @172230947, @172230899, @172230777, @172230707];
    //    __block NSInteger index = 0;
    //
    //    RACSignal *signal = [[[[RACSignal interval:0.1 onScheduler:[RACScheduler scheduler]]
    //                           take:pins.count]
    //                          map:^id(id value) {
    //                              return [[[HBAPIManager sharedManager] fetchPinWithPinID:[pins[index++] intValue]] doNext:^(id x) {
    //                                  NSLog(@"这里只会执行一次");
    //                              }];
    //                          }]
    //                         switchToLatest];
    //
    //    [signal subscribeNext:^(id sender) {
    //        NSLog(@"pinID:%@", sender);
    //    } completed:^{
    //        NSLog(@"completed");
    //    }];
    
    
    
    [self test];
}

#pragma mark - 满足条件,自动触发某个方法
- (void)test
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [subscriber sendNext:@"A"];
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"Another B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA, signalB, nil];
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"A:%@ and B:%@", A, B);
}


#pragma mark - UIAlertView
- (void)RAC_AlertView {
    
    /**
     rac 应用于UIAlertView上
     */
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"message"
                                                   delegate:nil
                                          cancelButtonTitle:@"cancel"
                                          otherButtonTitles:@"Yes", nil];
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber * indexNumber) {
        
        NSLog(@"%@",indexNumber);
    }];
    [alert show];
    
}


- (void)touchAlert:(id)sender {
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
