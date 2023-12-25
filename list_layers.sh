#!/bin/bash

# Get a list of all image IDs
image_ids=$(docker images -q)

# Iterate through each image ID
for image_id in $image_ids; do
    echo "Layers for image $image_id:"
    
    # Use docker history to get the layers for each image
    docker history --no-trunc $image_id | awk '{if(NR>1)print $1}'
    
    echo ""
done
