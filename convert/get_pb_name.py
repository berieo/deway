import tensorflow as tf
gf = tf.GraphDef()   
m_file = open('inception_v1.pb','rb')
gf.ParseFromString(m_file.read())

with open('somefile.txt', 'a') as the_file:
    for n in gf.node:
        the_file.write(n.name+'\n')

file = open('somefile.txt','r')
data = file.readlines()
print("output name = ")
print(data[len(data)-1])

print("Input name = ")
file.seek ( 0 )
print(file.readline())

# def get_all_layernames():
#     """get all layers name"""
#     model_dir  = os.path.join(ROOT_DIR, '/')
#     pb_file_path = os.path.join(ROOT_DIR, 'crnn_ctc.pb')

#     from tensorflow.python.platform import gfile

#     sess = tf.Session()
#     # with gfile.FastGFile(pb_file_path + 'model.pb', 'rb') as f:
#     with gfile.FastGFile(pb_file_path, 'rb') as f:
#         graph_def = tf.GraphDef()
#         graph_def.ParseFromString(f.read())
#         sess.graph.as_default()
#         tf.import_graph_def(graph_def, name='')

#         tensor_name_list = [tensor.name for tensor in tf.get_default_graph().as_graph_def().node]
#         for tensor_name in tensor_name_list:
#             print(tensor_name, '\n')
#     return