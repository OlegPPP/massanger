//
//  APChatManager.m
//

#import "APChatManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CDChat+CoreDataClass.h"
#import <FCUUID.h>
#import "CDChatMessage+CoreDataClass.h"

@implementation APChatManager

//*************************************************************************
// TODO Add Implementation to support UI
//*************************************************************************

+ (instancetype)sharedManager {
    static APChatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        
        // This should be fetched through API
        manager.currentUserId = @"CURRENT_USER_ID";
        manager.firstName = @"Egor";
        manager.lastName = @"Tarasov";
    });
    
    return manager;
}

- (void)createChat:(API_Chat *)newChat success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDChat" inManagedObjectContext:managedContext];
    
    CDChat *chat = [[CDChat alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    
    chat.chatId = newChat.chatID;
    chat.chatOwner = _currentUserId;
    chat.isChatOwner = @"true";
    chat.exitedChat = @"false";
    
    NSMutableDictionary *subjectDic = [@{@"subjectTitle": newChat.subjectTitle,
                                        @"subjectType": newChat.subjectType} mutableCopy];
    if (newChat.subjectTeamID) {
        subjectDic[@"subjectTeamID"] = newChat.subjectTeamID;
    }
    if (newChat.subjectSportID) {
        subjectDic[@"subjectSportID"] = newChat.subjectSportID;
    }
    if (newChat.subjectFixtureID) {
        subjectDic[@"subjectFixtureID"] = newChat.subjectFixtureID;
    }
    if (newChat.subjectImageID) {
        subjectDic[@"subjectImageID"] = newChat.subjectTeamID;
    }
    
    subjectDic[@"subjectImageAvailable"] = newChat.subjectImageAvailable;
    
    if (newChat.subjectImageLastUpdateDate) {
        subjectDic[@"subjectImageLastUpdateDate"] = newChat.subjectImageLastUpdateDate;
    }
    
    chat.subject = [subjectDic copy];
    
    // Fetch contacts
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"CDContact" inManagedObjectContext:managedContext];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:contactsEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"appContactId IN %@", newChat.chatMemberContactId]];
    NSError *error;
    NSArray *fetchedContacts = [managedContext executeFetchRequest:request error:&error];
    
    if (!error) {
        [chat addChatWithContacts:[NSSet setWithArray:fetchedContacts]];
        
        [managedContext save:&error];
        if (!error) {
            success(@"success");
            return;
        }
    }
    failure(error.localizedDescription);
}

- (void)updateChat:(API_Chat *)newChat success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDChat" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"chatId == %@", newChat.chatID]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDChat *chat = results[0];
    
    NSMutableDictionary *subjectDic = [@{@"subjectTitle": newChat.subjectTitle,
                                         @"subjectType": newChat.subjectType} mutableCopy];
    if (newChat.subjectTeamID) {
        subjectDic[@"subjectTeamID"] = newChat.subjectTeamID;
    }
    if (newChat.subjectSportID) {
        subjectDic[@"subjectSportID"] = newChat.subjectSportID;
    }
    if (newChat.subjectFixtureID) {
        subjectDic[@"subjectFixtureID"] = newChat.subjectFixtureID;
    }
    if (newChat.subjectImageID) {
        subjectDic[@"subjectImageID"] = newChat.subjectTeamID;
    }
    
    subjectDic[@"subjectImageAvailable"] = newChat.subjectImageAvailable;
    
    if (newChat.subjectImageLastUpdateDate) {
        subjectDic[@"subjectImageLastUpdateDate"] = newChat.subjectImageLastUpdateDate;
    }
    
    chat.subject = [subjectDic copy];
    
    // Fetch contacts
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"CDContact" inManagedObjectContext:managedContext];
    NSFetchRequest *contactRequest = [NSFetchRequest new];
    [contactRequest setEntity:contactsEntity];
    [contactRequest setPredicate:[NSPredicate predicateWithFormat:@"appContactId IN %@", newChat.chatMemberContactId]];
    NSArray *fetchedContacts = [managedContext executeFetchRequest:contactRequest error:&error];
    assert(error == nil);
    
    if (!error) {
        [chat removeChatWithContacts:chat.chatWithContacts];
        [chat addChatWithContacts:[NSSet setWithArray:fetchedContacts]];
        
        [managedContext save:&error];
        if (!error) {
            success(@"success");
            return;
        }
    }
    failure(error.localizedDescription);
}

- (void)deleteChatMessage:(NSString *)chatId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDChat" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"chatId == %@", chatId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDChat *chat = results[0];
    
    for (CDChatMessage *message in chat.messages) {
        message.messageDeliveryStatus = @"DELETED";
    }
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

- (void)exitChat:(NSString *)chatId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSManagedObjectContext *managedContext = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDChat" inManagedObjectContext:managedContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"chatId == %@", chatId]];
    
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    assert(error == nil);
    assert(results.count > 0);
    
    CDChat *chat = results[0];
    
    chat.exitedChat = @"true";
    
    [managedContext save:&error];
    if (!error) {
        success(@"success");
        return;
    }
    
    failure(error.localizedDescription);
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

@end
