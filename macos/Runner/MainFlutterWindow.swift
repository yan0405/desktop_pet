// import Cocoa
// import FlutterMacOS

// class MainFlutterWindow: NSWindow {
//   override func awakeFromNib() {
//     let flutterViewController = FlutterViewController()
//     let windowFrame = self.frame
//     self.contentViewController = flutterViewController
//     self.setFrame(windowFrame, display: true)
//     self.styleMask = [.fullSizeContentView, .borderless]
//     self.isMovableByWindowBackground = true
    
//     self.backgroundColor = NSColor.clear // 设置背景色为透明
//     self.isOpaque = false // 确保窗口不不透明
//     RegisterGeneratedPlugins(registry: flutterViewController)

//     super.awakeFromNib()
//   }
// }

import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.styleMask = [.fullSizeContentView, .borderless]
    // 以下代码是关键来设置窗口背景透明
    // self.backgroundColor = NSColor.clear
    flutterViewController.backgroundColor = NSColor.clear
    
    self.isOpaque = false

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
