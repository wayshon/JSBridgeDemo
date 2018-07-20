//
//  ViewController.m
//  JSBridgeDemo
//
//  Created by 王旭 on 2018/7/20.
//  Copyright © 2018年 王旭. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<JSExportProtocol>
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (weak, nonatomic) IBOutlet UITextField *forJSText;

@property (nonatomic, strong) JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWeb];
    [self initJS];
}

- (void)initWeb {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_web loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

- (void)initJS {
    //创建context
    self.context = [_web  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];;
    //设置异常处理
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [JSContext currentContext].exception = exception;
        NSLog(@"exception:%@",exception);
    };
    
    //将obj添加到context中
    self.context[@"NativeObj"] = self;
    //JS里面调用Obj方法，并将结果赋值给Obj的sum属性
}

- (IBAction)showJSAlert:(id)sender {
    NSDictionary *dic = @{
                          @"title": @"this from native",
                          @"content": self.forJSText.text
                          };
    NSString *jsonStr = [self DataTOjsonString:dic];
    [self.context[@"showJSAlert"] callWithArguments:@[jsonStr]];
}

- (void)showUIAlertView:(id)param {
    NSString *title = @"native 提示";
    NSString *content;
    if ([param isKindOfClass: [NSString class]]) {
        NSLog(@"param is nsstring");
        content = param;
    } else if ([param isKindOfClass: [NSDictionary class]]) {
        NSLog(@"param is dic");
        title = [param objectForKey:@"title"];
        content = [param objectForKey:@"content"];
    }
    
//    在主线程更新 native UI
    dispatch_async(dispatch_get_main_queue(), ^{

        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"ok");
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    });
}

- (NSInteger)add:(NSInteger)n1 with:(NSInteger)n2 {
    return n1 + n2;
}

- (NSString *)DataTOjsonString:(NSDictionary *)dic
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
