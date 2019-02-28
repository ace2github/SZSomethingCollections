* 1、打开你的xcode，xcode打包相关配置好，如bundleid、版本号等。
* 2、拷贝Package到工程下面
* 3、在config里面存放打包证书，证书命名规则如下
${archive_type}-profile.mobileprovision
其中`${archive_type}`为app-store, ad-hoc, enterprise, development。即"ad-hoc-profile.mobileprovision"

* 4、打包脚本里面需要配置项目相关信息，见脚本的”打包需要手动配置项“