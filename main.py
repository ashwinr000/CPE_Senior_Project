import keras
from keras import layers
import numpy as np
import h5py

# Test Case 1
model = keras.Sequential(
    [
        layers.Input(shape=(20,)),
        layers.Dense(10, name="layer1")
    ]
)

# Test Case 2
model = keras.Sequential(
    [
        layers.Input(shape=(30,)),
        layers.Dense(30, activation="relu", name="layer1"),
        layers.Dense(20, activation="relu", name="layer2"),
        layers.Dense(10, name="layer3")
    ]
)

model.build()
model.summary()

# Generate random weights and inputs (8-bit integer)
x = np.random.randint(2, size=(1, 30))

w1 = [np.random.randint(3, size=(30, 30)) - 1, np.random.randint(3, size=(30,)) - 1]
w2 = [np.random.randint(3, size=(30, 20)) - 1, np.random.randint(3, size=(20,)) - 1]
w3 = [np.random.randint(3, size=(20, 10)) - 1, np.random.randint(3, size=(10,)) - 1]

model.get_layer("layer1").set_weights(w1)
model.get_layer("layer2").set_weights(w2)
model.get_layer("layer3").set_weights(w3)

y = model(x)

model.save('model.h5')

fname = "model.h5"
w_fname = "params0.mem"
b_fname = "params1.mem"
wid_fname = "widths.mem"
dep_fname = "depths.mem"
in_fname = "input.mem"

def tohex(val, nbits):
    return hex((val + (1 << nbits)) % (1 << nbits))

def write_weight(f, w, sys_size):
    w_flat = w.flatten()
    for j in range(w.shape[0]):
        weights, w_flat = w_flat[:(w.shape[1])], w_flat[(w.shape[1]):]
        weights = np.pad(weights, (0, sys_size[0] - w.shape[1]))
        weights = [format(tohex(we, 8)[2:].zfill(2)) for we in weights]
        f.write('\n'.join(map(str, weights)) + '\n')
def write_bias(f, b, sys_size):
    b_flat = b.flatten()
    biases = [format(tohex(b, 8)[2:].zfill(2)) for b in b_flat]
    f.write('\n'.join(map(str, biases)) + '\n')

with h5py.File(fname, "r") as f:
    print("Keys: %s" % f.keys())
    a_group_key = list(f.keys())[0]
    data = list(f[a_group_key])

    num_layers = len(data) - 1
    sys_array_size = [0, 1]

    w_f = open(w_fname, "w+")
    b_f = open(b_fname, "w+")
    wid_f = open(wid_fname, "w+")
    dep_f = open(dep_fname, "w+")

    for i in range(len(data) - 1):
        layer = data[i]
        layer_bias = f[a_group_key][layer][layer]['bias:0'][()].astype(int)
        if len(layer_bias.shape) > 1:
            dep_f.write(format(tohex(layer_bias.shape[1], 32)[2:].zfill(8)) + '\n')
        else:
            dep_f.write(format(tohex(1, 32)[2:].zfill(8)) + '\n')
        sys_array_size[0] = max(layer_bias.shape[0], sys_array_size[0])


    for i in range(len(data) - 1):
        layer = data[i]
        layer_kernel = f[a_group_key][layer][layer]['kernel:0'][()].astype(int)

        wid_f.write(format(tohex(layer_kernel.shape[0], 32)[2:].zfill(8)) + '\n')
        write_weight(w_f, layer_kernel, sys_array_size)

        layer_bias = f[a_group_key][layer][layer]['bias:0'][()].astype(int)
        write_bias(b_f, layer_bias, sys_array_size)

in_f = open(in_fname, "w+")
write_bias(in_f, x, x.shape)
