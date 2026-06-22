
## 3D surface reconstruction:

The code reconstructs a 3D surface from 2D geodesic distances. 

It supports both generated 3D surfaces (e.g. bump, bent tube) and loaded surface data (facial expressions, stretched/unstretched), each formatted as 3D point clouds.

Geodesic distances from all points to all other points are first approximated from 3D point cloud data using k-nearest-neighbours and a shortest path algorithm (Dijkstra). 

The surface is reconstructed, using the geodesic distances only, with optionality for four variants of multidimensional scaling (MDS). 

Reconstruction accuracy is evaluated using Procrustes analysis, with an overall error metric (d-value) and a top down heat map to show where errors occur.


## What the code does: 

1. Generate or load 3D surface data as point cloud

2. Approximate geodesic distances using a k-NN graph and Dijkstra's shortest path algorithm

3. Reconstruct the surface using MDS (various methods)

4. Visualise the reconstructed surface

5. Evaluate reconstruction accuracy via Procrustes analysis (d-value and heat map)


## How to run: 

- If using loaded data, edit the file path in load_points3D

- In `master.m`, comment out unselected options for steps 1 and 3, and choose k in step 2 (e.g. k = 10)

- Run `master.m`
