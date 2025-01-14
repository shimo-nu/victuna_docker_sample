import torch

# 1. 利用可能なGPUの確認
if torch.cuda.is_available():
    print(f"利用可能なGPUの数: {torch.cuda.device_count()}")
    for i in range(torch.cuda.device_count()):
        print(f"  GPU {i}: {torch.cuda.get_device_name(i)}")
else:
    print("GPUが利用できません。CPUを使用します。")

# 2. デバイスを選択 (例: GPUが2つ以上あるなら、GPU0とGPU1を使い分ける)
device_0 = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
device_1 = torch.device("cuda:1") if torch.cuda.device_count() > 1 else device_0

# 3. サンプルのテンソル作成 (初期状態はCPU)
x = torch.randn(4, 4)
print("初期状態:", x.device)  # CPUかどうかを確認

# 4. GPU0 に移動
x = x.to(device_0)
print("GPU0に移動後:", x.device)

# 5. GPUが複数ある場合のみ、GPU1に移動
if torch.cuda.device_count() > 1:
    x = x.to(device_1)
    print("GPU1に移動後:", x.device)
else:
    print("GPUが1つしかないため、GPU1への移動ã¯スキップします。")

