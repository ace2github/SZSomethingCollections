#! /bin/bash

rm -fr "./SZSomethingCollections"
git clone https://github.com/ace2github/SZSomethingCollections.git

# 变量名和等号之间不能有空格
target_sys_template_path=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates
echo ${target_sys_template_path}

new_user_template_path=`pwd`/SZSomethingCollections/Templates
echo ${new_user_template_path}


install() {
	target_path=$2
	sourth_path=$1
	echo copy "${sourth_path}" to "${target_path}"

	sudo rm -fr "${target_path}"
	sudo mkdir "${target_path}"

	sudo cp -fr "${sourth_path}"/* "${target_path}"
}

echo 拷贝文件模板
install "${new_user_template_path}"/File\ Templates/SZFiles "${target_sys_template_path}"/File\ Templates/SZFiles

echo 拷贝工程模板
install "${new_user_template_path}"/Project\ Templates/iOS/SZProject "${target_sys_template_path}"/Project\ Templates/iOS/SZProject

rm -fr "./SZSomethingCollections"
echo "Complete!"


