
@class DataModel;
@class TreasureMap;

// This is the screen that appears when the user taps a treasure map. It shows
// the photo for the map, the instructions, and any clues.
//
// This is where you'd spend most of your time if you were trying to decypher a
// map and find the treasure.
//
@interface MapDetailViewController : UIViewController

@property (nonatomic, strong) DataModel *dataModel;
@property (nonatomic, strong) TreasureMap *map;

@end
