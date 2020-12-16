//
//  @author 4what
//

#import <UIKit/UIKit.h>

static void *OCKnobControlObserverContext = &OCKnobControlObserverContext;

@interface OCKnobControl : UIControl

@property (nonatomic) CGFloat startAngle; // (degrees)
@property (nonatomic) CGFloat endAngle; // (degrees)

@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;
@property (nonatomic) CGFloat value;

@property (nonatomic) UIColor *trackColor;
@property (nonatomic) CGFloat trackLineWidth;

@property (nonatomic) UIColor *highlightColor;

@property (nonatomic) UIColor *thumbColor;
@property (nonatomic) CGFloat thumbRadius;

@property (nonatomic, getter=isContinuous) BOOL continuous;

- (void)setValue:(CGFloat)value animated:(BOOL)animated;

@end
