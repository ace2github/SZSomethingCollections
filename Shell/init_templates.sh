#! /bin/bash

rm -fr "./SZSomethingCollections"
git clone https://github.com/ace2github/SZSomethingCollections.git

# 变量名和等号之间不能有空格
target_sys_template_path=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates
echo ${target_sys_template_path}

src_path=`pwd`
echo ${src_path}

rm -fr ${target_sys_template_path}/File Templates/SZFiles
cp -r ${src_path}/SZSomethingCollections/Templates/File Templates/SZFiles ${xcode_user_def_path}


rm -fr "./SZSomethingCollections"
echo "Complete!"


