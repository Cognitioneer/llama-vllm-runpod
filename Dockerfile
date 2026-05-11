# Start from the official vLLM image — it already has CUDA, PyTorch, and vLLM
# pre-installed and compiled. Saves us 20+ minutes of build time.
FROM vllm/vllm-openai:v0.6.3.post1

# Tell HuggingFace to cache models in /workspace (where RunPod mounts the volume).
# This means weights download ONCE, then live on the volume forever.
ENV HF_HOME=/workspace/hf_cache \
    HUGGINGFACE_HUB_CACHE=/workspace/hf_cache \
    TRANSFORMERS_CACHE=/workspace/hf_cache

# Default settings — you can override any of these in the RunPod UI without rebuilding.
ENV MODEL_NAME=meta-llama/Llama-3.1-8B-Instruct \
    MAX_MODEL_LEN=8192 \
    GPU_MEMORY_UTILIZATION=0.90 \
    PORT=8000

# The port vLLM's API server listens on.
EXPOSE 8000

# Copy our startup script into the image and make it executable.
COPY start.sh /start.sh
RUN chmod +x /start.sh

# When the container starts, run our script.
ENTRYPOINT ["/start.sh"]
