import tensorflow as tf


path="ckpt_to_pb_model.pb"        #pb文件位置和文件名
inputs=["inputs"]               #模型文件的输入节点名称
classes=["classes"]            #模型文件的输出节点名称
converter = tf.contrib.lite.TocoConverter.from_frozen_graph(path, inputs, classes)
tflite_model=converter.convert()
open("/home/zhang/anaconda3/model_pb.tflite", "wb").write(tflite_model)
