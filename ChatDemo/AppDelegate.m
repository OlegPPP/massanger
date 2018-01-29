//
//  AppDelegate.m
//  ChatDemo
//
//  Created by Neo on 5/15/17.
//  Copyright © 2017 Neo. All rights reserved.
//

#import "AppDelegate.h"
#import <GooglePlaces/GooglePlaces.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Customize global appearance
    UIColor *tintColor = [UIColor colorWithRed:1.f/255 green:139.f/255 blue:193.f/255 alpha:1];
    [UINavigationBar.appearance setTranslucent:NO];
    [UINavigationBar.appearance setTintColor:UIColor.whiteColor];
    [UINavigationBar.appearance setBarTintColor:tintColor];
    [UINavigationBar.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightLight]}];
    [UIBarButtonItem.appearance setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22], NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [UIBarButtonItem.appearance setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22], NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3]} forState:UIControlStateDisabled];
    [UIBarButtonItem.appearance setTintColor:[UIColor whiteColor]];
    
//    [UISwitch.appearance setTintColor:tintColor];
    [UISwitch.appearance setOnTintColor:tintColor];
    
    // Set google places api key
    [GMSPlacesClient provideAPIKey:@"AIzaSyAWDdEQV_01v_Ixhgmls1pHz7GX9GPrUZM"];
    
    // Customize search bar in Google Auto complete VC
    UIColor *_searchBarTintColor = [UIColor whiteColor];
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[GMSAutocompleteViewController class]]]
     setTintColor:_searchBarTintColor];
    
    // Color of typed text in search bar.
    NSDictionary *searchBarTextAttributes = @{
                                              NSForegroundColorAttributeName : _searchBarTintColor,
                                              NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                              };
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[GMSAutocompleteViewController class]]]
     setDefaultTextAttributes:searchBarTextAttributes];
    
    // Color of the "Search" placeholder text in search bar. For this example, we'll make it the same
    // as the bar tint color but with added transparency.
    CGFloat increasedAlpha = CGColorGetAlpha(_searchBarTintColor.CGColor) * 0.75f;
    UIColor *placeHolderColor = [_searchBarTintColor colorWithAlphaComponent:increasedAlpha];
    
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName : placeHolderColor,
                                            NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                            };
    NSAttributedString *attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Search" attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[GMSAutocompleteViewController class]]]
     setAttributedPlaceholder:attributedPlaceholder];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ChatDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
