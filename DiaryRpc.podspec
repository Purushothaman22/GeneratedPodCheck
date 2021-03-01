Pod::Spec.new do |s|
  s.name = 'DiaryRpc'
  s.version = '0.1.0'
  s.summary = 'DiaryRpc contains generated code for RPC.'
  s.homepage = 'https://github.com/Purushothaman22/GeneratedPodCheck'
  s.authors = {
    'Purushothaman' => 'purushothaman.b@surya-soft.com'
  }
  s.source = { :git => 'https://github.com/Purushothaman22/GeneratedPodCheck.git' }
  s.source_files = '*.swift'
  s.ios.deployment_target = '11.0'

  s.swift_versions = ['5.0', '5.1', '5.2']
end
