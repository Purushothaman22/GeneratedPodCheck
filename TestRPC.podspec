Pod::Spec.new do |s|
  s.name = 'TestRPC'
  s.version = '0.1.0'
  s.summary = 'TestRPC contains Swift RPC code generated by rpcgen.'
  s.homepage = 'https://github.com/Purushothaman22/GeneratedPodCheck'
  s.authors = {
    'Surya Software Systems Pvt. Ltd.' => 'noreply@surya-soft.com'
  }
  s.source = { :git => 'https://github.com/Purushothaman22/GeneratedPodCheck.git' }
  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0', '5.1', '5.2']
  s.dependency 'libPhoneNumber-iOS'
  s.dependency 'Sedwig'
  s.dependency 'LeoSwiftRuntime'

  s.subspec 'Auth' do |sp|
    sp.source_files = 'Auth/**/*.swift'
  end
  s.subspec 'Otp' do |sp|
    sp.source_files = 'Otp/**/*.swift'
    sp.dependency 'TestRPC/Types'
  end
  s.subspec 'Sms' do |sp|
    sp.source_files = 'Sms/**/*.swift'
    sp.dependency 'TestRPC/Types'
  end
  s.subspec 'Types' do |sp|
    sp.source_files = 'Types/**/*.swift'
  end
end
