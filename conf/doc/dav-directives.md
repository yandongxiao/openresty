# **dav\_access**

指定创建的文件的访问权限，分为User，Group，Other三部分；

# dav\_method

1. nginx默认是不支持PUT、POST等方法；

2. 使用DAV模块以后，还需要使用该指令，指定DAV模块可以处理的指令集；

3. 注意上传的原理：1. 上传的文件先暂存在临时文件内（也许是为了让其它模块使用，反正HTTP-Core-Module的client\_body\_temp\_path是这么规定的）；2. DAV模块rename该临时文件到相应的位置；所以要求临时存放目录和最终文件存放位置在同一个文件系统下；3. 由root或alias指定文件存放的位置，注意worker需要有创建文件或目录的权限。

4. 使用Date指定文件的修改时间；


# **create\_full\_put\_path**

相当于mkdir -p 的功能

# **min\_delete\_depth**

比如只需要用户删除N级目录下的内容

