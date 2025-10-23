APP URL
http://50.18.64.238/
GOOGLE DOCS URL FOR SETUP INSTRUCTION
https://docs.google.com/document/d/1iUxXsZqSstiGU9n7nNCov6CBZxXj7JrdlYMRFLYtAJw/edit?usp=sharing

PIPELINE SUMMARY

---

Jenkins Pipeline Stages

This pipeline automates the build and deployment of a static React application using Docker and Jenkins. It supports both development and production environments based on the active Git branch.

 Stage Breakdown

- **Checkout**  
  Clones the specified branch (`dev` or `main`) from the GitHub repository to ensure the pipeline operates on the latest codebase.

- **Build Docker Image**  
  Executes a custom `build.sh` script to build a Docker image for the React application. The image is tagged with `latest` and prepared for registry upload.

- **Push to DockerHub**  
  Authenticates with Docker Hub using Jenkins credentials and pushes the image to the appropriate registry:
  - `capstone-dev` for the `dev` branch
  - `capstone-prod` for the `main` branch  
  Other branches skip this step to avoid unintended deployments.

- **Deploy to EC2**  
  Uses SSH to connect to the target EC2 instance. It clones or updates the deployment repository, resets the working directory, and runs `deploy.sh` to start the containerized app.

- **Post Actions**  
  Logs a success message if all stages complete, or a failure message if any stage fails. These logs help with quick debugging and pipeline status tracking.


