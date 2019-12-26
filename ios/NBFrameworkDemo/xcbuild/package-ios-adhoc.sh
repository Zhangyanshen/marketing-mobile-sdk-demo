# clean
xcodebuild clean -xcodeproj ./NBFrameworkDemo.xcodeproj -configuration Release -alltargets
# build & archive
xcodebuild archive -project ./NBFrameworkDemo.xcodeproj -scheme NBFrameworkDemo -configuration Release -archivePath ./xcbuild/archive/NBFrameworkDemo-adhoc.xcarchive
# exportArchive
xcodebuild -exportArchive -archivePath ./xcbuild/archive/NBFrameworkDemo-adhoc.xcarchive -exportOptionsPlist ./xcbuild/AdHocExportOptions.plist -exportPath ./xcbuild/ipa/NBFrameworkDemo-adhoc

