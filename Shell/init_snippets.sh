#! /bin/bash

rm -fr "./SZSomethingCollections"
git clone https://github.com/ace2github/SZSomethingCollections.git

# 变量名和等号之间不能有空格
xcode_user_def_path=~/Library/Developer/Xcode/UserData/CodeSnippets
echo ${xcode_user_def_path}

src_path=`pwd`
echo ${src_path}

rm -f ${xcode_user_def_path}/sz_*
cp ${src_path}/SZSomethingCollections/CodeSnippets/* ${xcode_user_def_path}


rm -fr "./SZSomethingCollections"
echo "Complete!"
