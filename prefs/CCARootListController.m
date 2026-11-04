#import "CCARootListController.h"
#import <Preferences/PSSpecifier.h>
#import <spawn.h>
#import <unistd.h>

extern char **environ;

@interface CCARootListController ()
@property (nonatomic, assign) BOOL initialEnabledValue;
@end

@implementation CCARootListController

- (NSArray *)specifiers {
    if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (PSSpecifier *specifier in self.specifiers) {
        if ([[specifier propertyForKey:@"key"] isEqualToString:@"Enabled"]) {
            self.initialEnabledValue = [[self readPreferenceValue:specifier] boolValue];
            break;
        }
    }
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)setMasterEnabled:(id)value specifier:(PSSpecifier *)specifier {
    [self setPreferenceValue:value specifier:specifier];
    BOOL needsRespring = [value boolValue] != self.initialEnabledValue;
    if (!needsRespring) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    if (self.navigationItem.rightBarButtonItem) return;

    UIImage *image = [UIImage systemImageNamed:@"arrow.clockwise"];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:image
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(respring)];
    button.accessibilityLabel = @"Respring";
    self.navigationItem.rightBarButtonItem = button;
}

- (void)respring {
    // Rootful iOS 14: prefer sbreload, fall back to killing SpringBoard.
    pid_t pid = 0;
    if (access("/usr/bin/sbreload", X_OK) == 0) {
        const char *arguments[] = { "/usr/bin/sbreload", NULL };
        posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char *const *)arguments, environ);
    } else {
        const char *arguments[] = { "/usr/bin/killall", "-9", "SpringBoard", NULL };
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)arguments, environ);
    }
}

@end
