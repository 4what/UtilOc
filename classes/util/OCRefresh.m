//
//  @author 4what
//

#import "OCRefresh.h"

@implementation OCRefresh {
	UIScrollView *_scrollView;

	CAShapeLayer *_trackLayer;
	CAShapeLayer *_pointerLayer;

	UIEdgeInsets _insets;
}

static void *OCRefreshObserverContext = &OCRefreshObserverContext;

static CGFloat padding = 16;

- (void)stop {
	if (_running) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.4 animations:^{
				_scrollView.contentInset = _insets;
			} completion:^(BOOL finished) {
				_trackLayer.strokeEnd = 0;

				_pointerLayer.hidden = YES;
				[_pointerLayer removeAllAnimations];

				_running = NO;
			}];
		});
	}
}

#pragma mark - getter & setter

- (void)setDiameter:(CGFloat)diameter {
	if (diameter != _diameter) {
		_diameter = diameter;

		_trackLayer.bounds = _pointerLayer.bounds = CGRectMake(0, 0, diameter, diameter);
		_trackLayer.path = _pointerLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, diameter, diameter)].CGPath;
	}
}

- (void)setLineWidth:(CGFloat)lineWidth {
	if (lineWidth != _lineWidth) {
		_lineWidth = lineWidth;

		_trackLayer.lineWidth = lineWidth;
		_pointerLayer.lineWidth = lineWidth + 0.8;
	}
}


- (void)setPointerColor:(UIColor *)pointerColor {
	if (pointerColor != _pointerColor) {
		_pointerColor = pointerColor;

		_pointerLayer.strokeColor = pointerColor.CGColor;
	}
}

- (void)setTrackColor:(UIColor *)trackColor {
	if (trackColor != _trackColor) {
		_trackColor = trackColor;

		_trackLayer.strokeColor = trackColor.CGColor;
	}
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!_running && _trackLayer.strokeEnd >= 1) {
		_running = YES;

		_insets = _scrollView.contentInset;

		scrollView.contentInset = UIEdgeInsetsMake(_insets.top + (padding + self.diameter + padding), _insets.left, _insets.bottom, _insets.right);

		_pointerLayer.hidden = NO;

		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.duration = 1;
		animation.fromValue = @0;
		animation.repeatCount = CGFLOAT_MAX;
		animation.toValue = @(M_PI * 2);
		[_pointerLayer addAnimation:animation forKey:nil];

		[_delegate reload];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (!_running) {
		_trackLayer.strokeEnd = (-scrollView.contentOffset.y - (padding + self.diameter)) / self.diameter;
	}
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == OCRefreshObserverContext) {
		if ([keyPath isEqualToString:NSStringFromSelector(@selector(bounds))]) {
			_trackLayer.position = _pointerLayer.position = CGPointMake(CGRectGetWidth(_scrollView.bounds) / 2.f, -(padding + self.diameter / 2.f));
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
	self = [super init];
	if (self) {
		_scrollView = scrollView;

		[_scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) options:NSKeyValueObservingOptionInitial context:OCRefreshObserverContext];

		_trackLayer = [CAShapeLayer layer];
		[_scrollView.layer addSublayer:_trackLayer];

		_trackLayer.affineTransform = CGAffineTransformRotate(_trackLayer.affineTransform, -(M_PI / 2.f));
		_trackLayer.fillColor = [UIColor clearColor].CGColor;
		_trackLayer.strokeEnd = 0;

		_pointerLayer = [CAShapeLayer layer];
		[_scrollView.layer addSublayer:_pointerLayer];

		_pointerLayer.hidden = YES;

		_pointerLayer.affineTransform = _trackLayer.affineTransform;
		_pointerLayer.fillColor = [UIColor clearColor].CGColor;
		_pointerLayer.lineCap = kCALineCapRound;
		_pointerLayer.strokeEnd = 0.1;

		// defaults
		self.diameter = 24;
		self.lineWidth = 1;

		self.trackColor = [UIColor lightGrayColor];
		self.pointerColor = [UIColor whiteColor];
	}
	return self;
}

#pragma mark

- (void)dealloc {
	[_scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) context:OCRefreshObserverContext];
}

@end
