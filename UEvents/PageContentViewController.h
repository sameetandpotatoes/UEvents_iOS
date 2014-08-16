#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface PageContentViewController : GAITrackedViewController


@property (weak, nonatomic) IBOutlet UIButton *buttonLoginLogout;
    @property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
    @property NSUInteger pageIndex;
    @property NSString *titleText;
    @property NSString *imageFile;
    @property FBLoginView *fbl;
@end