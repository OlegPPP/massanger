//
//  APChatManager.h
//

#import <Foundation/Foundation.h>
#import "API_Chat.h"
#import "API_ChatMessage.h"

@interface APChatManager : NSObject


//*************************************************************************************************************************************
//Retrieve new chats and chat messages - here you can generate test data and load into Core Data entities CDChat and CDChatMessage 
//*************************************************************************************************************************************
- (void) loadLatestChatMessages:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;


//**************************************************************************************************************************************
// Create a new chat (API Chat contains chat data captured on chat screen). Map this API Chat object into CDChat and store in data store
//**************************************************************************************************************************************
- (void) createChat:(API_Chat *)newChat success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
//**************************************************************************************************************************************
// Update chat (API Chat contains chat data captured on chat screen). Map this API Chat object into existing CDChat entity and store in 
// data store
//**************************************************************************************************************************************
- (void) updateChat:(API_Chat *)newChat success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
//**************************************************************************************************************************************
// Exit existing chat.
//**************************************************************************************************************************************
- (void) exitChat:(NSString *)chatId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//**************************************************************************************************************************************
// Create a new chat message (API Chat contains chat message captured on chat screen). Map this API chat message object into CDChatMessage
// and store in data store
//**************************************************************************************************************************************
- (void) createChatMessage:(API_ChatMessage *)newChatMessage success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;;
//**************************************************************************************************************************************
// Delete chat message. Retrieve Chat Message entity from Data Store update status as deleted
//**************************************************************************************************************************************
- (void) deleteChatMessage:(NSString *)chatId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;;

//Clear chat, remove chat from data store
- (void) clearChat:(NSString *)chatId;

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSString *currentUserId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (NSString *)fullName;

@end
