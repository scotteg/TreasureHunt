
// Users can leave clues and other comments on a shared treasure map, so that
// deciphering the location of the treasure becomes a social experience.
//
@interface Clue : NSObject <NSCoding>

// The text of the clue or comment.
@property (nonatomic, copy) NSString *text;

// The name of the user who left the clue.
@property (nonatomic, copy) NSString *sharedBy;

@end
