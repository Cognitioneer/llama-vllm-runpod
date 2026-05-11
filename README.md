# Llama + vLLM on RunPod

Run Llama 3.2 inference on RunPod with vLLM, using a Docker image built automatically by GitHub Actions and a network volume to cache model weights.

## What this does

- **GitHub Actions** builds a Docker image from this repo on every push (free)
- **ghcr.io** hosts the image (free)
- **RunPod network volume** stores model weights so they download only once
- **vLLM** serves the model with an OpenAI-compatible API

The result: GPU pods boot in ~20 seconds and you only pay for GPU time when you're actually using the model.

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Defines the image — based on official vLLM image |
| `start.sh` | Launches the vLLM server when the container starts |
| `.github/workflows/build.yml` | GitHub Actions config that auto-builds the image |

## Setup

1. Fork or clone this repo
2. Push any change to trigger the GitHub Actions build
3. Make the resulting package public on ghcr.io
4. Create a RunPod network volume
5. Launch a RunPod GPU pod using the image `ghcr.io/YOUR_USERNAME/llama-vllm:latest`
6. Mount the volume at `/workspace`, expose port `8000`, set `HF_TOKEN` env var

## Environment variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `MODEL_NAME` | `meta-llama/Llama-3.2-3B-Instruct` | Which model to load |
| `MAX_MODEL_LEN` | `8192` | Max context length |
| `GPU_MEMORY_UTILIZATION` | `0.90` | Fraction of GPU memory to use |
| `HF_TOKEN` | _(required)_ | HuggingFace token for gated models |

## Testing the endpoint

Once your pod is running, vLLM exposes an OpenAI-compatible API at port 8000:

```bash
curl https://YOUR-POD-ID-8000.proxy.runpod.net/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.2-3B-Instruct",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 50
  }'
```
