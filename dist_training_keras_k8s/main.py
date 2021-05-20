# Derived from https://www.google.com/url?q=https://www.tensorflow.org/tutorials/distribute/multi_worker_with_keras&sa=D&source=editors&ust=1621472957315000&usg=AOvVaw2sPQb9rPMX0cH4wTCYUvH2
# Retrieved at May 17 2021

import os
import json

import tensorflow as tf
import mnist
import os

per_worker_batch_size = 64
tf_config = json.loads(os.environ['TF_CONFIG'])
num_workers = len(tf_config['cluster']['worker'])
num_epochs = int(os.getenv('epochs', 1))

strategy = tf.distribute.MultiWorkerMirroredStrategy()

global_batch_size = per_worker_batch_size * num_workers
multi_worker_dataset = mnist.mnist_dataset(global_batch_size)

with strategy.scope():
  # Model building/compiling need to be within `strategy.scope()`.
  multi_worker_model = mnist.build_and_compile_cnn_model()

multi_worker_model.fit(multi_worker_dataset, epochs=num_epochs, steps_per_epoch=70)
