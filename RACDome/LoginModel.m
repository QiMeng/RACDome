//
//  LoginModel.m
//  RACDome
//
//  Created by QiMENG on 14-12-16.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "LoginModel.h"

#import <RACEXTScope.h>
#import <PXAPI.h>

@interface LoginModel ()

@property (nonatomic, strong) RACCommand *loginCommand;

@end

@implementation LoginModel

-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    @weakify(self);
    self.loginCommand = [[RACCommand alloc] initWithEnabled:[self validateLoginInputs]
                                                signalBlock:^RACSignal *(id input) {
                                                    @strongify(self);
                                                    return [LoginModel logInWithUsername:self.username password:self.password];
                                                }];
    
    return self;
}
+(RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [PXRequest authenticateWithUserName:username password:password completion:^(BOOL success) {
            if (success) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"500px API" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Could not log in."}]];
            }
        }];
        
        // Cannot cancel request
        return nil;
    }];
}


- (RACSignal *)validateLoginInputs
{
    return [RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)]
                             reduce:^id(NSString *username, NSString *password){
                                 
                                 return @(username.length > 0 && password.length > 0);
    }];
}

@end
