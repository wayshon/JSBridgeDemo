//
//  ViewController.h
//  JSBridgeDemo
//
//  Created by 王旭 on 2018/7/20.
//  Copyright © 2018年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

//定义一个JSExport protocol
@protocol JSExportProtocol <JSExport>

//用宏转换下，将JS函数名字指定为showUIAlertView；
JSExportAs(showUIAlertView, - (void)showUIAlertView:(id)param);

JSExportAs(add, - (NSInteger)add:(NSInteger)n1 with:(NSInteger)n2);

@end

@interface ViewController : UIViewController

@end

