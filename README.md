LLDark
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/internetWei/llDark/blob/master/LICENSE)&nbsp; [![CocoaPods](https://img.shields.io/badge/pod-0.1.8-blue)](http://cocoapods.org/pods/LLDark)&nbsp; [![Platform](https://img.shields.io/badge/platform-ios-lightgrey)](https://www.apple.com/nl/ios)&nbsp; [![Support](https://img.shields.io/badge/support-iOS%209%2B-blue)](https://www.apple.com/nl/ios)

A powerful dark theme framework for iOS, quickly adapting to dark mode.
Mainland China users can access[This link](https://gitee.com/internetWei/llDark)

Features
==============
- The integration is simple, and it can be perfectly adapted with a small amount of code modification.
- High performance, only update the specified page when the page needs to be updated.
- It has powerful functions and can be perfectly adapted to all places where UIColor, UIImage, and CGColor are used.
- Compatible with models below iOS13.
- Support to obtain dark theme configuration from the Internet.
- The automatic adaptation start-up picture is the current theme mode of the APP.

Demo
==============
![Manual.gif](https://gitee.com/internetWei/llDark/raw/master/Demo/Resouces/manual.gif) ![System.gif](https://gitee.com/internetWei/llDark/raw/master/Demo/Resouces/followSystem.gif) ![Screen.gif](https://gitee.com/internetWei/llDark/raw/master/Demo/Resouces/screenSplace.gif)

Usage
==============

### premise
Configure dark resources：
Create `+ (NSDictionary<id, id> *)llDarkTheme` class method in any NSObject category of the project (it is recommended to create a separate category). The key of the dictionary represents the color/picture name/picture address under the light theme, and the dictionary’s Value represents the color/picture name/picture address under the dark theme. You can refer to the sample code:
```Objc
+ (NSDictionary<id, id> *)llDarkTheme {
    return @{
             UIColor.whiteColor : kColorRGB(27, 27, 27),
             kColorRGB(240, 238, 245) : kColorRGB(39, 39, 39),
             [UIColor colorWithRed:14.0 / 255.0 green:255.0 / 255.0 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:14.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
             @"background_light" : @"background_dark",
             @"~/path/background_light.png" : @"~/path/background_dark.png",
    };
}
```
Tips:
`1.It is not necessary to fill in all colors/pictures in all cases. For dark colors that are occasionally or rarely used, you can refer to the advanced usage to adapt them separately.
2.if the picture path is filled in, the complete picture path (including the suffix) must be filled in.`

### Basic usage
UIColor and CGColor only need to append .themeColor(nil).
UIImage only needs to replace imageNamed or imageWithContentsOfFile with themeImage.
```objc
// UIColor
UIColor.redColor; // Previous usage
UIColor.redColor.themeColor(nil); // Current usage

// CGColor
UIColor.redColor.CGColor; // Previous usage
UIColor.redColor.themeCGColor(nil); // Current usage

// UIImage
[UIImage imageNamed:@"lightImageName"]; // Previous usage
[UIImage themeImage:@"lightImageName"]; // Current usage
```

Tips:
`1.themeImage is adapted to two methods, imageNamed and imageWithContentsOfFile, which can pass the image name or the image path.
2.Only the adapted Color and Image will be refreshed when the theme is switched.
`

### Advanced usage
```Objc
1.If the parameter in themeColor() is a specific Color object, the dark theme will refresh with the specified Color object.
If it is nil, it will return to the dark color refresh configured in llDarkTheme,
If llDarkTheme is not configured, it will return the color under the light theme.

2.The function of the themeCGColor() parameter is the same as the function of the themeColor() parameter.

3.themeImage() has 2 parameters, the parameter can be the image name or the image address,
The first parameter represents the picture used under the light theme (required),
The second parameter represents the picture used under the dark theme (can be empty),
If the second parameter is empty, the treatment is the same as if themeColor() is empty.

4.appearanceBindUpdater，All objects inherited from UIView have this property,
It will be called when the object needs to be refreshed, and you can implement your own refresh logic here.
It is only called when a refresh is needed, and the theme change does not necessarily require refreshing the UI.

5.userInterfaceStyle，Similar to the overrideUserInterfaceStyle method of iOS13 system,
But the function is more powerful than overrideUserInterfaceStyle,
It supports all objects, such as CALayer.
It supports system usage below iOS13.

6.themeDidChange，All objects have this property, which is the same as ThemeDidChangeNotification.
themeDidChange will be released when the object is released,
Can be used in multiple places, the callback order is not guaranteed,
Unlike appearanceBindUpdater, themeDidChange is called whenever the theme changes.

7.systemThemeDidChange，All objects have this property, which is the same as SystemThemeDidChangeNotification.
The release timing is the same as themeDidChange,
Can be used in multiple places, the callback order is not guaranteed,
As long as the system theme changes, systemThemeDidChange will be called.

8.darkStyle，All UIImageView objects have this method to adapt to image objects without dark images, such as web images.
DarkStyle has 3 parameters. The first parameter determines how to adapt to the dark theme. There are currently two types: LLDarkStyleSaturation and LLDarkStyleMask.
LLDarkStyleMask uses mask adaptation, and LLDarkStyleSaturation adapts by reducing the saturation of the original image.
The second parameter determines the transparency/saturation value of the mask. For specific usage, please refer to the source code comments.
The third parameter can be nil. When using LLDarkStyleSaturation, you need to pass a unique string as an identifier, usually the url of the image.
Sample code:
UIImageView *imageView = [[UIImageView alloc] init];
NSString *url = @"Picture URL";
imageView.darkStyle(LLDarkStyleSaturation, 0.2, url);
// imageView.darkStyle(LLDarkStyleMask, 0.5, nil);

9.updateDarkTheme:，If you need to modify the dark theme configuration information at runtime, or need to obtain dark theme configuration information from the Internet, you can use updateDarkTheme: to achieve the goal.
Please ensure that the dark theme information is configured before the first UI object is loaded, otherwise it will be invalid.
Sample code:
NSDictionary *darkTheme = @{
    UIColor.whiteColor : kColorRGB(27, 27, 27),
    kColorRGB(240, 238, 245) : kColorRGB(39, 39, 39),
    [UIColor colorWithRed:14.0 / 255.0 green:255.0 / 255.0 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:14.0 / 255.0 blue:255.0 /  255.0 alpha:1.0],
    @"background_light" : @"background_dark",
    @"~/path/background_light.png" : @"~/path/background_dark.png",
};
[LLDarkSource updateDarkTheme:darkTheme];

10.thirdControlClassName，If you need to support the refresh method of the third-party control, you can implement the refresh logic separately in appearanceBindUpdater, or you can implement the refresh logic according to the following methods, and the following methods are more recommended.
First, you need to implement the thirdControlClassName class method and return an array containing the class name string of the third party control.
Then implement the refresh+class name string object method, and implement the refresh logic of the third-party control in the method. You can refer to the YYLabel refresh logic that has been implemented in the LLThird.m file.
For details, you can download the project and view the Demo to understand the specific implementation.
```
The sample diagram of darkStyle method No. 8 in advanced usage (in order to highlight the effect, the saturation and transparency are adjusted very low):
![5fc91820394ac523788c48f4](https://pic.downk.cc/item/5fc91820394ac523788c48f4.png) 

Quick adaptation
==============
It only takes 3 steps to quickly and perfectly adapt to the dark theme mode. After testing, most of the projects can be adapted within 0.5 days.
1. To configure dark theme resources, refer to `Prerequisites`, or refer to `Advanced Method 9` to obtain resource adaptation from the network.
2. Adapt Color and Image that need to be adapted to theme Color and theme Image. For the adaptation method, please refer to `Basic Usage` and `Advanced Usage`.
3. Run the project and check for completeness.

Tips:
If you still need to adapt `WKWebView`, you can [click the link](https://www.jianshu.com/p/be578117f84c)Refer to the article for adaptation.

Installation
==============
### CocoaPods
1. Update cocoapods to the latest version.
2. Add pod 'LLDark' to your Podfile.
3. Run pod install or pod update.
4. Import <LLDark/LLDark.h>.

### Manually
1. Download all the files in the LLdark subdirectory.
2. Add (drag and drop) the LLDark folder in the LLDark project to your project.
3. Import LLDark.h.

Requirements
==============
The project supports iOS 9.0 and Xcode 10.0 at least. If you want to use it on lower systems, please contact the author.

Note
==============
1. Need to monitor the theme mode to modify the status bar color.
2. Please do not modify the name of AppDelegate.

Known issues
==============
* Please do not put image resources that need to be adapted to the dark theme in Assets.xcassets, otherwise they may not be available.
* Other theme modes are not supported for the time being, and a variety of themes will be supported freely in the future.

Contact
==============
If you have better improvements, please pull reqeust me

If you have any better comments, please create one[Issue](https://github.com/internetWei/llDark/issues)

The author can be contacted by this email`internetwei@foxmail.com`

License
==============
LLDark is released under the MIT license. See LICENSE file for details.
<br><br><br>

==============

中文介绍
==============

LLDark
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/internetWei/llDark/blob/master/LICENSE)&nbsp; [![CocoaPods](https://img.shields.io/badge/pod-0.1.8-blue)](http://cocoapods.org/pods/LLDark)&nbsp; [![Platform](https://img.shields.io/badge/platform-ios-lightgrey)](https://www.apple.com/nl/ios)&nbsp; [![Support](https://img.shields.io/badge/support-iOS%209%2B-blue)](https://www.apple.com/nl/ios)

适用于iOS的强大深色主题框架，快速适配深色模式。
国内用户可以访问[这个链接](https://gitee.com/internetWei/llDark)

特性
==============
- 集成简单，只需改动少量代码即可完美适配。
- 高性能，仅在需要更新页面时更新指定页面，有相关缓存策略缩短刷新时长。
- 功能强大，所有使用UIColor、UIImage、CGColor的地方均可完美适配。
- 兼容iOS13以下机型。
- 支持从网络上获取深色主题配置。
- 自动适配启动图为APP当前主题模式。

Demo
==============
![Manual.gif](https://gitee.com/internetWei/llDark/raw/master/Demo/Resouces/manual.gif) ![System.gif](https://gitee.com/internetWei/llDark/raw/master/Demo/Resouces/followSystem.gif) ![Screen.gif](https://gitee.com/internetWei/llDark/raw/master/Demo/Resouces/screenSplace.gif)

用法
==============

### 前提
配置深色资源：
在工程任意NSObject分类(建议单独新建一个主题分类)中创建`+ (NSDictionary<id, id> *)llDarkTheme`类方法，字典的key表示浅色主题下的颜色/图片名称/图片地址，字典的value表示深色主题下的颜色/图片名称/图片地址。可参考样例代码：
```Objc
+ (NSDictionary<id, id> *)llDarkTheme {
    return @{
             UIColor.whiteColor : kColorRGB(27, 27, 27),
             kColorRGB(240, 238, 245) : kColorRGB(39, 39, 39),
             [UIColor colorWithRed:14.0 / 255.0 green:255.0 / 255.0 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:14.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
             @"background_light" : @"background_dark",
             @"~/path/background_light.png" : @"~/path/background_dark.png",
    };
}
```
Tips:
`1.不必把所有情况下的颜色/图片都填写进去，对于偶尔或少数使用到的深色颜色可以参考高级用法单独适配。
2.图片名称不用考虑倍图关系；如果填写的是图片路径一定要填写完整的图片路径(包含后缀)。`

### 基本用法
UIColor和CGColor只需要追加.themeColor(nil)即可。
UIImage只需要将imageNamed或imageWithContentsOfFile替换为themeImage即可。
```objc
// UIColor
UIColor.redColor; // 之前的用法
UIColor.redColor.themeColor(nil); // 现在的用法

// CGColor
UIColor.redColor.CGColor; // 之前的用法
UIColor.redColor.themeCGColor(nil); // 现在的用法

// UIImage
[UIImage imageNamed:@"lightImageName"]; // 之前的用法
[UIImage themeImage:@"lightImageName"]; // 现在的用法
```

Tips:
`1.themeImage适配了imageNamed和imageWithContentsOfFile两个方法，可以传递图片名称，也可以传递图片路径。
2.只有适配过的Color和Image在主题切换时才会刷新。
`

### 高级用法
```Objc
1.themeColor()里面的参数如果是具体的Color对象，深色主题则会使用指定的Color对象刷新,
如果是nil则会返回llDarkTheme中配置的深色颜色刷新，
如果llDarkTheme未配置则会返回浅色主题下的颜色。

2.themeCGColor()参数的作用和themeColor()参数作用一样。

3.themeImage()有2个参数，参数可以是图片名称，也可以是图片地址,
第1个参数表示浅色主题下使用的图片(必填)，
第2个参数表示深色主题下使用的图片(可以为空)，
第2个参数为空的话和themeColor()为空的处理方式一样。

4.appearanceBindUpdater，所有继承自UIView的对象都拥有这个属性，
对象需要刷新时会调用它，可以在这里实现自己的刷新逻辑。
仅在需要刷新时会调用，主题更改不一定需要刷新UI。

5.userInterfaceStyle，类似iOS13系统的overrideUserInterfaceStyle方法，
但是功能比overrideUserInterfaceStyle更加强大，
它支持所有的对象，例如CALayer。
它支持iOS13以下的系统使用。

6.themeDidChange，所有对象都拥有这个属性，作用和ThemeDidChangeNotification一样，
themeDidChange会在对象释放时被释放掉，
可以在多个地方使用，不保证回调顺序，
不同于appearanceBindUpdater，只要主题发生改变就会调用themeDidChange。

7.systemThemeDidChange，所有对象都拥有这个属性，作用和SystemThemeDidChangeNotification一样，
释放时机和themeDidChange一样，
可以在多个地方使用，不保证回调顺序，
只要系统主题发生改变就会调用systemThemeDidChange。

8.darkStyle，所有UIImageView对象都拥有这个方法，用于适配没有深色图片的图片对象，例如网络图片。
darkStyle有3个参数，第1个参数决定如何适配深色主题，目前有LLDarkStyleSaturation和LLDarkStyleMask两种，
LLDarkStyleMask使用蒙层适配，LLDarkStyleSaturation通过降低原图饱合度适配。
第2个参数决定蒙层透明度/饱合度值，具体使用可看源码注释。
第3个参数可以为nil，使用LLDarkStyleSaturation时需要传递一个唯一字符串当做标识符，通常是图片的url。
样例代码：
UIImageView *imageView = [[UIImageView alloc] init];
NSString *url = @"图片URL";
imageView.darkStyle(LLDarkStyleSaturation, 0.2, url);
// imageView.darkStyle(LLDarkStyleMask, 0.5, nil);

9.updateDarkTheme:，如果需要运行时修改深色主题配置信息，或者需要从网络上获取深色主题配置信息，可以使用updateDarkTheme:来达到目的。
请确保在第1个UI对象加载前配置好深色主题信息，否则会无效。
样例代码:
NSDictionary *darkTheme = @{
    UIColor.whiteColor : kColorRGB(27, 27, 27),
    kColorRGB(240, 238, 245) : kColorRGB(39, 39, 39),
    [UIColor colorWithRed:14.0 / 255.0 green:255.0 / 255.0 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:14.0 / 255.0 blue:255.0 /  255.0 alpha:1.0],
    @"background_light" : @"background_dark",
    @"~/path/background_light.png" : @"~/path/background_dark.png",
};
[LLDarkSource updateDarkTheme:darkTheme];

10.thirdControlClassName，如果需要支持第3方控件的刷新方法，可以在appearanceBindUpdater中单独实现刷新逻辑，也可以按照如下方法实现刷新逻辑，更加推荐如下方法。
首先需要实现thirdControlClassName这个类方法，并返回一个数组，数组包含第3方控件的类名字符串。
然后实现refresh+类名字符串的对象方法，在方法里实现第3方控件的刷新逻辑，可以参考LLThird.m文件中已经实现的YYLabel的刷新逻辑。
详情可以下载工程查看Demo了解具体实现。
```
高级用法中第8条darkStyle方法的样例图(为了突出效果特意将饱合度和透明度调整的很低)：
![137a9000178656346577e](https://pic.downk.cc/item/5fc60802d590d4788ab3a29b.png) 

快速适配
==============
仅需要3步即可快速完美适配深色主题模式，经测试大部分工程都能在0.5天内适配完成，
少量工程1天内适配完成，极少需要1天以上的工作量进行适配。
1. 配置深色主题资源，可参考`前提`，也可以参考`高级方法9`从网络中获取资源适配。
2. 将需要适配的Color和Image适配为主题Color和主题Image，适配方法可参考`基础用法`和`高级用法`。
3. 运行工程，检查完整性。

Tips:
如果您还需要适配`WKWebView`，可以[点击链接](https://www.jianshu.com/p/be578117f84c)参考文章进行适配。

安装
==============
### CocoaPods
1. 将 cocoapods 更新至最新版本。
2. 在 Podfile 中添加 pod 'LLDark'。
3. 执行 pod install 或 pod update。
4. 导入 <LLDark/LLDark.h>。

### 手动安装
1. 下载 LLDark 文件夹内的所有内容。
2. 将 LLDark 工程中的LLDark文件夹添加(拖放)到你的工程。
3. 导入 "LLDark.h"。

系统要求
==============
该项目最低支持iOS9.0和Xcode10.0，如果想在更低系统上使用请联系作者。

注意点
==============
1. 需要自己监听主题模式修改状态栏颜色。
2. 请不要修改AppDelegate的名称。

已知问题
==============
* 需要适配深色主题的图片资源请不要放在Assets.xcassets中，否则可能会获取不到。
* 暂时不支持其他主题模式，后续会支持多种主题自由搭配。

联系作者
==============
如果你有更好的改进，please pull reqeust me

如果你有任何更好的意见，请创建一个[Issue](https://github.com/internetWei/llDark/issues)

可以通过此邮箱联系作者`internetwei@foxmail.com`

许可证
==============
LLDark 使用 MIT 许可证，详情见 LICENSE 文件。
