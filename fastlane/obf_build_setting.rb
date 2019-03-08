#!/usr/bin/env ruby

#此脚本用来动态修改工程配置，支持代码混淆，需要配合支持代码混淆的toolchain使用， 只针对Release模式
#具体实现参照https://naville.gitbooks.io/hikaricn/content/Usage.html
#目前只兼容xcode9及以下

require 'xcodeproj'
project_path = '../SmartHome.xcodeproj'
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
   if target.name == "SmartHome" 
      target.build_configurations.each do |config| 
           if config.name == "Release"
                config.build_settings['OTHER_CFLAGS'] << '-mllvm -enable-cffobf -mllvm -enable-splitobf -mllvm -enable-subobf -mllvm -enable-acdobf -O0'
                config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
                config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
           end
      end
   end
end

project.save
