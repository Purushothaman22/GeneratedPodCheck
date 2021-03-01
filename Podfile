platform :ios, '11.0'


target 'Assets' do
    pod 'libPhoneNumber-iOS', :modular_headers => true
    pod 'Sedwig', :git => 'git@github.com:surya-soft/Sedwig.git'
    pod 'LeoSwiftRuntime', :git => 'git@github.com:surya-soft/LeoSwiftRuntime.git'
end

target 'HomeScreen' do
    pod 'libPhoneNumber-iOS', :modular_headers => true
    pod 'Sedwig', :git => 'git@github.com:surya-soft/Sedwig.git'
    pod 'LeoSwiftRuntime', :git => 'git@github.com:surya-soft/LeoSwiftRuntime.git'
end


post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
