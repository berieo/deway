### 此目录下存放了转化模型需要的脚本
|文件             |用途       |备注      |
|---             |---        |---      |
|ckpt_to_pb.py   |ckpt转pb模型|需要知道ckpt输出节点，需要更改输出节点名称、输入文件路径、输出文件路径|
|get_ckpt_name.py|获取ckpt所有节点名称|需要更改输入文件路径|
|get_pb_name.py  |获取pb模型输入、输出节点名称|需要更改输入文件路径|
|getallname.py   |获取pb模型所有节点名称   |需要更改输入文件路径|
|h5_to_pb.py     |h5模型转换为pb模型 |需要更改输入输出路径 |
|pb模型转IR模型    |pb模型转ir模型命令|在终端执行，需要输入pb模型的size|
|pb模型转lite模型  |pb模型转lite模型命令|如果不知道size可以直接运行，运行后会返回一个size，用这个size再运行一次。pb转ir模型时，pb模型size不知道的时候可以用这个命令去获得size。|
<br/>
<br/>

> #### 1. 转化lite模型前需要安装tensorflow lite，转化ir模型前需要安装openvino。  
> #### 2. 转化ir、lite模型的思路为，先将h5、ckpt、keras模型转为pb模型，然后将pb模型转为lite、ir模型。  
> #### 3. 也可以使用bazel编译生成lite模型，但是bazel官方库很混乱，会有一些Bug。  
> #### 4. ckpt输出节点一般命名为output_1，如果所有节点名称中没有明显的输出节点的名称，需要在代码中查找，如果代码中没有可以重新训练模型生成Pb。  
> #### 5. pb转化为lite模型很方便，成功率很高。
