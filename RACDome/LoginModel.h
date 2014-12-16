//
//  LoginModel.h
//  RACDome
//
//  Created by QiMENG on 14-12-16.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "RVMViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginModel : RVMViewModel

@property (nonatomic, readonly) RACCommand *loginCommand;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
