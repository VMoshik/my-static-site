pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-south-1'                       // Update if needed
    ECR_REGISTRY = '<your_aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com'
    ECR_REPO = 'static-site'
    IMAGE_TAG = 'latest'
    CLUSTER_NAME = '<your_eks_cluster_name>'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git 'https://github.com/<your-username>/<your-repo>.git' // Replace with your repo URL
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
      }
    }

    stage('Push to ECR') {
      steps {
        sh '''
        aws ecr get-login-password --region $AWS_REGION | \
        docker login --username AWS --password-stdin $ECR_REGISTRY

        docker tag $ECR_REPO:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
        docker push $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
        kubectl apply -f deployment.yaml
        kubectl apply -f service.yaml
        '''
      }
    }
  }
}
