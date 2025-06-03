pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-southeast-1'                       // Update if needed
    ECR_REGISTRY = '547694239239.dkr.ecr.ap-southeast-1.amazonaws.com/caringup_demo'
    ECR_REPO = 'caringup_demo'
    IMAGE_TAG = 'latest'
    CLUSTER_NAME = 'demo-eks'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git 'https://github.com/VMoshik/my-static-site.git' // Replace with your repo URL
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
