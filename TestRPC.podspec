Pod::Spec.new do |s|
  s.name = 'TestRPC'
  s.version = '0.1.0'
  s.authors = {
    'Surya Software Systems Pvt. Ltd.' => 'noreply@surya-soft.com'
  }
  s.source_files = '*/*.swift'
  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0', '5.1', '5.2']
end
