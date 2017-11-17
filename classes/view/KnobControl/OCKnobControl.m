//
//  @author 4what
//
//  http://www.raywenderlich.com/56885/custom-control-for-ios-tutorial-a-reusable-knob
//  http://www.cocoachina.com/ios/20150122/10996.html
//

#import "OCKnobControl.h"

@interface OCKnobControl ()

@property (nonatomic) CGFloat thumbAngle;

@end

@implementation OCKnobControl {
	UIPanGestureRecognizer *_gestureRecognizer;
	CGFloat _touchAngle;

	CAShapeLayer *_trackLayer;
	CAShapeLayer *_highlightLayer;
	CAShapeLayer *_thumbLayer;
}

- (CGFloat)calculateAngleWithPoint:(CGPoint)point {
	CGPoint offset = CGPointMake(point.x - CGRectGetMidX(self.bounds), point.y - CGRectGetMidY(self.bounds));
	return atan2(offset.y, offset.x);
}

- (void)gestureRecognizer:(UIPanGestureRecognizer *)sender {
	// 1. Mid-point angle
	CGFloat midPointAngle = (2 * M_PI + self.startAngle - self.endAngle) / 2.f + self.endAngle;

	// 2. Ensure the angle is within a suitable range
	CGFloat boundedAngle = _touchAngle;
	if (boundedAngle > midPointAngle) {
		boundedAngle -= 2 * M_PI;
	} else if (boundedAngle < (midPointAngle - 2 * M_PI)) {
		boundedAngle += 2 * M_PI;
	}
	// 3. Bound the angle to within the suitable range
	boundedAngle = MIN(self.endAngle, MAX(self.startAngle, boundedAngle));

	// 4. Convert the angle to a value
	CGFloat angleRange = self.endAngle - self.startAngle;
	CGFloat valueRange = self.maximumValue - self.minimumValue;
	CGFloat valueForAngle = (boundedAngle - self.startAngle) / angleRange * valueRange + self.minimumValue;

	// 5. Set the control to this value
	if (fabs(valueForAngle - self.value) < self.maximumValue - self.minimumValue) {
		self.value = valueForAngle;
	}

	// Notify of value change
	if (self.continuous) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	} else {
		// Only send an update if the gesture has completed
		if (_gestureRecognizer.state == UIGestureRecognizerStateCancelled || _gestureRecognizer.state == UIGestureRecognizerStateEnded) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}
}

- (void)updateHighlightLayer {
	CGPoint center = CGPointMake(CGRectGetWidth(_highlightLayer.bounds) / 2.f, CGRectGetHeight(_highlightLayer.bounds) / 2.f);
	CGFloat offset = MAX(self.thumbRadius, self.trackLineWidth / 2.f);
	CGFloat radius = MIN(CGRectGetHeight(_highlightLayer.bounds), CGRectGetWidth(_highlightLayer.bounds)) / 2.f - offset;
	_highlightLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:self.startAngle endAngle:self.thumbAngle clockwise:YES].CGPath;
}

- (void)updateThumbLayer {
	_thumbLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetWidth(_thumbLayer.bounds) - self.thumbRadius * 2, CGRectGetHeight(_thumbLayer.bounds) / 2.f - self.thumbRadius, self.thumbRadius * 2, self.thumbRadius * 2)].CGPath;
}

- (void)updateTouchAngleWithTouches:(NSSet *)touches {
	UITouch *touch = [touches anyObject];
	_touchAngle = [self calculateAngleWithPoint:[touch locationInView:self]];
}

- (void)updateTrackLayer {
	CGPoint center = CGPointMake(CGRectGetWidth(_trackLayer.bounds) / 2.f, CGRectGetHeight(_trackLayer.bounds) / 2.f);
	CGFloat offset = MAX(self.thumbRadius, self.trackLineWidth / 2.f);
	CGFloat radius = MIN(CGRectGetHeight(_trackLayer.bounds), CGRectGetWidth(_trackLayer.bounds)) / 2.f - offset;
	_trackLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES].CGPath;
}

#pragma mark - getter & setter

- (void)setEndAngle:(CGFloat)endAngle {
	if (endAngle != _endAngle) {
		_endAngle = endAngle;

		[self updateTrackLayer];
		[self updateHighlightLayer];
	}
}

- (void)setHighlightColor:(UIColor *)highlightColor {
	if (highlightColor != _highlightColor) {
		_highlightColor = highlightColor;

		_highlightLayer.strokeColor = highlightColor.CGColor;
	}
}

- (void)setStartAngle:(CGFloat)startAngle {
	if (startAngle != _startAngle) {
		_startAngle = startAngle;

		[self updateTrackLayer];
		[self updateHighlightLayer];
	}
}

- (void)setThumbAngle:(CGFloat)thumbAngle {
	[self setThumbAngle:thumbAngle animated:NO];
}

- (void)setThumbAngle:(CGFloat)thumbAngle animated:(BOOL)animated {
	[CATransaction new];
	[CATransaction setCompletionBlock:^{
		[self updateHighlightLayer];
	}];
	[CATransaction setDisableActions:YES];
	_thumbLayer.transform = CATransform3DMakeRotation(thumbAngle, 0, 0, 1);
	if (animated) {
		CGFloat midAngle = (MAX(thumbAngle, _thumbAngle) - MIN(thumbAngle, _thumbAngle)) / 2.f + MIN(thumbAngle, _thumbAngle);
		CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.duration = 0.25;
		animation.keyTimes = @[@(0), @(0.5), @(1)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		animation.values = @[@(_thumbAngle), @(midAngle), @(thumbAngle)];
		[_thumbLayer addAnimation:animation forKey:nil];
	}
	[CATransaction commit];
	_thumbAngle = thumbAngle;
}

- (void)setThumbColor:(UIColor *)thumbColor {
	if (thumbColor != _thumbColor) {
		_thumbColor = thumbColor;

		_thumbLayer.fillColor = thumbColor.CGColor;
	}
}

- (void)setThumbRadius:(CGFloat)thumbRadius {
	if (thumbRadius != _thumbRadius) {
		_thumbRadius = thumbRadius;

		[self updateTrackLayer];
		[self updateHighlightLayer];
		[self updateThumbLayer];
	}
}

- (void)setTrackColor:(UIColor *)trackColor {
	if (trackColor != _trackColor) {
		_trackColor = trackColor;

		_trackLayer.strokeColor = trackColor.CGColor;
	}
}

- (void)setTrackLineWidth:(CGFloat)trackLineWidth {
	if (trackLineWidth != _trackLineWidth) {
		_trackLineWidth = trackLineWidth;

		_trackLayer.lineWidth = trackLineWidth;
		_highlightLayer.lineWidth = trackLineWidth;

		[self updateTrackLayer];
		[self updateHighlightLayer];
		[self updateThumbLayer];
	}
}

- (void)setValue:(CGFloat)value {
	[self setValue:value animated:NO];
}

- (void)setValue:(CGFloat)value animated:(BOOL)animated {
	if (value != _value) {
		[self willChangeValueForKey:@"value"];

		_value = MIN(self.maximumValue, MAX(self.minimumValue, value));

		CGFloat angleRange = self.endAngle - self.startAngle;
		CGFloat valueRange = self.maximumValue - self.minimumValue;
		CGFloat angleForValue = (self.value - self.minimumValue) / valueRange * angleRange + self.startAngle;

		[self setThumbAngle:angleForValue animated:animated];

		[self didChangeValueForKey:@"value"];
	}
}

#pragma mark

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
	if ([key isEqualToString:@"value"]) {
		return NO;
	} else {
		return [super automaticallyNotifiesObserversForKey:key];
	}
}

#pragma mark

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];

	[self updateTouchAngleWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];

	[self updateTouchAngleWithTouches:touches];
}

#pragma mark

/*
- (void)tintColorDidChange {
	self.trackColor = self.tintColor;
	self.thumbColor = self.tintColor;
}
*/

#pragma mark

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];

	self.alpha = enabled ? 1 : 0.2;
}

#pragma mark

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_trackLayer = [CAShapeLayer layer];
		[self.layer addSublayer:_trackLayer];

		_trackLayer.bounds = self.bounds;
		_trackLayer.fillColor = [UIColor clearColor].CGColor;
		_trackLayer.lineCap = kCALineCapRound;
		_trackLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);

		_highlightLayer = [CAShapeLayer layer];
		[self.layer addSublayer:_highlightLayer];

		_highlightLayer.bounds = _trackLayer.bounds;
		_highlightLayer.lineCap = kCALineCapRound;
		_highlightLayer.fillColor = [UIColor clearColor].CGColor;
		_highlightLayer.position = _trackLayer.position;

		_thumbLayer = [CAShapeLayer layer];
		[self.layer addSublayer:_thumbLayer];

		_thumbLayer.bounds = _trackLayer.bounds;
		_thumbLayer.position = _trackLayer.position;
		_thumbLayer.shadowOffset = CGSizeZero;
		_thumbLayer.shadowOpacity = 0.5;

		_gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
		[self addGestureRecognizer:_gestureRecognizer];

		_gestureRecognizer.cancelsTouchesInView = NO;
		_gestureRecognizer.minimumNumberOfTouches = 1;
		_gestureRecognizer.maximumNumberOfTouches = 1;


		// defaults
		self.startAngle = -M_PI;
		self.endAngle = 0;

		self.minimumValue = 0;
		self.maximumValue = 1;
		self.value = 0;

		self.trackColor = [UIColor lightGrayColor];
		self.trackLineWidth = 8;

		self.highlightColor = self.tintColor;

		self.thumbAngle = self.startAngle;
		self.thumbColor = [UIColor whiteColor];
		self.thumbRadius = (self.trackLineWidth + 8) / 2.f;

		self.continuous = YES;
	}
	return self;
}

@end
