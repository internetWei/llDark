LLDark
==============
适用于iOS的强大深色主题框架，旨在快速适配深色模式。
国内用户访问这个[链接](https://gitee.com/internetWei/llDark)会更快一些。

特性
==============
- 集成简单；修改量小，不会破坏项目当前结构。
- 高性能；经过测试和系统切换主题时的性能相当。
- 功能强大；适配所有场景(CALayer、网络图片、NSAttributedString……)。
- 兼容iOS13以下的机型
- iOS13以上机型自动适配深色启动图(启动图将跟随APP设置的主题模式，而不是由系统控制)，可参考图3

Demo
==============
![fe7e0003132f87224586](https://pic.downk.cc/item/5fc5b945d590d4788a8f6e1c.gif)图1     ![fe3d000340e405dbbb16](https://pic.downk.cc/item/5fc5e700d590d4788aa71cb7.gif)图2

用法
==============

### 前提
配置深色资源：
![fe71000339c2cdd41994](https://pic.downk.cc/item/5fc5d6e5d590d4788a9e8775.png) 图4

全局搜索并打开`LLDarkSource.m`文件，参考`图4`填写相关色值/图片名称；左侧为浅色主题下的色值/图片名称，右侧为深色主题下的色值/图片名称(ps:图片名称不用考虑@2x、@3x倍图)。

PS:`这里不用把工程里所有的颜色/图片名称都写入进去，只要把常用的色值和图片名称进行关联匹配就可以了，对于仅在某些地方使用的色值/图片可以参考高级用法单独适配`


### 基本用法
``````objc
// UIColor
UIColor.redColor; // 之前的用法
UIColor.redColor.themeColor(nil); // 现在的用法

// UIImage
[UIImage imageNamed:@"lightImageName"]; // 之前的用法
[UIImage themeImage:@"lightImageName"]; // 现在的用法

// CGColor
UIColor.redColor.CGColor; // 之前的用法
UIColor.redColor.themeCGColor(nil); // 现在的用法
``````
所有使用UIColor、UIImage、CGColor的地方均可以替换成以上方法进行适配，经过适配的图片、颜色称为主题颜色、主题图片；主题切换时只会刷新主题颜色、主题图片。

### 样例代码
```objc
// UILabel
UILabel *label = [[UILabel alloc] init];
label.backgroundColor = UIColor.blackColor.themeColor(nil);
label.textColor = UIColor.whiteColor.themeColor(nil);

// UIImageView
UIImageView *imageView = [[UIImageView alloc] init];
imageView.image = [UIImage themeImage:@"lightImageName"];

// CALayer
CALayer *layer = [CALayer layer];
layer.backgroundColor = UIColor.redColor.themeCGColor(nil);

// NSAttributedString
NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"我是一段文字" attributes:@{NSForegroundColorAttributeName : UIColor.redColor.themeColor(nil)}];
```

### 高级用法
``````objc
1. 如果对应的深色色值不存在LLDarkSource.m中，或者某处需要单独设置对应的深色色值，可以这么写：

label.backgroundColor = UIColor.redColor.themeColor(UIColor.blueColor);

// themeColor()中的值可以是nil或者一个UIColor对象，
// 如果传递nil则会查找LLDarkSource中配置的深色色值，
// 如果找不到则会使用浅色色值当做深色色值，
// 如果()传递了指定UIColor，则会无视LLDarkSource中配置的色值而使用指定的UIColor。

2. 同理.themeCGColor()和themeColor()的作用一致。

3. UIImage.themeImage()和themeColor()作用一样，只是换了一种表达方式而已，可以参考：

imageView.image = UIImage.themeImage(@"lightImage", @"darkImage");

// .themeImage()需要传递2个参数，第1个参数是浅色主题下的图片名称，第2个参数是深色主题下的图片名称
// (PS:也可以传递图片地址；不用考虑倍图关系)。

4. 所有继承自UIView的对象都有appearanceBindUpdater这个属性，如果需要实现自定义刷新逻辑，实现appearanceBindUpdater即可，具体的调用逻辑请阅读源码注释。

5. 所有对象均有userInterfaceStyle这个属性，作用和系统的overrideUserInterfaceStyle类似。但是更加强大，它支持CALayer设置，也支持iOS13以下的系统。

6. 如果需要在APP主题发生改变时处理某些逻辑，可以实现themeDidChange这个属性Block，
   也可以监听ThemeDidChangeNotification。
  
7. 如果需要在系统主题发生改变时处理某些逻辑，可以实现systemThemeDidChange这个属性Block，
   也可以监听SystemThemeDidChangeNotification。
   
8. 如果工程需要适配网络图片，可以参考如下代码:
  UIImageView *imageView = [UIImageView new];
  NSString *url = @"url地址";
  imageView.darkStyle(LLDarkStyleSaturation, 0.5, url);
//  imageView.darkStyle(LLDarkStyleMask, 0.5, nil);

// LLDarkStyleMask表示在图片上覆盖一层透明Layer适配深色主题；
// LLDarkStyleSaturation会基于原图生成一个降低饱合度的图版进行替换；
// 具体使用方法请阅读源码注释，效果图请参考图5。
``````

![137a9000178656346577e](https://pic.downk.cc/item/5fc60802d590d4788ab3a29b.png) 图5.0 (图片中的饱合度，蒙层透明度均可以用代码调整。)


快速适配
==============
1. 在LLDarkSource.m文件中配置深色主题下对应的资源。
2. 将原先使用的UIColor实例对象追加.themeColor(nil)。
3. 全局搜索"imageNamed:"、"imageWithContentsOfFile:"替换为"themeImage:"。
4. 运行项目检查UI是否符合规定，如果某些控件/页面需要单独调整可以参考高级用法。
5. 如果需要适配WKWebView，可以[点击链接](https://www.jianshu.com/p/be578117f84c)参考文章进行适配，或者可以自行上网搜索适配方法。
6. 修改APP主题请参考LLDarkManager.h文件中的方法。


安装
==============
由于需要修改SDK中的文件，暂时只支持手动安装，后续会支持CocoaPods安装。

### 手动安装
1. 下载 LLDark 文件夹内的所有内容。
2. 将 LLDark 工程中的LLDark文件夹添加(拖放)到你的工程。
3. 导入 `LLDark.h`。


### 注意
1. 需要自己监听主题模式切换修改状态栏颜色
2. 如果需要适配其他3方控件，例如YYLabel(YYLabel和YYTextView已经适配)，需要实现2个步骤：1.在LLDarkSource.m文件中thirdList属性中添加第3方控件类名。2.在LLThird.m方法中实现刷新方法，方法的命名规则:refresh+第3方类名，例如refreshYYLabel。


系统要求
==============
理论上可以支持到很低的版本，但是SDK是在iOS10,Xcode11.0以上的环境进行开发，
如果遇到不适配的问题，欢迎issue或者联系作者。


已知问题
==============
* 需要适配暗黑主题的图片建议不要放在Assets.xcassets中，原因有2，1.如果要适配iOS13以下的机型，深色图片放在Assets.xcassets中会导致iOS13以下的手机取不到图片。2.某些情况会导致图片获取不对，浅色主题获取了深色主题下的图片。
* 暂时不支持其他主题模式，后续会支持多种主题
* CALayer暂不支持后台刷新，系统问题
* 系统弹窗暂时无法在iOS13以下系统适配
* 深色启动图暂时无法在iOS13以下系统适配

联系
==============
如果你发现bug，请创建一个Issue
如果你有更好的改进，please pull reqeust me
个人邮箱`internetwei@foxmail.com`

许可证
==============
LLDark 使用 MIT 许可证，详情见 LICENSE 文件。
