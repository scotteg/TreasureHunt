
#import "Clue.h"

// Describes a single treasure map object.
//
// Because this class conforms to the NSCoding protocol, TreasureMap instances
// can be archived into a plist file, which is how we will save this app's data
// to disk.
//
@interface TreasureMap : NSObject <NSCoding>

// Each treasure map has a name. The user can search treasure maps by name.
@property (nonatomic, copy) NSString *name;

// The most important part of the treasure map is a photo of the actual map.
// We don't keep the UIImage itself in memory, only its filename.
@property (nonatomic, copy) NSString *photoFilename;

// The thumbnail is readonly because it is automatically generated from the
// photo property. If there is no photo set, then thumbnail returns a default
// image, UnknownThumb.png.
@property (nonatomic, strong, readonly) UIImage *thumbnail;

// This creates a new thumbnail. Use this when you change the photo.
- (void)refreshThumbnail;

// Besides a photo, some treasure maps may also have written instructions, or
// a short description of the history of the map.
@property (nonatomic, copy) NSString *instructions;

// The award type is the sort of treasure you can expect to find.
@property (nonatomic, copy) NSString *awardType;

// The date when the treasure was (supposedly) hidden.
@property (nonatomic, copy) NSDate *date;

// The username of the person who shared this map.
@property (nonatomic, copy) NSString *sharedBy;

// This is YES if the map was created by the current user.
@property (nonatomic, assign) BOOL fromLocalUser;

// The clues (or comments) for this treasure map. These are left by other
// users as they try to unravel the mystery.
@property (nonatomic, strong, readonly) NSArray *clues;

- (void)addClue:(Clue *)clue;

// Loads the UIImage with this treasure map's photo. Because these photos are
// usually quite big, the app cannot hold all the photos for all treasure maps
// in memory at once. So the photo is loaded on demand only.
- (UIImage *)loadPhoto;

@end
