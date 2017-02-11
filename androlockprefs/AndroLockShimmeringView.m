#import "AndroLockPrefs.h"

@implementation AndroLockShimmeringView
- (void)startShimmering {
    CGColorRef lightColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    CGColorRef darkColor = [UIColor blackColor].CGColor;

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)darkColor, (id)lightColor, (id)darkColor];
    gradient.frame = CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width * 3, self.bounds.size.height);
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.525);
    gradient.locations = @[@0.4, @0.5, @0.6];
    self.layer.mask = gradient;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@0, @0.1, @0.2];
    animation.toValue = @[@0.8, @0.9, @1];
    animation.duration = 2.5;
    animation.repeatCount = INFINITY;
    [gradient addAnimation:animation forKey:@"shimmer"];
}

- (void)stopShimmering {
    self.layer.mask = nil;
}
@end
