#!/bin/bash

if [[ -z "${MODEL_NAME}" ]]; then
  echo "MODEL_NAME is not optional. (124M, 355M, 774M, 1558M)"
  exit 1
fi

if [[ -z "${LENGTH}" ]]; then
  echo "LENGTH is not optional"
  exit 1
fi

if [[ -z "${SEED}" ]]; then
    SEED=None
fi

if [[ -z "${BATCH_SIZE}" ]]; then
    BATCH_SIZE=1
fi

if [[ -z "${TOP_K}" ]]; then
    TOP_K=40
fi

if [[ -z "${TOP_P}" ]]; then
    TOP_P=0.9
fi

echo -e "FROM gpt-2-${MODEL_NAME,,}
CMD python src/export_for_serving.py --model_name ${MODEL_NAME} --seed ${SEED} --batch_size ${BATCH_SIZE} --top_k ${TOP_K} --length ${LENGTH}" \
 | docker build -t gpt-2-${MODEL_NAME,,}.${BATCH_SIZE}.${TOP_K}.${TOP_P}.${LENGTH} -

docker run --mount type=bind,source=$(pwd)/export,target=/gpt-2/models/${MODEL_NAME}/export --gpus 1 -t gpt-2-${MODEL_NAME,,}.${BATCH_SIZE}.${TOP_K}.${TOP_P}.${LENGTH}