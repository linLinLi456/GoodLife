//
//  LoginViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userText;

@property (weak, nonatomic) IBOutlet UITextField *secretText;

- (IBAction)loginBtnClick:(UIButton *)sender;

- (IBAction)zhuceBtnClick:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userText.delegate = self;
    self.secretText.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userText resignFirstResponder];
    [self.secretText resignFirstResponder];
}
- (IBAction)loginBtnClick:(UIButton *)sender {
}

- (IBAction)zhuceBtnClick:(UIButton *)sender {
}
@end
