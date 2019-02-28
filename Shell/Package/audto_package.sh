#!/bin/sh

################################################################
# 打包类型：app-store, ad-hoc, enterprise, development
ARVHIVE_TYPE_APPSTORE=app-store
ARVHIVE_TYPE_ADHOC=ad-hoc
ARVHIVE_TYPE_ENTERPRISE=enterprise
ARVHIVE_TYPE_DEVELOPMENT=development


################################################################
# 打包需要手动配置项 
#

# 工程根目录
project_path=

# 工程名称
workspace_name=
project_name=


# app的bundle id
app_bundle_id=

# 工程info.plist文件
project_info_plist=$project_path/$project_name/Info.plist

# 打包类型
archive_type=${ARVHIVE_TYPE_ADHOC}

################################################################
# 处理info.plist
#
echo ">校验工程info.plist文件是否存在..."
if [[ ! -e $project_info_plist ]]; then
	echo "info.plist文件 不存在"
	exit 1
fi
app_version=`/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" "${project_info_plist}"`
echo $app_version

app_bundle_displayname=`/usr/libexec/PlistBuddy -c "print :CFBundleDisplayName" "${project_info_plist}"`
echo $app_bundle_displayname



################################################################
# 打包初始化
# 1、创建编译打包目录
#

# 当前目录
auto_sh_path=`PWD`

# 编译文件设置
curr_date=`date "+%Y-%m-%d"`
curr_time=`date "+%H%m"`

# config目录
archive_config_path=./config

# 编译目录
archive_build_path=./build

# 创建编译文件目录
curr_build_path="$archive_build_path/$curr_date/$curr_time"
echo $curr_build_path
mkdir -p $curr_build_path



################################################################
# 处理打包证书文件
#

# 校验打包Profile文件是否存在
echo ">校验打包Profile文件是否存在..."
profile_path=$archive_config_path/$archive_type-profile.mobileprovision
if [[ ! -e $profile_path ]]; then
	echo "打包文件：$profile_path ，不存在"
	exit -1
fi


# 将.mobileprovision 转为 .plist
profile_plist_path=$archive_config_path/$archive_type-profile.plist
/usr/bin/security cms -D -i "${profile_path}" > "${profile_plist_path}"


# 获取uuid
provisioning_profile_uuid=`/usr/libexec/PlistBuddy -c "Print :UUID" "${profile_plist_path}"`
echo ${provisioning_profile_uuid}

# 获取打包文件名称
provisioning_profile_specifier=`/usr/libexec/PlistBuddy -c "Print :Name" "${profile_plist_path}"`
echo ${provisioning_profile_specifier}


# 包导出export的plist文件
echo "> export.plist 文件配置"
export_options_plist_path=$archive_config_path/$archive_type-exportoptions.plist
cp $archive_config_path/export_options.plist $export_options_plist_path

# 配置导出plist文件
echo "> export.plist clear"
/usr/libexec/PlistBuddy -c "Clear" "${export_options_plist_path}"

# 是否支持bitcode，appstore的包需要开启，其他不开启
compile_bitcode_flag=NO
if [[ "$archive_type" = "$ARVHIVE_TYPE_APPSTORE" ]]; then
	echo '打app store的线上包'
	compile_bitcode_flag=YES
fi
/usr/libexec/PlistBuddy -c "Add :compileBitcode bool ${compile_bitcode_flag}" "${export_options_plist_path}"
/usr/libexec/PlistBuddy -c "Add :method string ${archive_type}" "${export_options_plist_path}"
/usr/libexec/PlistBuddy -c "Add :provisioningProfiles:${app_bundle_id} string ${provisioning_profile_uuid}" "${export_options_plist_path}"



################################################################
# 编译打包开始
echo ">开始打包..."
archive_target_name="${project_name}-${archive_type}"
echo ${archive_target_name}


# 编译并且生成archive包
echo '\n开始编译...'
resultcode=`xcodebuild -workspace $project_path/$workspace_name.xcworkspace -scheme $project_name -configuration Release -archivePath $curr_build_path/$archive_target_name.xcarchive archive build PRODUCT_BUNDLE_IDENTIFIER="${app_bundle_id}" PROVISIONING_PROFILE_SPECIFIER="${provisioning_profile_specifier}"  > $curr_build_path/archive_log.txt`
if [[ $resultcode -ne 0 ]]; then
	echo "编译失败"
	exit -1
fi

# 导出ipa包
echo '\n开始导出ipa包...'
xcodebuild  -exportArchive -archivePath $curr_build_path/$archive_target_name.xcarchive -exportOptionsPlist ${export_options_plist_path} -exportPath $curr_build_path/$archive_target_name.ipa  > $curr_build_path/archive_export.txt
if [[ $resultcode -ne 0 ]]; then
	echo "导出ipa包失败"
	exit -1
fi

echo 'finish'

#######################

# 初始化构建目录
# build_path=`PWD`/build
# if [ ! -d $build_path  ];then
#   mkdir $build_path
# fi

# product_path=`PWD`/product
# if [[ ! -d $product_path ]]; then
#     mkdir $product_path
# fi
# xcodebuild -workspace ztjyyd.xcworkspace -scheme ztjyyd -configuration Build -arch arm64 -derivedDataPath $build_path PRODUCT_BUNDLE_IDENTIFIER=com.szy.seebabyyd.test PRODUCT_NAME="掌通家园园丁" PROVISIONING_PROFILE_SPECIFIER=adHoc_com.szy.seebabyyd.test >> log.txt

# 将app->ipa
# xcrun -sdk iphoneos PackageApplication -v $build_path/Build/Products/Release-iphoneos/掌通家园园丁.app -o $product_path/ztjyyd.ipa
