#!/bin/bash
set -e

echo "==> Starting vLLM with model: ${MODEL_NAME}"

# Warn if HF_TOKEN isn't set — Llama models are gated and need authentication
if [ -z "${HF_TOKEN}" ]; then
  echo "WARNING: HF_TOKEN not set. Gated models like Llama will fail to download."
  echo "Set HF_TOKEN as an environment variable when launching the RunPod pod."
fi

# Launch vLLM's OpenAI-compatible API server
exec python3 -m vllm.entrypoints.openai.api_server \
  --model "${MODEL_NAME}" \
  --max-model-len "${MAX_MODEL_LEN}" \
  --gpu-memory-utilization "${GPU_MEMORY_UTILIZATION}" \
  --host 0.0.0.0 \
  --port "${PORT}" \
  --download-dir /workspace/hf_cache \
  --dtype auto \
  --enforce-eager \
  --disable-log-requests
