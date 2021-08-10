#import "OCKeyboardUtil.h"

@implementation OCKeyboardUtil

static UIView *_activeView;
static CGRect _rect;

+ (void)didShow:(NSNotification *)sender items:(NSArray *)items viewController:(UIViewController *)viewController {
	if (_activeView) {
		CGRect frame = _rect = _activeView.frame;
		CGRect KeyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

		for (UIView *item in items) {
			if (_activeView == item) {
				frame = [_activeView convertRect:_activeView.frame toView:nil]; // for Window
				break;
			}
		}

		if (CGRectGetMaxY(frame) <= CGRectGetMinY(KeyboardFrame) - 8) {
			return;
		}

		CGFloat y = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame) + CGRectGetHeight(viewController.navigationController.navigationBar.bounds) + 8;

		CGFloat delta = (CGRectGetHeight(KeyboardFrame) + 8) - (CGRectGetHeight(UIScreen.mainScreen.bounds) - CGRectGetMaxY(frame));

		[UIView animateWithDuration:0.2 animations:^{
			if (CGRectGetMinY(frame) - delta > y) {
				viewController.view.transform = CGAffineTransformMakeTranslation(0, -delta);
			} else {
				if (CGRectGetMinY(frame) > y) {
					viewController.view.transform = CGAffineTransformMakeTranslation(0, -(CGRectGetMinY(frame) - y));
				}

				CGRect rect = _activeView.frame;
				rect.size.height -= (CGRectGetMaxY(frame) - (CGRectGetMinY(KeyboardFrame) - 8)) - (CGRectGetMinY(frame) - y);
				_activeView.frame = rect;
			}
		}];
	}
}

+ (void)hide:(NSArray *)items {
	for (id item in items) {
		if ([item isFirstResponder]) {
			[item resignFirstResponder];
			break;
		}
	}
}

+ (void)setActiveView:(UIView *)view {
	_activeView = view;
}

+ (void)willHide:(NSNotification *)sender viewController:(UIViewController *)viewController {
	if (_activeView) {
		[UIView animateWithDuration:0.2 animations:^{
			_activeView.frame = _rect;

			viewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
		}];
	}
}

@end
