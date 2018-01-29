//
//  API_ChatMessage.h
//

#import <Foundation/Foundation.h>

@interface API_ChatMessage : NSObject

@property (nonatomic, assign) NSString * chatMessageId;
@property (nonatomic, assign) NSString * messageText;
@property (nonatomic, assign) NSString * messageImageId;
@property (nonatomic, assign) NSString * messageVideoId;


@end
