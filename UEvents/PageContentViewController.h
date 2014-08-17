#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface PageContentViewController : GAITrackedViewController


    @property (weak, nonatomic) IBOutlet UIButton *buttonLoginLogout;
    @property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
    @property (weak, nonatomic) IBOutlet UILabel *swipeText;
    @property (weak, nonatomic) IBOutlet UITextView *introDescription;

    @property NSUInteger pageIndex;
    @property NSString *titleText;
    @property NSString *imageFile;
    @property FBLoginView *fbl;
    @property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end