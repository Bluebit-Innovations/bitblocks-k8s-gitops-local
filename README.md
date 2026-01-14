
# Kubernetes Local GitOps Quickstart

A GitOps focused project for consistent application deployment across local Kubernetes clusters with built-in observability and security.

# Introduction
The goal of this project is to create a GitOps-focused service that enables consistent application deployment across various local Kubernetes clusters (Kind, K3S, Microshift, etc.). It provides a unified platform to manage, deploy, and observe applications in local development environments and CI/CD pipelines, with built-in observability and security policies.

## Project Structure

This directory contains the following components:

- **infra/** - Terraform infrastructure to configure and setup local Kubernetes clusters (Kind, K3S, Microshift, etc.)
    - GitOps configuration
    - Observability stack
    - Security policies

- **ops/** - Operational services for cluster management
    - GitOps automation
    - Observability and monitoring
    - Security enforcement

- **kubernetes/** - Kubernetes configuration files for cluster deployment
    - Kind cluster configs
    - Microshift cluster configs

- **services/** - Supporting services (databases, caches, event buses, etc.)

- **apps/** - Core applications for local testing