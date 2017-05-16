import PackageDescription

let package = Package(
    name: "MMFileServer",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 32),
        //.Package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", versions: Version(0,0,0)..<Version(10,0,0)),
        .Package(url: "https://github.com/zhangyuhan0407/OCTJSON", versions: Version(0,0,0)..<Version(10,0,0)),
        .Package(url: "https://github.com/zhangyuhan0407/OCTFoundation.git", versions: Version(0,0,0)..<Version(10,0,0))
    ]
)
