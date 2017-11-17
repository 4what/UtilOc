//
//  @author 4what
//

#import "OCKnobControlSampleViewController.h"

#import "OCKnobControl.h"

@implementation OCKnobControlSampleViewController {
	OCKnobControl *_knobControl;

	UISwitch *_animateSwitch;

	UIButton *_randomButton;

	UILabel *_valueLabel;
	UISlider *_valueSlider;
}

- (void)sliderOnValueChanged:(id)sender {
	if (sender == _valueSlider) {
		_knobControl.value = _valueSlider.value;
	} else if (sender == _knobControl) {
		_valueSlider.value = _knobControl.value;
	}
}

- (void)randomButtonOnTouchUpInside:(UIButton *)sender {
	CGFloat randomValue = (arc4random() % 101) / 100.f;
	[_knobControl setValue:randomValue animated:_animateSwitch.on];
	[_valueSlider setValue:randomValue animated:_animateSwitch.on];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == OCKnobControlObserverContext) {
		if ([keyPath isEqualToString:@"value"] && object == _knobControl) {
			_valueLabel.text = [NSString stringWithFormat:@"%0.2f", _knobControl.value];
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark

- (void)viewDidLoad {
	[super viewDidLoad];


	//self.view.tintColor = [UIColor redColor];


	_knobControl = [[OCKnobControl alloc] initWithFrame:CGRectMake(16, 36, 100, 100)];
	[self.view addSubview:_knobControl];

	//_knobControl.startAngle = -M_PI;
	//_knobControl.endAngle = 0;


	_valueSlider = [[UISlider alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_knobControl.frame), 100, 100)];
	[self.view addSubview:_valueSlider];

	[_valueSlider addTarget:self action:@selector(sliderOnValueChanged:) forControlEvents:UIControlEventValueChanged];


	_randomButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.view addSubview:_randomButton];

	_randomButton.frame = CGRectMake(CGRectGetMaxX(_valueSlider.frame), CGRectGetMinY(_valueSlider.frame), 100, 100);
	[_randomButton setTitle:@"Random" forState:UIControlStateNormal];

	[_randomButton addTarget:self action:@selector(randomButtonOnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];


	_animateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_valueSlider.frame), 100, 100)];
	[self.view addSubview:_animateSwitch];


	_valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_knobControl.frame), CGRectGetMinY(_knobControl.frame), 100, 100)];
	[self.view addSubview:_valueLabel];

	_valueLabel.text = @"0.00";


	[_knobControl addObserver:self forKeyPath:@"value" options:0 context:OCKnobControlObserverContext];


	[_knobControl addTarget:self action:@selector(sliderOnValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark

- (void)dealloc {
	[_knobControl removeObserver:self forKeyPath:@"value" context:OCKnobControlObserverContext];
}

@end
