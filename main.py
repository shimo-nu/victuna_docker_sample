import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

# トークナイザーとモデルの準備
tokenizer = AutoTokenizer.from_pretrained(
    "lmsys/vicuna-7b-v1.5",
    use_fast=False,
)
model = AutoModelForCausalLM.from_pretrained(
    "lmsys/vicuna-7b-v1.5",
    load_in_8bit=True,
    torch_dtype=torch.float16,
    device_map="auto",
)

print("Model Loaded")

while True:
  prompt = str(input("Prompt : "))
  if (prompt == 'end'):
    break

  print(f"prompt is {prompt}")
  # 推論の実行
  token_ids = tokenizer.encode(prompt, add_special_tokens=False, return_tensors="pt")
  with torch.no_grad():
      output_ids = model.generate(
          token_ids.to(model.device),
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
