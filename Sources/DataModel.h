
#import "TreasureMap.h"

// This is the main data model object for the app. It contains a list of the
// TreasureMap objects.
//
@interface DataModel : NSObject

// This list contains all the shared treasure maps by all users. If this were
// a real app, it would download this list from a server.
@property (nonatomic, strong, readonly) NSArray *allMaps;

// This list contains only the treasure maps that were created by this user.
@property (nonatomic, strong, readonly) NSArray *myMaps;

// Methods to do stuff with the treasure maps.
- (void)addMap:(TreasureMap *)map;
- (void)removeMap:(TreasureMap *)map;
- (NSArray *)filterMaps:(NSString *)searchText;

// This must be called to save the contents of the data model to a plist file.
// In this app, we call the save method right away whenever a change is made,
// for example when a new map is added to the data model.
- (void)save;

@end
