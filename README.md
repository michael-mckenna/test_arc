# ARC Decision Tool - iOS

This project is the iOS app for an American Red Cross division director to input information related to a hurricane event in order to keep track of tasks involved in the response. These tasks are retrieved from the 120 Hours Hurricane Timeline1. The tasks2 are organized according to time remaining and priority. There will be two priorities; high priority tasks involving personal safety of people and normal priority. The application periodically notifies the user of remaining incomplete tasks.

## Requirements
1. Xcode 9.2
2. iOS 10+

## How To Build The App

#### Pull the repo
Clone the master branch from the repo from github found at https://github.com/mckemike12/arc-decision-tool-ios. 

#### Ensure Homebrew and Carthage are installed
* If you don't have Homebrew installed go [here](https://brew.sh)
* Once Homebrew is installed, run `brew install carthage` to install carthage.

#### Run Carthage
1. `cd` into the directory with the `Cartfile` and type `carthage update --platform ios`
2. Wait 5-10mins for this to complete. You will only have to ever run this once on your machine, even after switching branches assuming no new dependencies have been added.
3. You can now open outfield-swift.xcodeproj (note - we are no longer using .xcworkspace)

#### Set Up Build Settings
1. Go to arc-decision-tool in TARGETS
2. Select "All" in the tool bar that is directly left of the search bar.
3. Type "Other Swift Flags" and add `-D DEBUG -Xfrontend -warn-long-function-bodies=200 -Xfrontend -warn-long-expression-type-checking=200`. This will make a warning if function signatures or expressions take more than 200ms to compile. Do this ONLY for Debug, NOT release. If you do it for Release as well, you get to answer customer complaints for a month.
4. Now go to Editor -> Add Build Setting -> Add User-Defined Setting. Use `SWIFT_WHOLE_MODULE_OPTIMIZATION` for the key and `YES` for the value.
5. Now back in the search bar in build settings, type `Swift Compiler - Code Generation` and in `Optimization Level` choose `None` for debug. The proper workflow for WMO is setting this to none and setting the User-Defined setting to YES.
6. Type `Architectures` and ensure that `Build Active Architecture Only` is set to `Yes` for Debug and `No` for Release.
7. Make sure the C Language Dialect is set to `Compiler Default` for `Apple LLVM 9.0 - Language` and `Apple LLVM 9.0 - Language - C++`

#### Build the app
The app should build and run after pressing the 'run' button on the top left of Xcode, or by pressing CMD+R.

## Development Workflow

* The `master` branch at any time represents a stable (and tested) version of the code base.
* All development work should be performed in feature branches. In most cases, feature branches will be branched off of the `master` branch. Naming of the feature branches is up to the developer. Using your initials is helpful so we know who is working where, but not crucial. (Ex: `dd-feature_name`)
* Rebase off of `master` often, and especially before submitting a pull request to make sure your feature branch has the latest hotness.
* When a feature branch is ready for master, submit a pull request detailing the changes made, any dependency updates, screenshots of updates if needed, and any other information to help with the merge.
* The repo admin will be responsible for merging all pull requests, enforcing coding standards and generally keeping `master` stable and clean. In most cases the repo admin will be responsible for upgrading dependencies as well.

## Code Style

* We follow the MVC development pattern (Model-View-Controller). Ensure at all times that logic for UIViews is in its corresponding class, with exceptions such as UIButtons where the logic will be in the UIButton extension under Extensions.swift
* Always add comments so that devs can easily follow the process flow for your code
* Organize relevant functions by adding marks, i.e. for outlets, add "// MARK: - Outlets" before all of the IBOutlets.
* Use guard statements and the nil coalescing operator, ??, as opposed to if let statements (when appropriate) to keep code looking concise. Examples can be found inside the project.
* Be conscientious of following the DRY (Don't Repeat Yourself) principle and consolidate logic into functions as seen fit.
* Be aware of existing helper methods in the Utils directory to prevent invalidating DRY and to save yourself time.

