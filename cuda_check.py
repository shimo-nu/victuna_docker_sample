import torch
from rich import print

def print_device_info():
    gpu_count = torch.cuda.device_count()
    print(f"Available GPUs: {gpu_count}")
    
    if gpu_count > 0:
        for i in range(gpu_count):
            print(f"GPU {i}: {torch.cuda.get_device_name(i)}")
            print(f"  - Total Memory: {torch.cuda.get_device_properties(i).total_memory / (1024 ** 3):.2f} GB")
            print(f"  - CUDA Capability: {torch.cuda.get_device_properties(i).major}.{torch.cuda.get_device_properties(i).minor}")
            print(f"  - Current Device ID: {torch.cuda.current_device()}")
    
    print(f"Default Device: {'cuda' if torch.cuda.is_available() else 'cpu'}")
    
    print("Available Devices:")
    print("- CPU: Yes")
    if torch.cuda.is_available():
        print("- GPU: Yes")
    else:
        print("- GPU: No")

if __name__ == "__main__":
    print_device_info()

