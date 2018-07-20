# JSBridgeDemo
iOS native层与js层相互调用的demo

## Native
* 引入 JavaScriptCore.framework，这个是核心，创建一个协议，用来将 native 的方法暴露给js，native 实现协议方法。
* 获取webview的上下文`[_web  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];`，用来将 native 对象注入到 js 环境中，和获取 js 环境中的变量方法等。

## Javascript
* 将定义将会被 native 调用的函数
* 调用 native 暴露的对象的方法
