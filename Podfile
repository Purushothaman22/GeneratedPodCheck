platform :ios, '11.0'


target 'Auth' do
    use_frameworks! :linkage => :static 
    pod 'Sedwig', :git => 'git@github.com:surya-soft/Sedwig.git'
    pod 'LeoSwiftRuntime', :git => 'git@github.com:surya-soft/LeoSwiftRuntime.git'
end

target 'Otp' do
    use_frameworks! :linkage => :static 
    pod 'Sedwig', :git => 'git@github.com:surya-soft/Sedwig.git'
    pod 'LeoSwiftRuntime', :git => 'git@github.com:surya-soft/LeoSwiftRuntime.git'
end

target 'Sms' do
    use_frameworks! :linkage => :static 
    pod 'Sedwig', :git => 'git@github.com:surya-soft/Sedwig.git'
    pod 'LeoSwiftRuntime', :git => 'git@github.com:surya-soft/LeoSwiftRuntime.git'
end

target 'Types' do
    use_frameworks! :linkage => :static 
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
