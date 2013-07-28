
@class DataModel;

// The view controller for the "Shared Maps" screen. This (pretends to) show
// all the treasure maps that are on the server and it lets the user narrow
// down the list using a search box. Of course, in this sample project there
// really isn't a server so the number of available maps is limited.
//
@interface SharedMapsViewController : UITableViewController

@property (nonatomic, strong) DataModel *dataModel;

@end
