# Bioinformatics Containers

## 1. Why Containers?

Have you ever tried to run a tool that worked perfectly on a colleague's laptop, only to face hours of installation errors on your own machine? This is the exact problem containers solve.

In bioinformatics, reproducibility is critical. A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another.

In this workshop, we will use containers to build reproducible steps of a Nextflow pipeline.

Why are they useful?

- **Reproducibility**: A containerized pipeline run today will produce the exact same results 5 years from now.
- **Dependency Isolation**: Need a specific version for one tool? Containers keep their environments entirely separated.
- **Portability**: You can move the exact same environment from your laptop to a massive HPC cluster or the cloud.

## 2. Key Concepts and DockerHub

- **Image**: A read-only blueprint containing the OS, software, and dependencies.
- **Container**: A running, active instance of an image.
- **Dockerfile**: A simple text script containing the instructions used to build an image.
- **![DockerHub](https://github.com/user-attachments/assets/0d7ffc96-c457-4631-b3cb-e7d332f6d2c8)**: "GitHub for Docker images." It is a public registry where developers upload their built images so others can download (pull) and use them.

## 3. Basic Structure of a Dockerfile

### FROM

The starting point or base image.

```dockerfile
FROM ubuntu:22.04
```

For ML pipelines, you might use a base image that already has Python and some libraries installed:

```dockerfile
FROM python:3.10-slim
```

For R pipelines, you might use a base image that already has R installed:

```dockerfile
FROM rocker/r-ver:4.3.1
```

Running conda environments:

```dockerfile
FROM continuumio/miniconda3:latest
```

**3.1. Why is it better to use `python:slim` instead of full Ubuntu?**

**3.2. How do you know which base image to use for your tool?**

### RUN

```dockerfile
RUN apt-get update && apt-get install -y fastqc
```

Recommended:

```dockerfile
RUN apt-get update && \
    apt-get install -y fastqc && \
    rm -rf /var/lib/apt/lists/*
```

**3.3. Why is it important to clean up the cache after installing packages?**

**3.4. Why do we delete `/var/lib/apt/lists/*`?**

### WORKDIR

```dockerfile
WORKDIR /data
```

**3.5. What happens if you don't set `WORKDIR`?**

### COPY

```dockerfile
COPY script.sh /usr/local/bin/script.sh
```

**3.6. Why is `COPY` preferred over downloading files inside the container?**

### ENV

```dockerfile
ENV PATH="/usr/local/bin:${PATH}"
ENV LC_ALL=C
```

**3.7. Why is setting `LC_ALL` sometimes important in bioinformatics?**

### CMD vs ENTRYPOINT

```dockerfile
CMD ["fastqc", "--version"]
```

```dockerfile
ENTRYPOINT ["fastqc"]
```

**3.8. When would `ENTRYPOINT` be better than `CMD` in a bioinformatics container?**

## 4. Building & Running: Docker vs. Apptainer

```bash
cd 02_Containers/seqkit_container

docker compose build          # or docker compose up --build

docker run --rm seqkit-workshop seqkit --help
# or
docker compose run seqkit seqkit --help
```

**4.1. Why is `--rm` useful when testing?**

Docker requires root privileges, which is why most HPC systems use **Apptainer** instead.

## 5. Building Your Own Containers

Each group builds one container:

| Group | Tool |
|------|------|
| Group 1 | FastQC + MultiQC |
| Group 2 | Trimmomatic |
| Group 3 | Salmon |
| Group 4 | R + limma |

### Workflow

1. Write your Dockerfile.
2. Commit and push.
3. GitHub Actions builds and pushes the image.
4. Test with Apptainer.

```bash
ml apptainer
apptainer exec docker://hcemm/bioinfo-workshop:group_tag installed_tool --version
```

Questions:

- 5.1. What is the difference between an image and a container?
- 5.2. Why do we need containers on HPC?
- 5.3. Why do containers improve reproducibility?
- 5.4. What happens if two tools require different Python versions?
- 5.5. Could you fully reproduce a container without internet access?
- 5.6. What is the weakest point of container reproducibility?

## Answers

<details>
<summary><strong>3.1</strong></summary>

`python:slim` is much smaller than Ubuntu, resulting in faster builds, downloads, and fewer unnecessary packages.

</details>

<details>
<summary><strong>3.2</strong></summary>

Choose the image closest to your software ecosystem (Python, R, Conda, BioContainers, etc.).

</details>

<details>
<summary><strong>3.3</strong></summary>

Cleaning the cache reduces image size and removes unnecessary temporary files.

</details>

<details>
<summary><strong>3.4</strong></summary>

`/var/lib/apt/lists/` contains package indexes that are no longer needed after installation.

</details>

<details>
<summary><strong>3.5</strong></summary>

Without `WORKDIR`, commands execute in `/`, making relative paths less predictable.

</details>

<details>
<summary><strong>3.6</strong></summary>

`COPY` keeps builds reproducible and avoids relying on external downloads.

</details>

<details>
<summary><strong>3.7</strong></summary>

`LC_ALL=C` ensures consistent locale-dependent behavior such as sorting.

</details>

<details>
<summary><strong>3.8</strong></summary>

Use `ENTRYPOINT` when the container is dedicated to running a single application.

</details>

<details>
<summary><strong>4.1</strong></summary>

`--rm` automatically removes the temporary container after execution.

</details>

<details>
<summary><strong>5.1–5.6</strong></summary>

- Image = blueprint; Container = running instance.
- HPC uses containers for reproducibility and software isolation.
- Containers isolate dependencies.
- Different Python versions can coexist in separate containers.
- Full reproducibility without internet requires all dependencies to already be inside the image.
- The weakest point is reliance on external repositories and downloads during image builds.

</details>

## 6. Example Dockerfile

```dockerfile
FROM ubuntu:22.04

LABEL maintainer="your-name" \
      description="Example container"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /work

COPY script.sh /work/

CMD ["bash"]
```

| Previous | Home | Next |
|-----------|------|------|
| [GitHub](../01_GitHub/README.md) | [Home](../README.md) | [Workflow Managers](../03_Workflow_Managers/README.md) |
