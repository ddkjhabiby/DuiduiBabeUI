.
d::Spec.new do |s|
    s.name         = "DuiduiBabeUI"
    s.version      = "1.0.0"
    s.swift_version='4.0'
    s.ios.deployment_target = '10.0'
    s.summary      = "Util Framework"
    s.homepage     = "https://github.com/ddkjhabiby/DuiduiBabeUI.git"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Simple" => "habttt@163.com" }
    s.source       = { :git => "https://github.com/ddkjhabiby/DuiduiBabeUI.git", :tag =>
 s.version }
    #s.source_files  = "DuiduiBabeUI/*"
    s.frameworks = 'Foundation', 'UIKit'
    s.requires_arc = true
    s.dependency 'RxSwift','~> 5.1.0'
    s.dependency 'RxCocoa','~> 5.1.0'
    s.dependency 'HandyJSON','~> 5.0.2-beta'
    s.dependency 'MMKV','~> 1.2.2'
    s.dependency 'KeychainSwift','~> 16.0'
    s.dependency 'DeviceKit','~> 3.2.0'
    s.dependency 'CryptoSwift','~>1.0.0'
    s.dependency 'Moya','~> 13.0'
    s.dependency 'SwiftyUtils','~>5.2.0'
end   
