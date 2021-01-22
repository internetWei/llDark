//
//  NSObject+Expand.h
//  LLDark <https://github.com/internetWei/llDark>
//
//  Created by LL on 2020/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Expand)

- (void)ll_set:(NSString *)aSelector withObject:(nullable id)object;

- (nullable id)ll_get:(NSString *)aSelector;

/**
 将指定的消息发送给接收者并返回消息的结果
 @param sel    sel标识要发送的消息的选择器，如果选择器是NULL或无法识别，则引发NSInvalidArgumentException。
             ... 可变参数列表。参数类型必须对应于选择器的方法声明，否则可能会发生意外的结果。
               它不支持大于256个字节的并集或结构。
 
 @return     消息结果的对象。
 
 @discussion   选择器的返回值将被包装为NSNumber或NSValue
               如果选择器的“返回类型”不是对象或者是void，它总是返回nil。
 
 样例代码:
 
     // 没有可变参数
 
     [view performSelectorWithArgs:@selector(removeFromSuperView)];
     
     // 变量arg不是对象
 
     [view performSelectorWithArgs:@selector(setCenter:), CGPointMake(0, 0)];
     
     // 执行并返回对象
 
     UIImage *image = [UIImage.class performSelectorWithArgs:@selector(imageWithData:scale:), data, 2.0];
     
     // 执行并返回包装的数字
 
     NSNumber *lengthValue = [@"hello" performSelectorWithArgs:@selector(length)];
 
     NSUInteger length = lengthValue.unsignedIntegerValue;
     
     // 执行并返回包装的结构
 
     NSValue *frameValue = [view performSelectorWithArgs:@selector(frame)];
 
     CGRect frame = frameValue.CGRectValue;
 */
- (nullable id)ll_performSelectorWithArgs:(SEL)sel, ...;

@end

NS_ASSUME_NONNULL_END
