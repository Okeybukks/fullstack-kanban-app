# Kubernetes Sealed Secret Generator
This script generates a Kubernetes sealed secret from environment variables input by the user. It encodes the secret data and saves it as a JSON file, then converts it to YAML format using `kubeseal`.

### Prerequisites

- Python 3.x
- kubeseal command-line tool 

### Usage
1. Clone or download the script file `secret.py`.
2. Open a terminal and navigate to the directory containing the script.
3. Run the script by executing the command:

    ```
    python3 secret.py
    ```
4. Follow the prompts to input the secret name, namespace, and environment variables.

    - For environment variables input, choose between command-line input (`CLI`) or input from a file (`file`).
    - When choosing file input, ensure the file contains variables in the format Variable=Value on separate lines.
5. Once all environment variables are provided, the script will generate a Kubernetes secret and save it to a JSON file (`mysecret.json`) in the same directory as the script.
6. The script will then convert the generated secret to a sealed Kurbenetes secret(`sealedsecret.yaml`) using the kubeseal command-line tool. Ensure kubeseal is properly configured and accessible in your environment.

### Example

Here's an example of how to use the script:

1. Execute the script:

    ```
    python3 secret.py
    ```
2. Enter the requested information:

    - Secret Name: my-secret
    - Namespace: my-namespace
    - Data Input Type: cli
3. Input environment variables:
    ```
    Input your Variable and its value in this format: Variable=Value: DB_HOST=localhost
    Input your Variable and its value in this format: Variable=Value: DB_USER=admin
    Input your Variable and its value in this format: Variable=Value: DB_PASSWORD=mysecretpassword
    Input your Variable and its value in this format: Variable=Value: stop
    ```
4.  The script will generate mysecret.json containing the Kubernetes secret and sealedsecret.yaml with the sealed version of the secret.
5. You can then apply the sealed secret YAML file to your Kubernetes cluster:

    ```
    kubectl apply -f sealedsecret.yaml
    ```
This example demonstrates how to use the script to generate and deploy sealed secrets in a Kubernetes environment.

You can check out a Video demonstartion of the script wit this [link](https://www.loom.com/share/576b877c11b744d09969f6ec1fb8b0dc?sid=98b5366a-04b5-4d50-9fc1-f2fc6bfdcfc4).
