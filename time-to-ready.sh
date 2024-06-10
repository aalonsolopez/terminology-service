#!/bin/bash

echo "iteration_number,pod_name,total_time_taken" > startup-times-standard.csv

echo "iteration_number,pod_name,total_time_taken" > startup-times-wasm.csv

for i in {1..200}; do
    echo "----------------------------------------------------------------"
    echo "Iteration $i"

    echo "--- Wasm -------------------------------------------------------"

    echo "Deploying K8s Wasm deployment"

    kubectl apply -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true
    sleep 5

    echo "Storing the Wasm pod data"

    echo echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >> startup-times-wasm.csv

    echo "Deleting Wasm deployment"

    kubectl delete -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true
    sleep 5

    echo "--- Standard ---------------------------------------------------"

    echo "Deploying K8s Standard deployment"

    kubectl apply -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true
    sleep 5

    echo "Storing the Standard pod data"

    echo echo "$i,$(journalctl -u k3s.service -o cat | grep -E '*podStartE2EDuration*' | awk '{print $9,$11}' | tail -1 | awk -F'"' '{print $2","$4}')" >> startup-times-standard.csv

    echo "Deleting Standard deployment"

    kubectl delete -f src/functions/lookup/wasm/kubernetes/000-k8s-deployment.yaml --wait=true
    sleep 5
done
