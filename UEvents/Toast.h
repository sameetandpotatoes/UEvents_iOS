#import <UIKit/UIKit.h>

@interface Toast : UIView

@property (strong, nonatomic) UILabel *textLabel;
+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuration:(float)duration;

@end