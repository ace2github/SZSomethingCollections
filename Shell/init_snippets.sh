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

:<<EOF
f_sum_int() {
	echo $@
	sum=0
	for var in $@; do
		echo ${var}
		sum+=${var}
	done
	
	return sum
}

f_sum_int 1, 2, 3
echo "输入的两个数字之和为 $? !"
EOF