from rich import print

import torch
from transformers import AutoTokenizer, AutoModelForCausalLM
from accelerate import init_empty_weights, infer_auto_device_map

tokenizer = AutoTokenizer.from_pretrained(
    "lmsys/vicuna-13b-v1.5",
    use_fast=False,
)

with init_empty_weights():
    model = AutoModelForCausalLM.from_pretrained(
        "lmsys/vicuna-13b-v1.5",
        torch_dtype=torch.float16,
    )
device_map = infer_auto_device_map(model, max_memory={"cuda:0": "30GB", "cuda:1": "30GB", "cuda:2": "30GB"}, no_split_module_classes=["OPTDecoderLayer"])
model = model.from_pretrained("lmsys/vicuna-13b-v1.5", device_map=device_map, torch_dtype=torch.float16)

print("Model Loaded")

while True:
    prompt = str(input("Prompt : "))
    if prompt == 'end':
        break

    print(f"Prompt is: {prompt}")
    token_ids = tokenizer.encode(prompt, add_special_tokens=False, return_tensors="pt").to("cuda:0")
    with torch.no_grad():
        output_ids = model.generate(
            token_ids,
            max_new_tokens=512,
            do_sample=True,
            temperature=1.0,
            top_p=0.85,
            pad_token_id=tokenizer.pad_token_id,
            bos_token_id=tokenizer.bos_token_id,
            eos_token_id=tokenizer.eos_token_id
        )
    output = tokenizer.decode(output_ids.tolist()[0][token_ids.size(1):])
    print(output)

