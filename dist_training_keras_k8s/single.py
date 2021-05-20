# Derived from https://www.google.com/url?q=https://www.tensorflow.org/tutorials/distribute/multi_worker_with_keras&sa=D&source=editors&ust=1621472957315000&usg=AOvVaw2sPQb9rPMX0cH4wTCYUvH2
# Retrieved at May 17 2021

import mnist

batch_size = 64
single_worker_dataset = mnist.mnist_dataset(batch_size)
single_worker_model = mnist.build_and_compile_cnn_model()
single_worker_model.fit(single_worker_dataset, epochs=3, steps_per_epoch=70)
