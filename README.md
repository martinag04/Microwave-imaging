# Microwave Imaging — TSVD Reconstruction and FEM/CST Operators
MATLAB scripts for microwave imaging reconstruction using truncated singular value decomposition (TSVD), with electromagnetic operators obtained from finite-element method (FEM) simulations or CST Studio Suite field exports.

The repository includes tools for operator generation, image reconstruction, and supporting data processing.

This is the link: https://drive.google.com/drive/folders/1Z3mNEYeq3iKy3J1iuyVgbMOIFptgYwZ4?usp=sharing for download the Operator for CST and FEM imaging and the field for the CST Operator



## Repository structure

| Directory | Description |
|---|---|
| `Imaging_FEM/` | Imaging scripts using the FEM-based operator. |
| `Imaging_CST/` | Imaging scripts using the CST-based operator. |
| `Imaging_CST/OP/` | Location of the operator used for CST-based reconstruction. |
| `make_operator_CST/` | Scripts and input files for constructing the operator from CST field exports. |
| `make_operator_CST/Fields/` | Electromagnetic field exports used for CST operator generation. |

## Imaging method

Image reconstruction uses a discretized linear forward model:

$$
\mathbf{b} \approx \mathbf{A}\mathbf{x},
$$

where $\mathbf{b}$ is the data vector, $\mathbf{A}$ is the electromagnetic operator, and $\mathbf{x}$ is the unknown contrast distribution.

TSVD provides a regularized solution by retaining a selected number of singular components of the operator. The truncation parameter controls the balance between reconstruction detail and sensitivity to noise.


## FEM-based operator generation

The scripts in `make_operator_FEM/` construct the imaging operator from electromagnetic fields obtained through FEM simulations.

The resulting operator describes the relationship between the unknown contrast distribution and the scattering data and is subsequently used for TSVD reconstruction in `Imaging_FEM/`. The operator file must be placed at:

`Imaging_FEM/Operator_1G0.mat`

Before generating the operator, check the input field files, mesh information, operating frequency, background dielectric properties, and antenna ordering. These settings must be consistent with those used for image reconstruction.

## Supporting libraries

The `lib/` subfolders contain MATLAB functions and supporting files used by the imaging scripts.

These utilities support tasks such as:

- Loading operators and electromagnetic data.
- Reading and processing S-parameters.
- Computing differential scattering data.
- Handling imaging grids and spatial masks.
- Formatting and visualizing reconstructed images.
- Displaying reference geometries.

Add the `lib/` folder associated with the selected imaging workflow to the MATLAB path before running the scripts. Each workflow should use its corresponding library, as functions with the same name may have different implementations or settings.


## CST-based operator generation and imaging

The scripts in `make_operator_CST/` construct the imaging operator from electromagnetic fields exported from CST Studio Suite.

The reconstruction scripts are located in `Imaging_CST/`. The provided operator must be placed at:

`Imaging_CST/OP/CartesianOperator_MT-triu_half-brainDX_1G3.mat`

Field exports, operator construction, and measurement data must use consistent antenna indexing, frequencies, coordinate systems, and units.

## Download operator files

The operator matrices are distributed separately because of their file sizes.

Download them from the [[operator data folder](INSERT_DOWNLOAD_LINK_HERE)](https://drive.google.com/drive/folders/1Z3mNEYeq3iKy3J1iuyVgbMOIFptgYwZ4?usp=sharing ), then place them in the locations specified above. Keep the original filenames.

## Getting started

1. Download or clone this repository.
2. Download the required operator matrices.
3. Place the matrices in their corresponding folders.
4. Open the project folder in MATLAB.
5. Add the required function folders to the MATLAB path.
6. Configure the input files and reconstruction parameters.
7. Run the selected FEM-based or CST-based imaging script.

## Requirements

- MATLAB.
- The input data and operator matrix required by the selected reconstruction script.
- CST Studio Suite when generating new electromagnetic field simulations.

Additional toolbox or solver requirements depend on the scripts being used.
