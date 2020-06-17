### NIOURLNavigator

```ruby
NIOURLNavigator.registerURLObject(withPlists: ["NIOURLNavigator.plist"])
```
#### NIOURLNavigator.plist
```ruby
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>URLs</key>
	<array>
		<dict>
			<key>className</key>
			<string>URLSample.TViewController</string>
			<key>url</key>
			<string>nio://tv</string>
			<key>navigationMode</key>
			<string>1</string>
		</dict>
		<dict>
			<key>url</key>
			<string>URLSample.TViewController</string>
			<key>className</key>
			<string>nio://tv</string>
			<key>navigationMode</key>
			<integer>2</integer>
		</dict>
	</array>
</dict>
</plist>

```
