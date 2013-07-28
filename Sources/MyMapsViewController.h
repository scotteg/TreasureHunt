
#import <UIKit/UIKit.h>

@class DataModel;

// The view controller for the "My Maps" screen. This is the main screen of
// the app and it shows all the maps that this user has created.
//
@interface MyMapsViewController : UITableViewController

@property (nonatomic, strong) DataModel *dataModel;

@end
