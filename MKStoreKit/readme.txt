The source code, MKStoreKit, contains four files. MKStoreManager.h/m and MKStoreObserver.h/m.
The StoreManager is a singleton class that takes care of *everything* Include StoreKit framework into your product
and drag these four files into the project. You then have to initialize it by calling [MKStoreManager sharedManager] 
in your applicationDidFinishLaunching. From then on, it does the magic. 
The MKStoreKit automatically activates/deactivates features based on your userDefaults.When a feature is purchased,
it automatically records it into NSUserDefaults.
For checking whether the user has purchased the feature, you can call a function like,

if([MKStoreManager featureAPurchased])
{
//unlock it
}

To purchase a feature, just call

[[MKStoreManager sharedManager] buyFeatureA];

It’s that simple with my storekit. As always, all my source code can be used without royalty into your app.
Just make sure that you don’t remove the copyright notice from the source code if you make your app open source.
You don’t have to attribute me in your app, although I would be glad if you do so 