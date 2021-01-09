//
//  UIView+Refresh.m
//  LLDark
//
//  Created by LL on 2020/11/17.
//

#import "UIView+Refresh.h"

#import <objc/runtime.h>

#import "UIView+Dark.h"
#import "LLDarkManager.h"
#import "UIColor+Dark.h"
#import "UIImage+Dark.h"
#import "NSMutableAttributedString+Refresh.h"
#import "NSObject+Refresh.h"
#import "NSMutableDictionary+Refresh.h"
#import "CALayer+Refresh.h"
#import "UIImageView+Dark.h"
#import "LLDarkSource.h"
#import "NSObject+Dark.h"
#import "UITabBarItem+Dark.h"

@interface UIView ()

/// YES：需要刷新，NO：不用刷新
@property (nonatomic, assign, readonly) BOOL isNeedRefresh;

@property (nonatomic, readonly) NSString *className;

@end

@implementation UIView (Refresh)

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName(self.class)];
}

- (BOOL)isNeedRefresh {
    BOOL not1 = (self.window != nil);

    BOOL not2 = (self.isDarkMode != LLDarkManager.isDarkMode);
        
    return (not1 && not2);
}

- (void)refresh {
    if (self.userInterfaceStyle != LLUserInterfaceStyleUnspecified) return;
    if (!self.isNeedRefresh) return;
    
    [self refreshSingleView];
    for (UIView *obj in self.subviews) {
        if (obj.userInterfaceStyle != LLUserInterfaceStyleUnspecified) continue;
        if (!obj.isNeedRefresh) continue;
        [obj refresh];
    }
}

- (void)refresh:(LLUserInterfaceStyle)userInterfaceStyle {
    self.userInterfaceStyle = userInterfaceStyle;
    
    BOOL isNeedRefresh = YES;
    if (userInterfaceStyle == LLUserInterfaceStyleDark &&
        self.isDarkMode == YES) {
        isNeedRefresh = NO;
    }
    if (userInterfaceStyle == LLUserInterfaceStyleLight &&
        self.isDarkMode == NO) {
        isNeedRefresh = NO;
    }
    
    self.isDarkMode = (self.userInterfaceStyle == LLUserInterfaceStyleDark);
    
    if (isNeedRefresh == YES) {
        [self refreshSingleView];
        [self.layer refresh:userInterfaceStyle];
    }
    
    for (UIView *obj in self.subviews) {
        [obj refresh:userInterfaceStyle];
    }
}

/// 刷新单个View
- (void)refreshSingleView {
    if (self.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {    
        self.isDarkMode = LLDarkManager.isDarkMode;
    }
                
    /// 更新通用属性
    UIColor *backgroundColor = self.backgroundColor;
    if (backgroundColor.isTheme) {
        self.backgroundColor = backgroundColor.resolvedColor(self.userInterfaceStyle);
    }

    UIColor *tintColor = self.tintColor;
    if (tintColor.isTheme) {
        self.tintColor = tintColor.resolvedColor(self.userInterfaceStyle);
    }

    /// 刷新View的各种子类对象
    BOOL status = YES;
    while (status) {
        if ([self isKindOfClass:UILabel.class]) {
            [self refreshUILabel];
            break;
        }
        
        if ([self isKindOfClass:UIButton.class]) {
            [self refreshUIButton];
            break;
        }
        
        if ([self isKindOfClass:UIImageView.class]) {
            [self refreshUIImageView];
            break;
        }
        
        if ([self isKindOfClass:UITextField.class]) {
            [self refreshUITextField];
            break;
        }
        
        if ([self isKindOfClass:UITextView.class]) {
            [self refreshUITextView];
            break;
        }
        
        if ([self isKindOfClass:UITableView.class]) {
            [self refreshUITableView];
            break;
        }
        
        if ([self isKindOfClass:UIActivityIndicatorView.class]) {
            [self refreshUIActivityIndicatorView];
            break;
        }
        
        if ([self isKindOfClass:UIProgressView.class]) {
            [self refreshUIProgressView];
            break;
        }
        
        if ([self isKindOfClass:UIPageControl.class]) {
            [self refreshUIPageControl];
            break;
        }
        
        if ([self isKindOfClass:UISwitch.class]) {
            [self refreshUISwitch];
            break;
        }
        
        if ([self isKindOfClass:UISlider.class]) {
            [self refreshUISlider];
            break;
        }
        
        if ([self isKindOfClass:UIStepper.class]) {
            [self refreshUIStepper];
            break;
        }
        
        if ([self isKindOfClass:UIRefreshControl.class]) {
            [self refreshUIRefreshControl];
            break;
        }
        
        if ([self isKindOfClass:UISegmentedControl.class]) {
            [self refreshUISegmentedControl];
            break;
        }
        
        if ([self isKindOfClass:UINavigationBar.class]) {
            [self refreshUINavigationBar];
            break;
        }
        
        if ([self isKindOfClass:UIToolbar.class]) {
            [self refreshUIToolBar];
            break;
        }
        
        if ([self isKindOfClass:UITabBar.class]) {
            [self refreshUITabBar];
            break;
        }
        
        if ([self isKindOfClass:UISearchBar.class]) {
            [self refreshUISearchBar];
            break;
        }
                
        status = NO;
    }

    if (LLDarkSource.thirdControlList(self.className)) {
        /// 动态增加第三方UI控件刷新方法，例如YYLabel
        NSString *funName = [NSString stringWithFormat:@"refresh%@", self.className];
        [self performSelectorOnMainThread:NSSelectorFromString(funName) withObject:nil waitUntilDone:NSThread.isMainThread];
    }

    if (self.userInterfaceStyle == LLUserInterfaceStyleUnspecified) {    
        [self.layer refresh];
    }
    
    !self.appearanceBindUpdater ?: self.appearanceBindUpdater(self);
}

- (void)refreshUITabBar {
    UITabBar *t_tabBar = (UITabBar *)self;
    
    UIColor *barTintColor = t_tabBar.barTintColor;
    if (barTintColor.isTheme) {
        t_tabBar.barTintColor = barTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (@available(iOS 10.0, *)) {
        UIColor *unselectedItemTintColor = t_tabBar.unselectedItemTintColor;
        if (unselectedItemTintColor.isTheme) {
            t_tabBar.unselectedItemTintColor = unselectedItemTintColor.resolvedColor(self.userInterfaceStyle);
        }
    }
    
    UIImage *backgroundImage = t_tabBar.backgroundImage;
    if (backgroundImage.isTheme) {
        t_tabBar.backgroundImage = backgroundImage.resolvedImage(self.userInterfaceStyle);
    }
    
    UIImage *selectionIndicatorImage = t_tabBar.selectionIndicatorImage;
    if (selectionIndicatorImage.isTheme) {
        t_tabBar.selectionIndicatorImage = selectionIndicatorImage.resolvedImage(self.userInterfaceStyle);
    }
    
    UIImage *shadowImage = t_tabBar.shadowImage;
    if (shadowImage.isTheme) {
        t_tabBar.shadowImage = shadowImage.resolvedImage(self.userInterfaceStyle);
    }
    
    for (UITabBarItem *item in t_tabBar.items) {
        [self refreshUITabBarItem:item];
    }
}

- (void)refreshUITabBarItem:(UITabBarItem *)item {
    if (@available(iOS 10.0, *)) {
        UIColor *badgeColor = item.badgeColor;
        if (badgeColor.isTheme) {
            item.badgeColor = badgeColor.resolvedColor(self.userInterfaceStyle);
        }
    }
    
    UIImage *selectedImage = item.selectedDarkImage;
    if (selectedImage.isTheme) {
        item.selectedImage = selectedImage.resolvedImage(self.userInterfaceStyle);
    }
    
    [item forinUIControlState:^(UIControlState state, UITabBarItem * _Nonnull obj) {
        if (@available(iOS 10.0, *)) {
            NSMutableDictionary<NSAttributedStringKey, id> *t_dict = [[obj badgeTextAttributesForState:state] mutableCopy];
            [t_dict refreshAttributes:obj.userInterfaceStyle];
            [obj setBadgeTextAttributes:t_dict forState:state];
        }
    }];
    
    [self refreshUIBarItem:item];
}

- (void)refreshUINavigationBar {
    UINavigationBar *t_navigationBar = (UINavigationBar *)self;
    
    UIColor *barTintColor = t_navigationBar.barTintColor;
    if (barTintColor.isTheme) {
        t_navigationBar.barTintColor = barTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    UIImage *shadowImage = t_navigationBar.shadowImage;
    if (shadowImage.isTheme) {
        t_navigationBar.shadowImage = shadowImage.resolvedImage(self.userInterfaceStyle);
    }
    
    UIImage *backIndicatorImage = t_navigationBar.backIndicatorImage;
    if (backIndicatorImage.isTheme) {
        t_navigationBar.backIndicatorImage = backIndicatorImage.resolvedImage(self.userInterfaceStyle);
    }
    
    UIImage *backIndicatorTransitionMaskImage = t_navigationBar.backIndicatorTransitionMaskImage;
    if (backIndicatorTransitionMaskImage.isTheme) {
        t_navigationBar.backIndicatorTransitionMaskImage = backIndicatorTransitionMaskImage.resolvedImage(self.userInterfaceStyle);
    }
    
    NSMutableDictionary *titleTextAttributes = [t_navigationBar.titleTextAttributes mutableCopy];
    [titleTextAttributes refreshAttributes:self.userInterfaceStyle];
    t_navigationBar.titleTextAttributes = titleTextAttributes;
    
    if (@available(iOS 11.0, *)) {
        NSMutableDictionary *largeTitleTextAttributes = [t_navigationBar.largeTitleTextAttributes mutableCopy];
        [largeTitleTextAttributes refreshAttributes:self.userInterfaceStyle];
        t_navigationBar.largeTitleTextAttributes = largeTitleTextAttributes;
    }
    
    [t_navigationBar forinUIBarPosition:^(UIBarPosition position, UINavigationBar * _Nonnull obj) {
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UINavigationBar * _Nonnull obj1) {
            UIImage *t_image = [t_navigationBar backgroundImageForBarPosition:position barMetrics:metrics];
            if (t_image.isTheme) {
                [obj1 setBackgroundImage:t_image.resolvedImage(obj1.userInterfaceStyle) forBarPosition:position barMetrics:metrics];
            }
        }];
    }];
    
    for (UINavigationItem *item in t_navigationBar.items) {
        [self refreshUINavigationItem:item];
    }
}

- (void)refreshUIToolBar {
    UIToolbar *t_toolBar = (UIToolbar *)self;
    
    UIColor *t_barTintColor = t_toolBar.barTintColor;
    if (t_barTintColor.isTheme) {
        t_toolBar.barTintColor = t_barTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    [t_toolBar forinUIBarPosition:^(UIBarPosition position, UIToolbar * _Nonnull obj) {
        UIImage *t_shadowImage = [obj shadowImageForToolbarPosition:position];
        if (t_shadowImage.isTheme) {
            [obj setShadowImage:t_shadowImage.resolvedImage(obj.userInterfaceStyle) forToolbarPosition:position];
        }
        
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UIToolbar * _Nonnull obj1) {
            UIImage *t_backgroundImage = [obj1 backgroundImageForToolbarPosition:position barMetrics:metrics];
            if (t_backgroundImage.isTheme) {
                [obj1 setBackgroundImage:t_backgroundImage.resolvedImage(obj1.userInterfaceStyle) forToolbarPosition:position barMetrics:metrics];
            }
        }];
    }];
    
    for (UIBarButtonItem *item in t_toolBar.items) {
        [self refreshUIBarButtonItem:item];
    }
}

- (void)refreshUINavigationItem:(UINavigationItem *)item {
    [item.titleView refresh];
    
    for (UIBarButtonItem *buttonItem in item.leftBarButtonItems) {
        [self refreshUIBarButtonItem:buttonItem];
    }
    
    for (UIBarButtonItem *buttonItem in item.rightBarButtonItems) {
        [self refreshUIBarButtonItem:buttonItem];
    }
    
    if (@available(iOS 11.0, *)) {
        UISearchController *searchController = item.searchController;
        if (searchController.searchBar) {
            [searchController.searchBar refresh];
        }
    }
}

- (void)refreshUIBarButtonItem:(UIBarButtonItem *)item {
    [item.customView refresh];
    
    UIColor *tintColor = item.tintColor;
    if (tintColor.isTheme) {
        item.tintColor = tintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    [item forinUIControlState:^(UIControlState state, UIBarButtonItem * _Nonnull obj) {
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UIBarButtonItem * _Nonnull obj1) {
            UIImage *t_backButtonBackgroundImage = [obj1 backButtonBackgroundImageForState:state barMetrics:metrics];
            if (t_backButtonBackgroundImage.isTheme) {
                [obj1 setBackButtonBackgroundImage:t_backButtonBackgroundImage.resolvedImage(obj1.userInterfaceStyle) forState:state barMetrics:metrics];
            }
            
            [obj1 forinUIBarButtonItemStyle:^(UIBarButtonItemStyle style, UIBarButtonItem * _Nonnull obj2) {
                UIImage *t_backgroundImage = [obj2 backgroundImageForState:state style:style barMetrics:metrics];
                if (t_backgroundImage.isTheme) {
                    [obj2 setBackgroundImage:t_backgroundImage.resolvedImage(obj2.userInterfaceStyle) forState:state style:style barMetrics:metrics];
                }
            }];
        }];
    }];
    
    [self refreshUIBarItem:item];
}

- (void)refreshUIBarItem:(UIBarItem *)item {
    UIImage *t_image = item.image;
    if (t_image.isTheme) {
        item.image = t_image.resolvedImage(self.userInterfaceStyle);
    }
    
    if (@available(iOS 11.0, *)) {
        UIImage *t_largeContentSizeImage = item.largeContentSizeImage;
        if (t_largeContentSizeImage.isTheme) {
            item.largeContentSizeImage = t_largeContentSizeImage.resolvedImage(self.userInterfaceStyle);
        }
    }
    
    [item forinUIControlState:^(UIControlState state, UIBarButtonItem * _Nonnull obj) {
        NSMutableDictionary<NSAttributedStringKey, id> *t_attributes = [[obj titleTextAttributesForState:state] mutableCopy];
        [t_attributes refreshAttributes:obj.userInterfaceStyle];
        [obj setTitleTextAttributes:t_attributes forState:state];
    }];
}

- (void)refreshUIRefreshControl {
    UIRefreshControl *t_refreshControl = (UIRefreshControl *)self;
    
    NSMutableAttributedString *mutable_attr = [[NSMutableAttributedString alloc] initWithAttributedString:t_refreshControl.attributedTitle];
    [mutable_attr refreshAttributes:self.userInterfaceStyle];
    t_refreshControl.attributedTitle = mutable_attr;
}

- (void)refreshUITableView {
    UITableView *t_tableView = (UITableView *)self;
    
    if (t_tableView.sectionIndexColor.isTheme) {
        t_tableView.sectionIndexColor = t_tableView.sectionIndexColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_tableView.sectionIndexBackgroundColor.isTheme) {
        t_tableView.sectionIndexBackgroundColor = t_tableView.sectionIndexBackgroundColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_tableView.sectionIndexTrackingBackgroundColor.isTheme) {
        t_tableView.sectionIndexTrackingBackgroundColor = t_tableView.sectionIndexTrackingBackgroundColor.resolvedColor(self.userInterfaceStyle);
    }
}

- (void)refreshUIActivityIndicatorView {
    UIActivityIndicatorView *t_view = (UIActivityIndicatorView *)self;
    
    if (t_view.color.isTheme) {
        t_view.color = t_view.color.resolvedColor(self.userInterfaceStyle);
    }
}

- (void)refreshUIImageView {
    UIImageView *t_imageView = (UIImageView *)self;
    
    if (t_imageView.image.isTheme) {
        t_imageView.image = t_imageView.image.resolvedImage(self.userInterfaceStyle);
    }
    
    [t_imageView refreshImageDarkStyle];
    
    if (t_imageView.highlightedImage.isTheme) {
        t_imageView.highlightedImage = t_imageView.highlightedImage.resolvedImage(self.userInterfaceStyle);
    }
}

- (void)refreshUIProgressView {
    UIProgressView *t_progressView = (UIProgressView *)self;
    
    if (t_progressView.progressTintColor.isTheme) {
        t_progressView.progressTintColor = t_progressView.progressTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_progressView.trackTintColor.isTheme) {
        t_progressView.trackTintColor = t_progressView.trackTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_progressView.progressImage.isTheme) {
        t_progressView.progressImage = t_progressView.progressImage.resolvedImage(self.userInterfaceStyle);
    }
    
    if (t_progressView.trackImage.isTheme) {
        t_progressView.trackImage = t_progressView.trackImage.resolvedImage(self.userInterfaceStyle);
    }
}

- (void)refreshUIButton {
    UIButton *t_button = (UIButton *)self;
    
    [t_button forinUIControlState:^(UIControlState state, UIButton * _Nonnull obj) {
        // 刷新titleColor
        UIColor *titleColor = [obj titleColorForState:state];
        if (titleColor.isTheme) {
            [obj setTitleColor:titleColor.resolvedColor(obj.userInterfaceStyle) forState:state];
        }

        // 刷新shadowColor
        UIColor *shadowColor = [obj titleShadowColorForState:state];
        if (shadowColor.isTheme) {
            [obj setTitleShadowColor:shadowColor.resolvedColor(obj.userInterfaceStyle) forState:state];
        }

        // 刷新image
        UIImage *image = [obj imageForState:state];
        if (image.isTheme) {
            [obj setImage:image.resolvedImage(obj.userInterfaceStyle) forState:state];
        }

        // 刷新backgroundImage
        UIImage *backgroundImage = [obj backgroundImageForState:state];
        if (backgroundImage.isTheme) {
            [obj setBackgroundImage:backgroundImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        // 刷新富文本
        NSAttributedString *t_attr = [obj attributedTitleForState:state];
        NSMutableAttributedString *mutable_attr = [[NSMutableAttributedString alloc] initWithAttributedString:t_attr];
        [mutable_attr refreshAttributes:obj.userInterfaceStyle];
        [obj setAttributedTitle:mutable_attr forState:state];
    }];
}

- (void)refreshUIPageControl {
    UIPageControl *t_pageControl = (UIPageControl *)self;
    
    if (t_pageControl.pageIndicatorTintColor.isTheme) {
        t_pageControl.pageIndicatorTintColor = t_pageControl.pageIndicatorTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_pageControl.currentPageIndicatorTintColor.isTheme) {
        t_pageControl.currentPageIndicatorTintColor = t_pageControl.currentPageIndicatorTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (@available(iOS 14.0, *)) {
        if (t_pageControl.preferredIndicatorImage.isTheme) {
            t_pageControl.preferredIndicatorImage = t_pageControl.preferredIndicatorImage.resolvedImage(self.userInterfaceStyle);
        }
        for (NSInteger i = 0; i < t_pageControl.numberOfPages; i++) {
            UIImage *t_image = [t_pageControl indicatorImageForPage:i];
            if (t_image.isTheme) {
                t_image = t_image.resolvedImage(self.userInterfaceStyle);
                [t_pageControl setIndicatorImage:t_image forPage:i];
            }
        }
    }
}

- (void)refreshUISwitch {
    UISwitch *t_switch = (UISwitch *)self;
    
    if (t_switch.onTintColor.isTheme) {
        t_switch.onTintColor = t_switch.onTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_switch.thumbTintColor.isTheme) {
        t_switch.thumbTintColor = t_switch.thumbTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_switch.onImage.isTheme) {
        t_switch.onImage = t_switch.onImage.resolvedImage(self.userInterfaceStyle);
    }
    
    if (t_switch.offImage.isTheme) {
        t_switch.offImage = t_switch.offImage.resolvedImage(self.userInterfaceStyle);
    }
}

- (void)refreshUISlider {
    UISlider *t_slider = (UISlider *)self;
    
    if (t_slider.minimumValueImage.isTheme) {
        t_slider.minimumValueImage = t_slider.minimumValueImage.resolvedImage(self.userInterfaceStyle);
    }
    
    if (t_slider.maximumValueImage.isTheme) {
        t_slider.maximumValueImage = t_slider.maximumValueImage.resolvedImage(self.userInterfaceStyle);
    }
    
    if (t_slider.minimumTrackTintColor.isTheme) {
        t_slider.minimumTrackTintColor = t_slider.minimumTrackTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_slider.maximumTrackTintColor.isTheme) {
        t_slider.maximumTrackTintColor = t_slider.maximumTrackTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    if (t_slider.thumbTintColor.isTheme) {
        t_slider.thumbTintColor = t_slider.thumbTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    [t_slider forinUIControlState:^(UIControlState state, UISlider * _Nonnull obj) {
        UIImage *thumbImage = [obj thumbImageForState:state];
        if (thumbImage.isTheme) {
            [obj setThumbImage:thumbImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        UIImage *minimumImage = [obj minimumTrackImageForState:state];
        if (minimumImage.isTheme) {
            [obj setMinimumTrackImage:minimumImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        UIImage *maximumImage = [obj maximumTrackImageForState:state];
        if (maximumImage.isTheme) {
            [obj setMaximumTrackImage:maximumImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
    }];
}

- (void)refreshUIStepper {
    UIStepper *t_stepper = (UIStepper *)self;
    
    [t_stepper forinUIControlState:^(UIControlState state, UIStepper * _Nonnull obj) {
        UIImage *t_backgroundImage = [obj backgroundImageForState:state];
        if (t_backgroundImage.isTheme) {
            [obj setBackgroundImage:t_backgroundImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        UIImage *t_incrementImage = [obj incrementImageForState:state];
        if (t_incrementImage.isTheme) {
            [obj setIncrementImage:t_incrementImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        UIImage *t_decrementImage = [obj decrementImageForState:state];
        if (t_decrementImage.isTheme) {
            [obj setDecrementImage:t_decrementImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        [obj forinUIControlState:^(UIControlState state1, UIStepper * _Nonnull obj1) {
            UIImage *t_dividerImage = [obj1 dividerImageForLeftSegmentState:state rightSegmentState:state1];
            if (t_dividerImage.isTheme) {
                [obj1 setDividerImage:t_dividerImage.resolvedImage(obj1.userInterfaceStyle) forLeftSegmentState:state rightSegmentState:state1];
            }
        }];
    }];
}

- (void)refreshUILabel {
    UILabel *t_label = (UILabel *)self;
    
    if (t_label.highlightedTextColor.isTheme) {
        t_label.highlightedTextColor = t_label.highlightedTextColor.resolvedColor(self.userInterfaceStyle);
    }
    
    NSMutableAttributedString *t_attr = [t_label.attributedText mutableCopy];
    [t_attr refreshAttributes:self.userInterfaceStyle];
    t_label.attributedText = t_attr;
}

- (void)refreshUITextField {
    UITextField *t_textField = (UITextField *)self;
    
    NSMutableAttributedString *t_attr = [t_textField.attributedText mutableCopy];
    [t_attr refreshAttributes:self.userInterfaceStyle];
    t_textField.attributedText = t_attr;
    
    NSMutableAttributedString *t_placeAttr = [t_textField.attributedPlaceholder mutableCopy];
    [t_placeAttr refreshAttributes:self.userInterfaceStyle];
    t_textField.attributedPlaceholder = t_placeAttr;
    
    NSMutableDictionary *t_typingDict = [t_textField.typingAttributes mutableCopy];
    [t_typingDict refreshAttributes:self.userInterfaceStyle];
    t_textField.typingAttributes = t_typingDict;
    
    if (t_textField.background.isTheme) {
        t_textField.background = t_textField.background.resolvedImage(self.userInterfaceStyle);
    }
    
    if (t_textField.disabledBackground.isTheme) {
        t_textField.disabledBackground = t_textField.disabledBackground.resolvedImage(self.userInterfaceStyle);
    }
    
    if (t_textField.inputView) {
        [t_textField.inputView refresh];
    }
    
    if (t_textField.inputAccessoryView) {
        [t_textField.inputAccessoryView refresh];
    }
    
    if (t_textField.textColor.isTheme) {
        t_textField.textColor = t_textField.textColor.resolvedColor(self.userInterfaceStyle);
    }
}

- (void)refreshUITextView {
    UITextView *t_textView = (UITextView *)self;
    
    NSMutableAttributedString *t_attr = [t_textView.attributedText mutableCopy];
    [t_attr refreshAttributes:self.userInterfaceStyle];
    t_textView.attributedText = t_attr;
    
    NSMutableDictionary *t_typingDict = [t_textView.typingAttributes mutableCopy];
    [t_typingDict refreshAttributes:self.userInterfaceStyle];
    t_textView.typingAttributes = t_typingDict;
    
    NSMutableDictionary *t_linkDict = [t_textView.linkTextAttributes mutableCopy];
    [t_linkDict refreshAttributes:self.userInterfaceStyle];
    t_textView.linkTextAttributes = t_linkDict;
    
    if (t_textView.inputView) {
        [t_textView.inputView refresh];
    }
    
    if (t_textView.inputAccessoryView) {
        [t_textView.inputAccessoryView refresh];
    }
}

- (void)refreshUISegmentedControl {
    UISegmentedControl *t_segmented = (UISegmentedControl *)self;
    
    if (@available(iOS 13.0, *)) {
        if (t_segmented.selectedSegmentTintColor.isTheme) {
            t_segmented.selectedSegmentTintColor = t_segmented.selectedSegmentTintColor.resolvedColor(self.userInterfaceStyle);
        }
    }
    
    for (NSInteger i = 0; i < t_segmented.numberOfSegments; i++) {
        UIImage *t_image = [t_segmented imageForSegmentAtIndex:i];
        if (t_image.isTheme) {
            [t_segmented setImage:t_image.resolvedImage(self.userInterfaceStyle) forSegmentAtIndex:i];
        }
    }
    
    [t_segmented forinUIControlState:^(UIControlState state, UISegmentedControl * _Nonnull obj) {
        NSMutableDictionary<NSAttributedStringKey, id> *t_dict = [[obj titleTextAttributesForState:state] mutableCopy];
        [t_dict refreshAttributes:obj.userInterfaceStyle];
        [obj setTitleTextAttributes:t_dict forState:state];
                
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UISegmentedControl * _Nonnull obj1) {
            UIImage *t_backgroundImage = [obj1 backgroundImageForState:state barMetrics:metrics];
            if (t_backgroundImage.isTheme) {
                [obj1 setBackgroundImage:t_backgroundImage.resolvedImage(obj1.userInterfaceStyle) forState:state barMetrics:metrics];
            }
            
            [obj1 forinUIControlState:^(UIControlState state1, UISegmentedControl * _Nonnull obj2) {
                UIImage *t_dividerImage = [obj2 dividerImageForLeftSegmentState:state rightSegmentState:state1 barMetrics:metrics];
                if (t_dividerImage.isTheme) {
                    [obj2 setDividerImage:t_dividerImage.resolvedImage(obj2.userInterfaceStyle) forLeftSegmentState:state rightSegmentState:state1 barMetrics:metrics];
                }
            }];
        }];
    }];
}

- (void)refreshUISearchBar {
    UISearchBar *t_searchBar = (UISearchBar *)self;
    
    UIView *inputAccessoryView = t_searchBar.inputAccessoryView;
    [inputAccessoryView refresh];
    
    UIColor *barTintColor = t_searchBar.barTintColor;
    if (barTintColor.isTheme) {
        t_searchBar.barTintColor = barTintColor.resolvedColor(self.userInterfaceStyle);
    }
    
    UIImage *scopeBarBackgroundImage = t_searchBar.scopeBarBackgroundImage;
    if (scopeBarBackgroundImage.isTheme) {
        t_searchBar.scopeBarBackgroundImage = scopeBarBackgroundImage.resolvedImage(self.userInterfaceStyle);
    }
    
    [t_searchBar forinUIBarPosition:^(UIBarPosition position, UISearchBar * _Nonnull obj) {
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UISearchBar * _Nonnull obj1) {
            UIImage *t_image = [obj1 backgroundImageForBarPosition:position barMetrics:metrics];
            if (t_image.isTheme) {
                [obj1 setBackgroundImage:t_image.resolvedImage(obj1.userInterfaceStyle) forBarPosition:position barMetrics:metrics];
            }
        }];
    }];
    
    [t_searchBar forinUIControlState:^(UIControlState state, UISearchBar * _Nonnull obj) {
        UIImage *searchFieldBackgroundImage = [obj searchFieldBackgroundImageForState:state];
        if (searchFieldBackgroundImage.isTheme) {
            [obj setSearchFieldBackgroundImage:searchFieldBackgroundImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        UIImage *scopeBarButtonBackgroundImage = [obj scopeBarButtonBackgroundImageForState:state];
        if (scopeBarButtonBackgroundImage.isTheme) {
            [obj setScopeBarButtonBackgroundImage:scopeBarButtonBackgroundImage.resolvedImage(obj.userInterfaceStyle) forState:state];
        }
        
        NSMutableDictionary<NSAttributedStringKey, id> *attributes = [[obj scopeBarButtonTitleTextAttributesForState:state] mutableCopy];
        [attributes refreshAttributes:obj.userInterfaceStyle];
        [obj setScopeBarButtonTitleTextAttributes:attributes forState:state];
        
        [obj forinUISearchBarIcon:^(UISearchBarIcon icon, UISearchBar * _Nonnull obj1) {
            UIImage *t_image = [obj1 imageForSearchBarIcon:icon state:state];
            if (t_image.isTheme) {
                [obj1 setImage:t_image.resolvedImage(obj1.userInterfaceStyle) forSearchBarIcon:icon state:state];
            }
        }];
        
        [obj forinUIControlState:^(UIControlState state1, UISearchBar * _Nonnull obj1) {
            UIImage *t_image = [obj1 scopeBarButtonDividerImageForLeftSegmentState:state rightSegmentState:state1];
            if (t_image.isTheme) {
                [obj1 setScopeBarButtonDividerImage:t_image.resolvedImage(obj1.userInterfaceStyle) forLeftSegmentState:state rightSegmentState:state1];
            }
        }];
    }];
}

@end
