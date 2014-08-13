#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface PageContentViewController : GAITrackedViewController

    @property (weak, nonatomic) IBOutlet FBLoginView *loginView;
    @property (weak, nonatomic) IBOutlet UITextView *textView;
    @property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
    @property (weak, nonatomic) IBOutlet UILabel *swipeText;
    @property NSUInteger pageIndex;
    @property NSString *titleText;
    @property NSString *imageFile;
    @property FBLoginView *fbl;
@end