#!/bin/bash

echo "iteration_number,pod_name,total_time_taken" >startup-times-wasm.csv

kubectl apply -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true

for i in {1..200}; do
    echo "----------------------------------------------------------------"
    echo "Iteration $i"

    echo "--- Wasm -------------------------------------------------------"

    echo "Deleting Wasm pod"

    kubectl delete pod -l app=lookup-wasm

    sleep 10

    echo "Storing the Wasm pod data"

    echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >>startup-times-wasm.csv

done
