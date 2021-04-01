//
// @author 4what
//
// TODO: iOS11+
//

#import <UIKit/UIKit.h>

@interface OCKeyboardUtil : NSObject

+ (void)didShow:(NSNotification *)sender items:(NSArray *)items viewController:(UIViewController *)viewController;

+ (void)hide:(NSArray *)items;

+ (void)setActiveView:(UIView *)view;

+ (void)willHide:(NSNotification *)sender viewController:(UIViewController *)viewController;

@end
