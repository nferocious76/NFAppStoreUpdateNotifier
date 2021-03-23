Pod::Spec.new do |s|
  s.name             = 'NFAppStoreUpdateNotifier'
  s.version          = '0.1.0'
  s.swift_version    = '5.0'
  s.summary          = '`NFAppStoreUpdateNotifier` was made to handle the App`s force update checking and redirection to the App`s AppStore page.'

  s.description      = <<-DESC
`NFAppStoreUpdateNotifier` is a light weight wrapper that handles fetch, parsing, comparison and validation of `Local or Installed` App version to its AppStore or most updated Live Version. If live updates are present, you can easily redirect users to the AppStore page and made them update your local app before they can use it again.
                       DESC

  s.homepage         = 'https://github.com/nferocious76/NFAppStoreUpdateNotifier'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Neil Francis Ramirez Hipona' => 'nferocious76@gmail.com' }
  s.source           = { :git => 'https://github.com/nferocious76/NFAppStoreUpdateNotifier.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/nferocious76'

  s.ios.deployment_target = '13.0'

  s.source_files = 'NFAppStoreUpdateNotifier/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NFAppStoreUpdateNotifier' => ['NFAppStoreUpdateNotifier/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'Alamofire', '~> 5.2'
end
