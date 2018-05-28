//
//  ViewController.m
//  TextFieldPlayCyan
//
//  Created by cyan on 2018/5/28.
//  Copyright © 2018年 cyan. All rights reserved.
//

#import "ViewController.h"
// 屏幕宽度
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define BaseTextFieldTag 2018
@interface ViewController ()<UITextFieldDelegate>{
    
    
    NSInteger _allIndex;
    NSArray *_textFArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allIndex = 6;
    [self createUI];
}


-(void)createUI{
    

    CGFloat textFWidth = (kMainScreenWidth - 24 *2 - 5 *8 )/6.0;
    NSMutableArray *textArr  = [NSMutableArray array];
    for (NSInteger index = 0; index < _allIndex; index++) {
        UITextField *textField  = [[UITextField alloc]init];
        
        textField.placeholder = @"输入。。";
        //textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textField.font = [UIFont systemFontOfSize:14];
        textField.tag = BaseTextFieldTag + index;

        textField.delegate = self;
        [self.view addSubview:textField];
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:view];
        
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (textFWidth - 14)/2.0, 44)];
        textField.leftView.userInteractionEnabled = NO;
        textField.leftViewMode = UITextFieldViewModeAlways;
        // Text 垂直居中
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.frame = CGRectMake(24 + (textFWidth + 8)*index, 40, textFWidth, 44);
        view.frame = CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(textField.frame)+5, textFWidth, 1);
    
        [textArr addObject:textField];
    }
    _textFArr = textArr.copy;

    
}

#pragma  mark - 是否已经输入验证码完全
-(BOOL )isAllMessageVerification{
    
    __block NSInteger count = 0;
    __block NSString *text = @"";
    [_textFArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *textF = (UITextField *)obj;
        if (textF.text.length) {
            count ++;
            text = [NSString stringWithFormat:@"%@%@",text,textF.text];
        }
        
    }];
    
    if (_textFArr.count == count) {
        //这就接收最终的text
        NSLog(@"输入好了 %@",text);
        return YES;
        
    }
    
    
    return NO;
}

#pragma mark  -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    if ([string  isEqual: @""]) {
        return YES;
    }
    if (textField.text.length >=1) {
        return NO;
    }
    if (string.length == 1) {
        if (textField.tag +1 >= _allIndex + BaseTextFieldTag) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [textField resignFirstResponder];
                [self isAllMessageVerification];
                
            });
            return YES;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self isAllMessageVerification]) {
                //收键盘 发送处理
                [self.view endEditing:YES];
                
            }else{
                //唤起下一个textField
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UITextField *nextTextF =  (UITextField *) [self.view viewWithTag:textField.tag + 1];
                    [nextTextF becomeFirstResponder];
                });
            }
        });
        
        
        return YES;
    }
    
    
    return NO;
}


@end
